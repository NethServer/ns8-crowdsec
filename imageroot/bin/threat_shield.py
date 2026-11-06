#!/usr/bin/env python3

#
# Copyright (C) 2026 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

"""Shared helpers for the Threat Shield blocklists."""

import base64
import http.client
import json
import os
import re
import subprocess
import sys
import time
from urllib.error import HTTPError, URLError
from urllib.parse import urlsplit, urlunsplit
from urllib.request import Request, urlopen

import agent

# NethSecurity feed catalog without its `rule_4` awk rules, plus the
# Nethesis Insights entry.
CATALOG_FILE = os.path.join(os.environ.get("AGENT_INSTALL_DIR", ""), "etc", "threat-shield-feeds.json")

# Disposable cache, not included in backups.
PROBE_CACHE_FILE = "threat_shield_entitlement.json"

# Same cache lifetime as NethSecurity.
PROBE_CACHE_TTL = 6 * 3600

# Subscription provider to the __TYPE__ URL segment; only a first guess,
# the probe has the final word.
PROVIDER_TYPES = {"nsent": "enterprise", "nscom": "community"}
TYPES = ["enterprise", "community"]

HTTP_TIMEOUT = 20

# 4xx replies that do not mean "no": the server may say yes on a retry.
TRANSIENT_HTTP_CODES = {408, 429}

# Scenario tag of the imported decisions, followed by the feed key.
SCENARIO_PREFIX = "threat-shield/"

# Catalog entry served by the Nethesis Insights server, not bl.nethesis.it:
# no __TYPE__ segment, and the same host receives the pushed bans.
INSIGHTS_FEED_KEY = "nethesis-insights"

# Its key has no level suffix, so it is rated like a level 2 feed.
INSIGHTS_CONFIDENCE = 8

# Count-only nft table: one counter per feed, never blocks.
COUNT_TABLE = "inet threat_shield"

# Blocked packets per import run, last 24 hours only; not backed up.
BLOCKED_FILE = "threat_shield_blocked.json"
BLOCKED_WINDOW = 24 * 3600

# Custom allowlists and blocklists, written by set-threat-shield; backed up.
LISTS_FILE = "threat_shield_lists.json"

# Feed key prefix of the custom blocklists.
CUSTOM_PREFIX = "custom-"

# Custom list names end up in cscli allowlist names and nft set names.
NAME_RE = re.compile(r"[a-z0-9][a-z0-9-]{0,19}")
# Same as the set-threat-shield schema: http(s), no credentials.
URL_RE = re.compile(r"https?://[^/?#@\s]+([/?#]\S*)?")

# The Nethesis global allowlist and the prefix of the custom ones in cscli.
NETHESIS_ALLOWLIST = "nethesis_threat_shield"
CUSTOM_ALLOWLIST_PREFIX = "threat_shield_"

# Larger bodies are refused, not truncated: a cut line could be another address.
MAX_BODY = 64 * 1024 * 1024


def load_catalog():
    """Return the feed catalog as an ordered {key: {url_4, descr}} dict."""
    with open(CATALOG_FILE) as fp:
        return json.load(fp)


def premium_feeds(catalog):
    """The bl.nethesis.it entries of the catalog, without Nethesis Insights."""
    return {key: entry for key, entry in catalog.items() if key != INSIGHTS_FEED_KEY}


def identity():
    """Read (system_id, auth_token) from cluster/subscription on every call,
    so subscription changes apply on the next run."""
    subscription = agent.redis_connect(use_replica=True).hgetall("cluster/subscription")
    return subscription.get("system_id"), subscription.get("auth_token")


def provider_type():
    """Best guess of the __TYPE__ segment from the subscription provider."""
    provider = agent.redis_connect(use_replica=True).hget("cluster/subscription", "provider")
    return PROVIDER_TYPES.get(provider)


def strip_userinfo(url):
    """Drop the user:password@ part, so credentials never reach the logs.
    They are sent in the Authorization header instead."""
    parts = urlsplit(url)
    netloc = parts.netloc.rsplit("@", 1)[-1]
    return urlunsplit((parts.scheme, netloc, parts.path, parts.query, parts.fragment))


def feed_url(entry, subscription_type):
    """Resolve a catalog entry's url_4 into a fetchable URL."""
    return strip_userinfo(entry["url_4"]).replace("__TYPE__", subscription_type)


