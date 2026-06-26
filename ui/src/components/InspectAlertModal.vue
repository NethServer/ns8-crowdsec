<!--
  Copyright (C) 2026 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <NsModal
    size="lg"
    :visible="isShown"
    @modal-hidden="onModalHidden"
    @primary-click="onModalHidden"
  >
    <template slot="title">{{ $t("alerts.inspect_title") }}</template>
    <template slot="content">
      <div v-if="alert">
        <div class="key-value-setting">
          <span class="label">{{ $t("alerts.inspect_message") }}</span>
          <span class="value">{{ alert.message }}</span>
        </div>
        <div class="key-value-setting">
          <span class="label">{{ $t("alerts.inspect_source_ip") }}</span>
          <span class="value">
            {{ alert.source ? alert.source.ip : "-" }}
            <span v-if="alert.source && alert.source.cn"> ({{ alert.source.cn }})</span>
          </span>
        </div>
        <div class="key-value-setting">
          <span class="label">{{ $t("alerts.inspect_scenario") }}</span>
          <span class="value">{{ alert.scenario }} (v{{ alert.scenario_version }})</span>
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
          <span class="label">{{ $t("alerts.inspect_events_detail") }}</span>
          <span class="value">
            {{ alert.events_count }} × {{ alert.leakspeed }},
            {{ $t("alerts.inspect_capacity") }}: {{ alert.capacity }}
          </span>
        </div>
        <div class="key-value-setting">
          <span class="label">{{ $t("alerts.inspect_decision") }}</span>
          <span class="value">
            <template v-if="alert.decisions && alert.decisions.length">
              {{ alert.decisions[0].type }} ({{ alert.decisions[0].duration }})
            </template>
            <template v-else>-</template>
          </span>
        </div>
        <div class="key-value-setting">
          <span class="label">{{ $t("alerts.inspect_remediation") }}</span>
          <span class="value">
            <NsTag
              :kind="alert.remediation ? 'green' : 'gray'"
              :label="alert.remediation ? $t('alerts.yes') : $t('alerts.no')"
            />
          </span>
        </div>
        <div class="key-value-setting">
          <span class="label">{{ $t("alerts.inspect_simulated") }}</span>
          <span class="value">
            <NsTag
              :kind="alert.simulated ? 'blue' : 'gray'"
              :label="alert.simulated ? $t('alerts.yes') : $t('alerts.no')"
            />
          </span>
        </div>
        <h5 class="mg-top-md">{{ $t("alerts.inspect_events_list") }}</h5>
        <cv-structured-list v-if="alert.events && alert.events.length">
          <template slot="headings">
            <cv-structured-list-heading>{{ $t("alerts.inspect_timestamp") }}</cv-structured-list-heading>
            <cv-structured-list-heading>{{ $t("alerts.inspect_service") }}</cv-structured-list-heading>
          </template>
          <template slot="items">
            <cv-structured-list-item
              v-for="(event, i) in pagedEvents"
              :key="i"
            >
              <cv-structured-list-data>{{ formatEventTimestamp(event) }}</cv-structured-list-data>
              <cv-structured-list-data>{{ getMetaValue(event, "service") }}</cv-structured-list-data>
            </cv-structured-list-item>
          </template>
        </cv-structured-list>
        <cv-pagination
          v-if="alert.events && alert.events.length > eventsPageSize"
          :number-of-items="alert.events.length"
          :page-sizes="[eventsPageSize]"
          :page="eventsPage"
          :backward-text="core.$t('pagination.previous_page')"
          :forward-text="core.$t('pagination.next_page')"
          :page-number-label="core.$t('pagination.page_number')"
          :items-per-page-label="core.$t('pagination.items_per_page')"
          :range-of-total-items-label="core.$t('pagination.range_of_total_items')"
          :of-total-pages-label="core.$t('pagination.of_total_pages')"
          @change="onEventsPageChange"
        />
        <div v-if="!alert.events || !alert.events.length">{{ $t("alerts.no_events") }}</div>
      </div>
    </template>
    <template slot="primary-button">{{ core.$t("common.close") }}</template>
  </NsModal>
</template>

<script>
import { UtilService, IconService, DateTimeService } from "@nethserver/ns8-ui-lib";
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
      eventsPage: 1,
      eventsPageSize: 5,
    };
  },
  computed: {
    pagedEvents() {
      if (!this.alert || !this.alert.events) return [];
      const start = (this.eventsPage - 1) * this.eventsPageSize;
      return this.alert.events.slice(start, start + this.eventsPageSize);
    },
  },
  watch: {
    alert() {
      this.eventsPage = 1;
    },
  },
  methods: {
    onModalHidden() {
      this.$emit('hide');
      this.$emit('after-hide');
    },
    onEventsPageChange(pagination) {
      this.eventsPage = pagination.page;
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
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

.key-value-setting {
  margin-bottom: 0.35rem;
}

h5.mg-top-md {
  margin-top: 1rem;
  margin-bottom: 0.5rem;
}

::v-deep .bx--structured-list {
  margin-bottom: 0;
}

::v-deep .bx--pagination {
  background-color: transparent;
  border-top: 1px solid $ui-03;
}

::v-deep .bx--pagination__left,
::v-deep .bx--pagination__right {
  background-color: transparent;
}

::v-deep .bx--select-input {
  background-color: transparent;
}
</style>
