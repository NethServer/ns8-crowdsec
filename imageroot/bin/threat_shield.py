#!/usr/bin/env python3

#
# Copyright (C) 2026 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

"""Shared helpers for the Nethesis Threat Shield premium blocklists.

Imported by imageroot/bin/import-threat-shield and by the threat-shield
actions with an explicit sys.path insert on ${AGENT_INSTALL_DIR}/bin.
"""

import base64
import json
import os
import time
from urllib.error import HTTPError, URLError
from urllib.parse import urlsplit, urlunsplit
from urllib.request import Request, urlopen

import agent

# Verbatim copy of nethsecurity's packages/ns-threat_shield/files/banip.nethesis.feeds.
# `rule_4` is carried along for diffability with upstream but never used: the
# importer validates every line with the ipaddress module instead of awk.
CATALOG_FILE = os.path.join(os.environ.get("AGENT_INSTALL_DIR", ""), "threat-shield-feeds.json")

# Sibling of crowdsec_config/, like insights_last_import.json: a disposable
# cache, deliberately outside etc/state-include.conf.
PROBE_CACHE_FILE = "threat_shield_entitlement.json"

# Same window upstream uses in ns.threatshield's has_bl_entitlement().
PROBE_CACHE_TTL = 6 * 3600

# The __TYPE__ URL segment. NS8 has no ns-plug.config.type, but the
# subscription provider maps one-to-one onto the two possible values. The
# probe below still decides: a node whose provider naming doesn't match the
# plan must resolve correctly anyway.
PROVIDER_TYPES = {"nsent": "enterprise", "nscom": "community"}
TYPES = ["enterprise", "community"]

HTTP_TIMEOUT = 20

# The premium feeds' scenario tag. Defined here so import-threat-shield,
# list-threat-shield and search-threat-shield-decision share one literal.
SCENARIO_PREFIX = "threat-shield/"

# The nethesis-insights fleet-consensus list is presented to the admin as one
# more Threat Shield blocklist, but it is not a bl.nethesis.it feed: it has no
# catalog entry, it is pulled by import-blocklist on its own 15-minute timer,
# and its decisions carry the bare scenario below instead of SCENARIO_PREFIX.
INSIGHTS_FEED_KEY = "nethesis-insights"
INSIGHTS_FEED_DESCR = "Nethesis Insights - fleet consensus"
INSIGHTS_SCENARIO = "nethesis-insights"

# It carries no lvlN suffix for get_confidence() to read, so it is rated
# explicitly: a fleet consensus is strong evidence, but it comes from our own
# nodes' bans rather than curated threat intel, hence level 2's value.
INSIGHTS_CONFIDENCE = 8

# The production nethesis-insights service. INSIGHTS_SERVER_URL overrides it on
# dev deployments; no action sets that variable, it is edited by hand.
INSIGHTS_DEFAULT_URL = "https://insights.nethesis.it"


def load_catalog():
    """Return the feed catalog as an ordered {key: {url_4, rule_4, descr}} dict."""
    with open(CATALOG_FILE) as fp:
        return json.load(fp)


def identity():
    """Read (system_id, auth_token) fresh from the cluster/subscription hash.

    Never persisted into the module environment: a subscription terminated or
    re-registered elsewhere changes behaviour on the very next run, with no
    reconfiguration here.
    """
    subscription = agent.redis_connect(use_replica=True).hgetall("cluster/subscription")
    return subscription.get("system_id"), subscription.get("auth_token")


def provider_type():
    """Best guess of the __TYPE__ segment from the subscription provider."""
    provider = agent.redis_connect(use_replica=True).hget("cluster/subscription", "provider")
    return PROVIDER_TYPES.get(provider)


def strip_userinfo(url):
    """Drop the __USER__:__PASSWORD__@ userinfo, so no credential can ever
    reach a log line or an exception string. Authentication travels in the
    Authorization header instead."""
    parts = urlsplit(url)
    netloc = parts.netloc.rsplit("@", 1)[-1]
    return urlunsplit((parts.scheme, netloc, parts.path, parts.query, parts.fragment))


def feed_url(entry, subscription_type):
    """Resolve a catalog entry's url_4 into a fetchable URL."""
    return strip_userinfo(entry["url_4"]).replace("__TYPE__", subscription_type)


