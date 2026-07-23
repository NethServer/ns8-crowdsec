/*
 * Copyright (C) 2026 Nethesis S.r.l.
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

// Format a 2-letter ISO country code as a localized "Name (CODE)" string.
// Falls back to the code alone when unknown, or the raw value when invalid.
export function formatCountry(cn, locale) {
  if (!cn) return "-";
  const code = cn.toUpperCase();
  try {
    const regionNames = new Intl.DisplayNames([locale || "en"], {
      type: "region",
    });
    const name = regionNames.of(code);
    return name && name !== code ? `${name} (${code})` : code;
  } catch (e) {
    // invalid code (Intl throws RangeError) -> show raw value
    return cn;
  }
}
