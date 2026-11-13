/*
 * Copyright (C) 2026 Nethesis S.r.l.
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

// Normalize a Go-style duration: drop fractional seconds and space every
// unit ("133h40m41.123456s" -> "133 h 40 m 41 s")
export function formatDuration(duration) {
  if (!duration) return duration;
  return duration
    .replace(/^-/, "")
    .replace(/\.\d+s$/, "s")
    .replace(/(\d)([hms])/g, "$1 $2")
    .replace(/([hms])(?=\d)/g, "$1 ");
}