def allowlist_url(catalog, subscription_type):
    """The global Nethesis allowlist lives next to the feeds themselves, so it
    is derived from the catalog rather than hardcoded here."""
    first = feed_url(next(iter(catalog.values())), subscription_type)
    return first.rsplit("/", 1)[0] + "/whitelist.global"


def fetch(url, system_id, auth_token, timeout=HTTP_TIMEOUT):
    """GET url with HTTP Basic credentials. Returns the decoded body."""
    basic_auth = base64.b64encode(f"{system_id}:{auth_token}".encode()).decode()
    request = Request(url, headers={"Authorization": f"Basic {basic_auth}"})
    with urlopen(request, timeout=timeout) as response:
        return response.read().decode(errors="replace")


def _probe(system_id, auth_token):
    """Upstream's entitlement probe, extended to also resolve __TYPE__.

    Requests the first catalog feed once per candidate type: HTTP 200 means
    both "this subscription carries the blocklist entitlement" and "this is
    the right URL segment". Ordering starts from the provider guess so the
    common case costs a single request.
    """
    try:
        catalog = load_catalog()
        entry = next(iter(catalog.values()))
    except (OSError, ValueError, StopIteration):
        return {"entitled": False, "type": None}

    guess = provider_type()
    candidates = TYPES if not guess else [guess] + [t for t in TYPES if t != guess]

    for candidate in candidates:
        try:
            fetch(feed_url(entry, candidate), system_id, auth_token, timeout=HTTP_TIMEOUT)
        except (HTTPError, URLError, OSError):
            continue
        return {"entitled": True, "type": candidate}

    # Not entitled (or offline): keep the guess so URLs stay well-formed.
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
        # No identity, nothing to probe and nothing worth caching: a
        # subscription registered a minute from now must take effect at once.
        return {"entitled": False, "type": None}

    status = _probe(system_id, auth_token)
    try:
        with open(PROBE_CACHE_FILE, "w") as fp:
            json.dump(status, fp)
    except OSError:
        pass
    return status


def cached_probe_status():
    """The cached {entitled, type} verdict, never probing the network.

    For callers that must not block: expand-configuration runs as the service's
    ExecStartPre, where probe_status()'s live probe would stall the start for up
    to 2 * HTTP_TIMEOUT if bl.nethesis.it is unreachable. The cache's age is
    deliberately ignored -- a stale verdict beats no verdict, and the 6h
    threat-shield timer, set-threat-shield and subscription-changed all refresh
    it. An absent cache reads as "not entitled".
    """
    try:
        with open(PROBE_CACHE_FILE) as fp:
            status = json.load(fp)
    except (OSError, ValueError):
        return {"entitled": False, "type": None}
    return {"entitled": bool(status.get("entitled")), "type": status.get("type")}


def bust_probe_cache():
    """Forget the cached probe: an admin who just bought the entitlement must
    not be told "no" for another six hours."""
    try:
        os.unlink(PROBE_CACHE_FILE)
    except FileNotFoundError:
        pass


def _selected_keys():
    raw = os.environ.get("THREAT_SHIELD_FEEDS", "")
    return [k.strip() for k in raw.split(",") if k.strip()]


def enabled_feeds(catalog):
    """Parse THREAT_SHIELD_FEEDS, dropping keys the catalog no longer knows.

    The virtual insights key is not in the catalog, so it is filtered out here
    too: import-threat-shield only ever deals with real bl.nethesis.it feeds.
    """
    return [key for key in _selected_keys() if key in catalog]


def all_feed_keys(catalog):
    """Every key the UI can toggle: the catalog plus the virtual insights feed."""
    return list(catalog) + [INSIGHTS_FEED_KEY]


def insights_enabled():
    """Whether the admin has switched the insights consensus list on."""
    return INSIGHTS_FEED_KEY in _selected_keys()


def insights_url():
    return os.environ.get("INSIGHTS_SERVER_URL", INSIGHTS_DEFAULT_URL).rstrip("/")


def get_confidence(key, enterprise=False):
    """How much to trust a feed, 1-10, or -1 when it cannot be rated.

    Port of nethsecurity's ns.threatshield get_confidence(), kept
    behaviour-identical so the same feed is rated the same in both products.
    """
    if not enterprise:
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