def allowlist_url(catalog, subscription_type):
    """URL of the Nethesis global allowlist, next to the premium feeds."""
    first = feed_url(next(iter(premium_feeds(catalog).values())), subscription_type)
    return first.rsplit("/", 1)[0] + "/whitelist.global"


def fetch(url, system_id=None, auth_token=None, timeout=HTTP_TIMEOUT):
    """GET url, with HTTP Basic credentials only when given: never pass them
    for a custom URL. Returns the decoded body."""
    request = Request(url)
    if system_id and auth_token:
        basic_auth = base64.b64encode(f"{system_id}:{auth_token}".encode()).decode()
        # Not sent again after a redirect.
        request.add_unredirected_header("Authorization", f"Basic {basic_auth}")
    try:
        with urlopen(request, timeout=timeout) as response:
            body = response.read(MAX_BODY + 1)
    except http.client.HTTPException as err:
        # e.g. InvalidURL, BadStatusLine, IncompleteRead: callers catch URLError.
        raise URLError(err) from err
    if len(body) > MAX_BODY:
        raise ValueError(f"the list is larger than {MAX_BODY} bytes")
    return body.decode(errors="replace")


def _probe(system_id, auth_token):
    """Probe the first premium feed per type: 200 entitled, 4xx no, None unknown."""
    try:
        entry = next(iter(premium_feeds(load_catalog()).values()))
    except (OSError, ValueError, StopIteration):
        return {"entitled": False, "type": None}

    guess = provider_type()
    candidates = TYPES if not guess else [guess] + [t for t in TYPES if t != guess]

    for candidate in candidates:
        try:
            fetch(feed_url(entry, candidate), system_id, auth_token, timeout=HTTP_TIMEOUT)
        except HTTPError as err:
            if err.code < 500 and err.code not in TRANSIENT_HTTP_CODES:
                continue  # a clear "no" for this type
            return None
        except (URLError, OSError):
            return None
        return {"entitled": True, "type": candidate}

    # Not entitled: keep the guess so URLs stay well-formed.
    return {"entitled": False, "type": guess}


def probe_status(refresh=False):
    """Cached {entitled, type}. Cached 6h unless refresh is requested."""
    if not refresh:
        try:
            age = time.time() - os.path.getmtime(PROBE_CACHE_FILE)
            if age < PROBE_CACHE_TTL:
                with open(PROBE_CACHE_FILE) as fp:
                    return json.load(fp)
        except (OSError, ValueError):
            pass

    system_id, auth_token = identity()
    if not system_id or not auth_token:
        # Nothing cached, so a new subscription takes effect at once.
        bust_probe_cache()
        return {"entitled": False, "type": None}

    status = _probe(system_id, auth_token)
    if status is None:
        # No clear answer: keep the last verdict, aged so the next call re-probes.
        try:
            os.utime(PROBE_CACHE_FILE, (0, 0))
        except OSError:
            pass
        return cached_probe_status()

    try:
        with open(PROBE_CACHE_FILE, "w") as fp:
            json.dump(status, fp)
    except OSError:
        pass
    return status


def cached_probe_status():
    """The cached {entitled, type}, never probing the network, whatever its
    age. No cache means not entitled."""
    try:
        with open(PROBE_CACHE_FILE) as fp:
            status = json.load(fp)
    except (OSError, ValueError):
        return {"entitled": False, "type": None}
    return {"entitled": bool(status.get("entitled")), "type": status.get("type")}


def bust_probe_cache():
    """Forget the cached probe, so a new entitlement applies at once."""
    try:
        os.unlink(PROBE_CACHE_FILE)
    except FileNotFoundError:
        pass


def _selected_keys():
    raw = os.environ.get("THREAT_SHIELD_FEEDS", "")
    return [k.strip() for k in raw.split(",") if k.strip()]


def enabled_feeds(catalog):
    """Selected catalog feeds from THREAT_SHIELD_FEEDS; unknown keys are
    left out."""
    return [key for key in _selected_keys() if key in catalog]


def valid_row(row):
    """True if a custom list row has a safe name and an http(s) URL."""
    return (isinstance(row, dict) and isinstance(row.get("name"), str)
            and isinstance(row.get("url"), str)
            and NAME_RE.fullmatch(row["name"]) is not None
            and URL_RE.fullmatch(row["url"]) is not None and len(row["url"]) <= 512)


