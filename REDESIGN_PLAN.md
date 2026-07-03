# Implement Lucia's CrowdSec UI redesign (Figma)

## Context

Figma file "NethServer-shared-file" (node `4855:51344`, CrowdSec section) contains Lucia's full IA/UX redesign for this NS8 module: reordered/renamed menu with new icons, tweaked Detections/Collections copy, and a brand-new **Blocklists** page that merges the existing separate Unban ("Banned IP") and Capi ("Threat Intelligence") views into one tabbed page (Local blocklist / Community blocklist / Allowlist), plus a simplified Settings page that moves fields out to their new homes.

Backend investigation confirms **no new backend work is needed** — every action the mockups require already exists:
- `unban-ip` task (action `unban` / `unban_all`) — `imageroot/actions/unban-ip/10unban-ip`, already used in `ui/src/views/Unban.vue`
- `search-capi-decision` task (IP lookup against CAPI/community blocklist) — already used in `ui/src/views/Capi.vue`
- `get-configuration` / `configure-module` tasks already expose `whitelists` (array of IP/CIDR/hostname strings, one per line in current Settings.vue textarea) plus all settings fields the mockup relocates (`pull_community_blocklist`, `ban_local_network`, `enroll_instance`, bantime/dyn_bantime/dynamic_bantime_duration, `group_threshold`, `helo_host`, `receiver_emails`)

This is UI-only work: new page composition, router/menu changes, i18n keys, reusing existing task calls and `@nethserver/ns8-ui-lib` shared components — no new UI primitives built from scratch.

