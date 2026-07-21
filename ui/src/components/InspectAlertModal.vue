<!--
  Copyright (C) 2026 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <NsModal
    size="small"
    :visible="isShown"
    @modal-hidden="onModalHidden"
    @primary-click="onModalHidden"
  >
    <template slot="title">{{ $t("alerts.inspect_title") }}</template>
    <template slot="content">
      <div v-if="alert">
        <div class="key-value-setting">
          <span class="label">{{ $t("alerts.inspect_source_ip") }}</span>
          <span class="value">{{ alert.source ? alert.source.ip : "-" }}</span>
        </div>
        <div class="key-value-setting">
          <span class="label">{{ $t("alerts.inspect_country") }}</span>
          <span class="value">{{
            formatCountry(alert.source && alert.source.cn)
          }}</span>
        </div>
        <div class="key-value-setting">
          <span class="label">{{ $t("alerts.inspect_scenario") }}</span>
          <span class="value"
            >{{ alert.scenario }} (v{{ alert.scenario_version }})</span
          >
        </div>
        <div class="key-value-setting">
          <span class="label">{{ $t("alerts.inspect_attack_window") }}</span>
          <span class="value">
            {{ formatDate(new Date(alert.start_at), "yyyy-MM-dd HH:mm:ss") }}
            →
            {{ formatDate(new Date(alert.stop_at), "yyyy-MM-dd HH:mm:ss") }}
          </span>
        </div>
        <div class="key-value-setting">
          <span class="label">{{ $t("alerts.inspect_action_applied") }}</span>
          <span class="value">
            <template v-if="alert.decisions && alert.decisions.length">
              <NsTag
                v-if="isBanExpired(alert.decisions[0].duration)"
                kind="blue"
                :label="$t('alerts.inspect_block_expired')"
              />
              <template v-else>
                <NsTag kind="red" :label="$t('alerts.decision_ban')" />
                {{ formatBanDuration(alert.decisions[0].duration) }}
              </template>
            </template>
            <template v-else>{{ $t("alerts.inspect_no_action") }}</template>
          </span>
        </div>
        <div class="key-value-setting">
          <span class="label">{{ $t("alerts.inspect_events_detail") }}</span>
          <span class="value">
            {{ alert.events_count }}
            ({{ $t("alerts.inspect_detection_window") }} {{ alert.leakspeed }},
            {{ $t("alerts.inspect_threshold") }} {{ alert.capacity }})
          </span>
        </div>
        <div class="key-value-setting">
          <span class="label">{{ $t("alerts.inspect_simulated") }}</span>
          <span class="value">{{
            alert.simulated ? $t("alerts.yes") : $t("alerts.no")
          }}</span>
        </div>
        <div class="key-value-setting raw-message mg-top-md">
          <span class="label">{{ $t("alerts.inspect_message") }}</span>
          <span class="value">{{ alert.message }}</span>
        </div>
        <h5 class="mg-top-md">{{ $t("alerts.inspect_events_list") }}</h5>
          <NsDataTable
            v-if="alert.events && alert.events.length"
            :allRows="alert.events"
            :columns="eventsI18nColumns"
            :rawColumns="eventsColumns"
            rowSize="compact"
            :pageSizes="[5, 10, 25]"
            :itemsPerPageLabel="core.$t('pagination.items_per_page')"
            :rangeOfTotalItemsLabel="core.$t('pagination.range_of_total_items')"
            :ofTotalPagesLabel="core.$t('pagination.of_total_pages')"
            :backwardText="core.$t('pagination.previous_page')"
            :forwardText="core.$t('pagination.next_page')"
            :pageNumberLabel="core.$t('pagination.page_number')"
            @updatePage="eventsPage = $event"
          >
            <template slot="data">
              <cv-data-table-row v-for="(event, i) in eventsPage" :key="i">
                <cv-data-table-cell>{{
                  formatEventTimestamp(event)
                }}</cv-data-table-cell>
                <cv-data-table-cell>{{
                  getMetaValue(event, "service")
                }}</cv-data-table-cell>
              </cv-data-table-row>
            </template>
          </NsDataTable>
        <div v-else>
          {{ $t("alerts.no_events") }}
        </div>
      </div>
    </template>
    <template slot="primary-button">{{ core.$t("common.close") }}</template>
  </NsModal>
</template>

<script>
import {
  UtilService,
  IconService,
  DateTimeService,
} from "@nethserver/ns8-ui-lib";
import { formatCountry } from "../lib/country";
export default {
  name: "InspectAlertModal",
  mixins: [UtilService, IconService, DateTimeService],
  props: {
    isShown: Boolean,
    alert: { type: Object, default: null },
    core: { type: Object },
  },
  data() {
    return {
      eventsPage: [],
      eventsColumns: ["timestamp", "service"],
    };
  },
  computed: {
    eventsI18nColumns() {
      return this.eventsColumns.map((column) =>
        this.$t("alerts.inspect_" + column)
      );
    },
  },
  methods: {
    formatCountry(cn) {
      return formatCountry(cn, this.$i18n.locale);
    },
    onModalHidden() {
      this.$emit("hide");
      this.$emit("after-hide");
    },
    getMetaValue(event, key) {
      if (!event.meta) return "-";
      const m = event.meta.find((m) => m.key === key);
      return m ? m.value : "-";
    },
    formatEventTimestamp(event) {
      const ts = this.getMetaValue(event, "timestamp");
      if (ts === "-") return "-";
      try {
        return this.formatDate(new Date(ts), "yyyy-MM-dd HH:mm:ss");
      } catch (e) {
        return ts;
      }
    },
    isBanExpired(rawDuration) {
      const duration = (rawDuration || "").split(".")[0];
      return duration.startsWith("-");
    },
    formatBanDuration(rawDuration) {
      const duration = (rawDuration || "").split(".")[0];
      const spaced = duration.replace(/([hms])(?=.)/g, "$1 ");
      return `${spaced} ${this.$t("alerts.inspect_remaining")}`;
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

.key-value-setting {
  margin-bottom: 0.35rem;
}

.raw-message {
  display: flex;
  flex-direction: column;

  .value {
    margin-top: 0.25rem;
    word-break: break-word;
  }
}

.mg-top-md {
  margin-top: $spacing-08;
}

h5.mg-top-md {
  margin-bottom: 0.5rem;
}

// Figma shows a grey pagination bar, not the default white
::v-deep .bx--pagination,
::v-deep .bx--pagination .bx--select-input {
  background-color: $ui-01;
}
</style>