def load_lists():
    """Custom lists, {"allowlists": [rows], "blocklists": [rows]}; invalid
    rows are dropped. Empty if the file is missing, ValueError if it is broken."""
    try:
        with open(LISTS_FILE) as fp:
            data = json.load(fp)
    except FileNotFoundError:
        data = {}
    if not isinstance(data, dict):
        raise ValueError(f"{LISTS_FILE} is not a JSON object")
    return {kind: [row for row in (data.get(kind) or []) if valid_row(row)]
            for kind in ("allowlists", "blocklists")}


def all_feeds(catalog, lists):
    """The catalog followed by the custom blocklists, as {key: {url_4, descr, custom}}."""
    feeds = dict(catalog)
    for row in lists["blocklists"]:
        feeds[CUSTOM_PREFIX + row["name"]] = {"url_4": row["url"], "custom": True,
                                              "descr": row.get("description", "")}
    return feeds


def nethesis_allowlist_enabled():
    """The Nethesis global allowlist toggle, on unless set to False."""
    return os.environ.get("THREAT_SHIELD_NETHESIS_ALLOWLIST", "True") != "False"


def insights_url():
    """Base URL of the Nethesis Insights server, from its catalog entry."""
    parts = urlsplit(load_catalog()[INSIGHTS_FEED_KEY]["url_4"])
    return f"{parts.scheme}://{parts.netloc}"


def get_confidence(key, enterprise=False):
    """Feed confidence, 1-10, or -1 when not rated.
    Same ratings as NethSecurity."""
    if not enterprise or key.startswith(CUSTOM_PREFIX):
        return -1
    if key == INSIGHTS_FEED_KEY:
        return INSIGHTS_CONFIDENCE
    if key.endswith(("lvl1", "level1")):
        return 10
    if key.endswith(("lvl2", "level2")):
        return 8
    if key.endswith(("lvl3", "level3")):
        return 6
    if key.endswith(("lvl4", "level4")):
        return 5
    return -1


def nft(script, *args):
    """Run nft, by default the script as one transaction. Returns its output,
    or None when the table is missing."""
    try:
        result = subprocess.run(["nft", *(args or ("-f", "-"))], input=script,
                                text=True, check=True, capture_output=True)
    except (OSError, subprocess.CalledProcessError) as err:
        if "No such file or directory" not in (getattr(err, "stderr", None) or ""):
            raise
        return None
    return result.stdout


def remove_counting():
    # add+delete: delete alone fails when the table is missing.
    try:
        nft(f"add table {COUNT_TABLE}\ndelete table {COUNT_TABLE}\n")
    except (OSError, subprocess.CalledProcessError) as err:
        print(agent.SD_WARNING + f"threat-shield cannot remove {COUNT_TABLE}: "
              f"{getattr(err, 'stderr', None) or err}", file=sys.stderr)


def read_counters():
    """Blocked packets per feed from the count-only table: {key: packets}.
    Missing table or read error: {}."""
    try:
        output = nft(None, "-j", "list", "counters", "table", *COUNT_TABLE.split())
        if output is None:
            return {}
        items = json.loads(output or "null")["nftables"]
    except (OSError, subprocess.CalledProcessError, ValueError, KeyError, TypeError) as err:
        print(agent.SD_WARNING + f"threat-shield cannot read the block counters: "
              f"{getattr(err, 'stderr', None) or err}", file=sys.stderr)
        return {}
    return {item["counter"]["name"]: item["counter"]["packets"]
            for item in items if "counter" in item}


def read_blocked_slots():
    """Recorded slots of the last 24 hours: [{time, feeds}]."""
    try:
        with open(BLOCKED_FILE) as fp:
            slots = json.load(fp)["slots"]
    except (OSError, ValueError, KeyError, TypeError):
        return []
    now = time.time()
    return [slot for slot in slots if now - slot.get("time", 0) < BLOCKED_WINDOW]


def blocked_last_24h():
    """Blocked packets per feed in the last 24 hours, counters not yet
    recorded included."""
    totals = {}
    for slot in read_blocked_slots() + [{"feeds": read_counters()}]:
        for key, packets in (slot.get("feeds") or {}).items():
            totals[key] = totals.get(key, 0) + packets
    return totals