**ns8-ui-lib components to reuse** (`NethServer/ns8-ui-lib`, `src/lib-components/index.js`):
- `NsTabs` (`src/lib-components/NsTabs.vue`, extends Carbon's `CvTabs`) — Blocklists page's 3-tab layout.
- `NsToggle` — Central API / community-blocklist / local-network-blocking switches; has built-in `cv-interactive-tooltip` support for the mockup's info tooltips.
- `NsInlineNotification` — IP-found/not-found states in Community blocklist search; already used for the disabled-email-notifications banner in Settings (see step 3).
- `NsTag` — reuse "Blocked" tag styling already used in Detections table.
- `NsButton` — tertiary "View IP reputation" / ghost "Request removal" external links, "Go to cluster settings" action.
- `NsEmptyState` — Local blocklist empty state.
- `NsDataTable` / `NsPagination` — Local blocklist and Collections tables (already in use).
- `NsTextInput` — IP search field, allowlist entries.
- `NsInfoCard` (`titleTooltip` prop) or embedded `cv-interactive-tooltip` — Block duration radio group info icon.

## Approach

### 1. Router & menu (`ui/src/router/index.js`, `ui/src/App.vue` or wherever the sidebar menu list lives)
- Remove `/unban` and `/capi` routes/menu entries entirely (per user: no redirects).
- Add `/blocklists` route → new `Blocklists.vue`.
- Reorder menu to: Status, Detections, Collections, Blocklists, Settings, About.
- Update menu icons (from Notes): Detections → `Report`, Collections → `Catalog`, Blocklists → `FirewallClassic` (from `@carbon/icons-vue`, match existing import style used for current menu icons).

### 2. New `ui/src/views/Blocklists.vue` (tabbed page)
Use `NsTabs` from `@nethserver/ns8-ui-lib` (`src/lib-components/NsTabs.vue`, extends Carbon's `CvTabs`) for the 3-tab shell. Three tabs:

**Tab "Local blocklist"** — port from `Unban.vue`:
- Reuse `NsDataTable`/`NsPagination` list of banned IPs (`list-banned-ip` task), single "Unban" per row (`unban-ip`/`action:"unban"`) and "Unban all" `NsButton` (`unban-ip`/`action:"unban_all"`) — logic already in `Unban.vue:332-410`, just move into this tab and restyle per mockup (`localblock1.png` populated, `localblock2-modal.png` empty state via `NsEmptyState`).

**Tab "Community blocklist"** — port from `Capi.vue`:
- Left card "Configuration": Central API status (`get-capi-status`), Subscription type, two `NsToggle`s moved here per Notes — "Central API and signal sharing" (`enable_online_api` + `enroll_instance` field, tooltip via `NsToggle`'s built-in `cv-interactive-tooltip`) and "Community blocklist" (`pull_community_blocklist`) — both currently in `Settings.vue`, move their fields/logic here and call `configure-module` to save (mirror `Settings.vue:472-501` pattern, scoped to just these fields).
- Right card "Search IP in community blocklist": `NsTextInput` + Search `NsButton` using `search-capi-decision` (`Capi.vue:348-373`), three states per mockups via `NsInlineNotification`: idle, not-found (`commblock-noresults`), found (`commblock-found3.png` — Reason/Action/Time remaining fields, `NsTag` reused from Detections table styling, tertiary `NsButton` "View IP reputation" + ghost `NsButton` "Request removal" external links).
- Also show CAPI decision count if available (`get-capi-count` task, already used in `Capi.vue`).

**Tab "Allowlist"** — port textarea logic from `Settings.vue`:
- Single description + `NsTextInput`(textarea mode) "Allowlist entries" (placeholder `e.g. 192.168.1.10 / 192.168.1.0/24 / trusted.example.com`, helper text, info callout "Avoid blocking trusted sources..."), Save `NsButton`.
- Reuse `whitelists` join/split-on-newline logic from `Settings.vue:351,368,447,501` and call `configure-module` with just the `whitelists` field (read current full config via `get-configuration` first, same round-trip pattern as today, just isolated to this tab so saving allowlist doesn't require touching other settings fields).

### 3. `ui/src/views/Settings.vue` — simplify per Notes
- Remove: allowlist/whitelists field, Central API/community blocklist/enroll key fields, the "Advanced" accordion — these move to Blocklists tabs (Community blocklist / Allowlist).
- Keep: Email recipients, Notification threshold (`group_threshold`), Sender domain (`helo_host`), Local network blocking, Block duration section — per `settings2.png`/`settings3.png` mockups.
- Rename "Allow bans on the local network" → "Local network blocking" (tooltip: "When enabled, CrowdSec can block IP addresses from private networks. Use with caution to avoid blocking trusted devices.")
- Rename "Ban duration" → "Block duration"; reorder radio options so "Incremental" shows first (if it's the default), add descriptions under each option ("Increase the duration for repeated detections from the same IP" / "Use the same duration for every block"); rename base-duration field label to match selected mode ("Base duration" for incremental, "Block duration" for fixed) per `settings2.png`/`settings3.png`.
- Disabled-email-notifications banner (`settings3.png`): **already implemented, keep unchanged.** `Settings.vue:33-46` already gates fields with a `mail_configured` flag and shows `<NsInlineNotification kind="info" :title="$t('settings.smarthost_is_disabled')" :description="$t('settings.smarthosts_is_needed_to_send_notifications')" :actionLabel="$t('settings.enable_smarthosts_for_notifications')" @action="goToSmarthost()" />`; `goToSmarthost()` (~line 393) does `this.core.$router.push("/settings/smarthost")`. No new logic needed — carry this block over as-is into the simplified Settings.vue.

### 4. Menu-only tweaks: Detections & Collections
- No functional change needed beyond icon (see step 1) — current `Alerts.vue`/`Collections.vue` content already matches mockups closely (per earlier exploration); just verify title/description copy matches `det1.png`/`coll-notes.png` mockups and adjust if any copy drifted.
- Detections screen 3 (delete-all confirmation) already exists as `ConfirmDeleteAlertsModal.vue` — verify wording matches mockup, no structural change expected.

### 5. i18n
- Add new namespace `blocklists` (or `blocklist`) with keys for tab labels, descriptions, and all moved/renamed strings, mirrored across all locale files (en/cs/de/es/fr/it/nl/ta/uk) — **English only gets real translations, other locales get the English fallback text** copied as-is (per stored preference: only edit `en/translation.json` with real content; do not attempt real translations in other locales).
- Remove/rename obsolete `unban`/`capi` namespace keys no longer used once views are deleted (only if nothing else references them).

### 6. Cleanup
- Delete `ui/src/views/Unban.vue` and `ui/src/views/Capi.vue` once their logic is fully absorbed into `Blocklists.vue`.

## Verification
- `cd ui && npm run build` (or existing lint/build script) to confirm no broken imports/routes after deleting Unban.vue/Capi.vue.
- Manually exercise each Blocklists tab against a running NS8 CrowdSec module instance (or existing dev/test setup for this repo) if available: unban single IP, unban all, toggle Central API/community blocklist, search an IP (found + not-found), save allowlist entries, confirm Settings still saves remaining fields correctly.
- Visually diff each rebuilt screen against the corresponding Figma mockup screenshots already gathered in this session's scratchpad directory.
