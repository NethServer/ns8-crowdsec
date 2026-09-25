/*
 * Copyright (C) 2026 Nethesis S.r.l.
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

const IPV4 =
  /^(25[0-5]|2[0-4]\d|1\d{2}|[1-9]\d|\d)(\.(25[0-5]|2[0-4]\d|1\d{2}|[1-9]\d|\d)){3}$/;
const HEXTET = /^[0-9a-fA-F]{1,4}$/;

// Count the hextets of one side of "::", or -1 if any is malformed.
function countHextets(part, allowIpv4Tail) {
  if (part === "") return 0;
  const groups = part.split(":");
  let count = 0;
  for (let i = 0; i < groups.length; i++) {
    if (allowIpv4Tail && i === groups.length - 1 && IPV4.test(groups[i])) {
      count += 2;
    } else if (HEXTET.test(groups[i])) {
      count += 1;
    } else {
      return -1;
    }
  }
  return count;
}

function isValidIpv6(ip) {
  const halves = ip.split("::");
  if (halves.length > 2) return false;
  if (halves.length === 1) return countHextets(ip, true) === 8;
  const head = countHextets(halves[0], false);
  const tail = countHextets(halves[1], true);
  return head >= 0 && tail >= 0 && head + tail < 8;
}

// True for a plain IPv4 or IPv6 address, as Python's ipaddress accepts it.
export function isValidIpAddress(value) {
  const ip = (value || "").trim();
  if (!ip) return false;
  return IPV4.test(ip) || isValidIpv6(ip);
}
