<!--
  Copyright (C) 2026 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <cv-grid fullWidth>
    <cv-row>
      <cv-column class="page-title">
        <h2>{{ $t("threat_shield.title") }}</h2>
      </cv-column>
    </cv-row>
    <cv-row v-if="!loading.listThreatShield && !subscription">
      <cv-column>
        <NsInlineNotification
          kind="info"
          :title="$t('threat_shield.no_subscription_title')"
          :description="$t('threat_shield.no_subscription_description')"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <cv-row v-else-if="!loading.listThreatShield && !entitled">
      <cv-column>
        <NsInlineNotification
          kind="info"
          :title="$t('threat_shield.no_entitlement_title')"
          :description="$t('threat_shield.no_entitlement_description')"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column>
        <cv-tile light>
          <h4>{{ $t("threat_shield.blocklist_title") }}</h4>
          <p class="mg-bottom">
            {{ $t("threat_shield.blocklist_description") }}
          </p>
          <NsButton
            kind="secondary"
            class="mg-bottom"
            :icon="Restart20"
            :loading="loading.listThreatShield"
            :disabled="
              !canEdit || loading.listThreatShield || loading.setThreatShield
            "
            @click="listThreatShield"
            >{{ $t("threat_shield.refresh") }}</NsButton
          >
          <cv-form @submit.prevent="setThreatShield">
            <NsInlineNotification
              v-for="failure in canEdit && !loading.listThreatShield
                ? importFailures
                : []"
              :key="failure.key"
              kind="error"
              :title="failure.title"
              :description="failure.error"
              :showCloseButton="false"
            />
            <NsDataTable
              :allRows="feeds"
              :columns="i18nTableColumns"
              :rawColumns="tableColumns"
              :sortable="false"
              :pageSizes="[]"
              :overflow-menu="false"
              :isLoading="loading.listThreatShield"
              :skeletonRows="6"
              :isErrorShown="!!error.listThreatShield"
              :errorTitle="$t('action.list-threat-shield')"
              :errorDescription="error.listThreatShield"
              @updatePage="tablePage = $event"
            >
              <template slot="empty-state">
                <NsEmptyState :title="$t('threat_shield.no_blocklists')" />
              </template>
              <template slot="data">
                <cv-data-table-row
                  v-for="feed in tablePage"
                  :key="feed.key"
                  :value="feed.key"
                >
                  <cv-data-table-cell>
                    <span class="feed-name">
                      {{ feed.description }}
                      <cv-interactive-tooltip
                        v-if="feed.key === insightsFeedKey"
                        alignment="start"
                        direction="bottom"
                        class="info"
                      >
                        <template slot="content">
                          {{ $t("threat_shield.insights_tooltip") }}
                        </template>
                      </cv-interactive-tooltip>
                    </span>
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    <NsToggle
                      :label="feed.description"
                      class="status-toggle"
                      hideLabel
                      :value="feed.key"
                      :form-item="false"
                      v-model="selected[feed.key]"
                      :disabled="!canEdit || loading.setThreatShield"
                    >
                      <template slot="text-left">{{
                        $t("settings.disabled")
                      }}</template>
                      <template slot="text-right">{{
                        $t("settings.enabled")
                      }}</template>
                    </NsToggle>
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    <div
                      v-if="feed.confidence > 0"
                      class="confidence"
                      role="img"
                      :aria-label="
                        $t('threat_shield.confidence_aria', {
                          level: feed.confidence,
                        })
                      "
                    >
                      <span class="confidence-label" aria-hidden="true"
                        >{{ feed.confidence }}/10</span
                      >
                      <NsProgressBar
                        :value="feed.confidence * 10"
                        height="4px"
                        class="confidence-bar"
                        aria-hidden="true"
                      />
                    </div>
                    <span v-else>-</span>
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    {{ importResult(feed) ? importResult(feed).entries : "-" }}
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    {{
                      importResult(feed) && importResult(feed).timestamp
                        ? formatDateTime(importResult(feed).timestamp)
                        : "-"
                    }}
                  </cv-data-table-cell>
                </cv-data-table-row>
              </template>
            </NsDataTable>
            <NsInlineNotification
              v-if="error.setThreatShield"
              kind="error"
              :title="$t('action.set-threat-shield')"
              :description="error.setThreatShield"
              :showCloseButton="false"
              class="mg-top"
            />
            <NsButton
              kind="primary"
              class="mg-top"
              :icon="Save20"
              :loading="loading.setThreatShield"
              :disabled="
                !canEdit || loading.listThreatShield || loading.setThreatShield
              "
              >{{ $t("settings.save") }}</NsButton
            >
          </cv-form>
        </cv-tile>
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column>
        <cv-tile light>
          <h4>{{ $t("threat_shield.search_title") }}</h4>
          <p class="mg-bottom">{{ $t("threat_shield.search_hint") }}</p>
          <div class="search-row">
            <cv-text-input
              v-model="searchIp"
              class="maxwidth"
              :placeholder="$t('threat_shield.search_placeholder')"
              :label="''"
              :invalid-message="
                error.searchIp ||
                (searchIp.trim() && !isValidIp
                  ? $t('threat_shield.invalid_ip')
                  : '')
              "
              :disabled="!canEdit"
              @keyup.enter.native="searchThreatShieldDecision"
            ></cv-text-input>
            <NsButton
              kind="primary"
              :icon="Search20"
              class="mg-left"
              @click="searchThreatShieldDecision"
              :loading="loading.searchThreatShieldDecision"
              :disabled="
                !canEdit || loading.searchThreatShieldDecision || !isValidIp
              "
              >{{ $t("threat_shield.search_button") }}
            </NsButton>
          </div>
          <div class="maxwidth">
            <NsInlineNotification
              v-if="error.searchThreatShieldDecision"
              kind="error"
              :title="$t('action.search-threat-shield-decision')"
              :description="error.searchThreatShieldDecision"
              :showCloseButton="false"
              class="mg-top"
            />
            <NsInlineNotification
              v-if="searchDone && searchFound"
              kind="warning"
              :title="$t('threat_shield.ip_found_title')"
              :description="
                $tc('threat_shield.ip_found', searchFeeds.length, {
                  ip: searchedIp,
                  feeds: formatList(searchFeeds),
                })
              "
              :showCloseButton="false"
              class="mg-top"
            />
          </div>
          <NsEmptyState
            v-if="searchDone && !searchFound"
            :title="$t('threat_shield.ip_not_found_title')"
            class="mg-top"
          >
            <template #pictogram>
              <CircleCheckPictogram />
            </template>
            <template #description>
              <div>{{ $t("threat_shield.ip_not_found") }}</div>
            </template>
          </NsEmptyState>
        </cv-tile>
      </cv-column>
    </cv-row>
  </cv-grid>
</template>

<script>
import to from "await-to-js";
import { mapState } from "vuex";
import {
  QueryParamService,
  UtilService,
  TaskService,
  IconService,
  PageTitleService,
} from "@nethserver/ns8-ui-lib";
import Restart20 from "@carbon/icons-vue/es/restart/20";
import { isValidIpAddress } from "@/lib/ip";

export default {
  name: "ThreatShield",
  mixins: [
    TaskService,
    IconService,
    UtilService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("threat_shield.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "threat-shield",
      },
      tableColumns: [
        "description",
        "enabled",
        "confidence",
        "entries",
        "last_update",
      ],
      Restart20,
      urlCheckInterval: null,
      // Must match threat_shield.INSIGHTS_FEED_KEY in the backend.
      insightsFeedKey: "nethesis-insights",
      feeds: [],
      tablePage: [],
      selected: {},
      subscription: false,
      entitled: false,
      lastImport: null,
      searchIp: "",
      searchedIp: "",
      searchFound: false,
      searchDone: false,
      searchDecisions: [],
      loading: {
        listThreatShield: false,
        setThreatShield: false,
        searchThreatShieldDecision: false,
      },
      error: {
        listThreatShield: "",
        setThreatShield: "",
        searchThreatShieldDecision: "",
        searchIp: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    canEdit() {
      return this.subscription && this.entitled;
    },
    i18nTableColumns() {
      return [
        this.$t("threat_shield.col_blocklist"),
        this.$t("threat_shield.col_status"),
        this.$t("threat_shield.col_confidence"),
        this.$t("threat_shield.col_entries"),
        this.$t("threat_shield.col_last_update"),
      ];
    },
    // Failed runs and failed enabled feeds; the table only shows "-" for them.
    importFailures() {
      const failures = [];
      if (!this.lastImport) {
        return failures;
      }
      if (this.lastImport.error) {
        failures.push({
          key: "run",
          title: this.$t("threat_shield.last_import_failure"),
          error: this.lastImport.error,
        });
      }
      const results = this.lastImport.feeds || {};
      for (const feed of this.feeds) {
        const result = results[feed.key];
        if (feed.enabled && result && !result.success) {
          failures.push({
            key: feed.key,
            title: this.$t("threat_shield.feed_import_failure", {
              feed: feed.description,
            }),
            error: result.error || this.$t("error.generic_error"),
          });
        }
      }
      return failures;
    },
    isValidIp() {
      return isValidIpAddress(this.searchIp);
    },
    // Names of the blocklists matching the searched IP, once each: a feed
    // can hold both the address and a network covering it.
    searchFeeds() {
      return [
        ...new Set(this.searchDecisions.map((d) => this.feedLabel(d.scenario))),
      ];
    },
  },
  watch: {
    searchIp() {
      this.error.searchIp = "";
    },
  },
  beforeRouteEnter(to, from, next) {
    next((vm) => {
      vm.watchQueryData(vm);
      vm.urlCheckInterval = vm.initUrlBindingForApp(vm, vm.q.page);
    });
  },
  beforeRouteLeave(to, from, next) {
    clearInterval(this.urlCheckInterval);
    next();
  },
  created() {
    this.listThreatShield();
  },
  methods: {
    // Format a date in the user's locale.
    formatDateTime(value) {
      return new Date(value).toLocaleString(this.$i18n.locale);
    },
    // Join names in the user's locale ("A, B and C").
    formatList(items) {
      return new Intl.ListFormat(this.$i18n.locale, {
        type: "conjunction",
      }).format(items);
    },
    // Last successful import of an enabled feed, or null.
    importResult(feed) {
      if (!feed.enabled || !this.lastImport || !this.lastImport.feeds) {
        return null;
      }
      const result = this.lastImport.feeds[feed.key];
      return result && result.success ? result : null;
    },
    feedLabel(scenario) {
      const key = (scenario || "").replace("threat-shield/", "");
      const feed = this.feeds.find((f) => f.key === key);
      return feed ? feed.description : scenario;
    },
    async listThreatShield() {
      this.loading.listThreatShield = true;
      this.error.listThreatShield = "";
      const taskAction = "list-threat-shield";
      const eventId = this.getUuid();

      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.listThreatShieldAborted
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.listThreatShieldCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          extra: {
            title: this.$t("action." + taskAction),
            isNotificationHidden: true,
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.listThreatShield = this.getErrorMessage(err);
        this.loading.listThreatShield = false;
      }
    },
    listThreatShieldAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.listThreatShield = this.$t("error.generic_error");
      this.loading.listThreatShield = false;
    },
    listThreatShieldCompleted(taskContext, taskResult) {
      const output = taskResult.output;
      this.feeds = output.feeds;
      this.subscription = output.subscription;
      this.entitled = output.entitled;
      this.lastImport = output.last_import || null;
      // Replace the whole object so every key is reactive in Vue 2.
      this.selected = output.feeds.reduce((acc, feed) => {
        acc[feed.key] = feed.enabled;
        return acc;
      }, {});
      this.loading.listThreatShield = false;
    },
    async setThreatShield() {
      this.loading.setThreatShield = true;
      this.error.setThreatShield = "";
      const taskAction = "set-threat-shield";
      const eventId = this.getUuid();

      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setThreatShieldAborted
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.setThreatShieldValidationFailed
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setThreatShieldCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            feeds: this.feeds
              .filter((feed) => this.selected[feed.key])
              .map((feed) => feed.key),
          },
          extra: {
            title: this.$t("action." + taskAction),
            description: this.$t("settings.processing"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.setThreatShield = this.getErrorMessage(err);
        this.loading.setThreatShield = false;
      }
    },
    setThreatShieldAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.setThreatShield = this.$t("error.generic_error");
      this.loading.setThreatShield = false;
    },
    setThreatShieldValidationFailed(validationErrors) {
      console.error("set-threat-shield validation failed", validationErrors);
      this.error.setThreatShield = this.$t("error.generic_error");
      this.loading.setThreatShield = false;
    },
    setThreatShieldCompleted() {
      this.loading.setThreatShield = false;
      this.listThreatShield();
    },
    async searchThreatShieldDecision() {
      if (!this.canEdit || !this.isValidIp) return;
      const ip = this.searchIp.trim();
      this.searchedIp = ip;
      this.searchFound = false;
      this.searchDecisions = [];
      this.searchDone = false;
      const taskAction = "search-threat-shield-decision";
      const eventId = this.getUuid();
      this.loading.searchThreatShieldDecision = true;
      this.error.searchThreatShieldDecision = "";
      this.error.searchIp = "";

      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.searchThreatShieldDecisionAborted
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.searchThreatShieldDecisionValidationFailed
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.searchThreatShieldDecisionCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: { ip },
          extra: {
            title: this.$t("action." + taskAction),
            isNotificationHidden: true,
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.searchThreatShieldDecision = this.getErrorMessage(err);
        this.loading.searchThreatShieldDecision = false;
      }
    },
    searchThreatShieldDecisionAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.searchThreatShieldDecision = this.$t("error.generic_error");
      this.loading.searchThreatShieldDecision = false;
    },
    searchThreatShieldDecisionValidationFailed(validationErrors) {
      console.error(
        "search-threat-shield-decision validation failed",
        validationErrors
      );
      for (const validationError of validationErrors) {
        if (validationError.parameter === "ip") {
          this.error.searchIp = this.$t("threat_shield.invalid_ip");
        } else {
          this.error.searchThreatShieldDecision = this.$t(
            "error.validation_error"
          );
        }
      }
      this.loading.searchThreatShieldDecision = false;
    },
    searchThreatShieldDecisionCompleted(taskContext, taskResult) {
      this.searchFound = taskResult.output.found;
      this.searchDecisions = taskResult.output.decisions;
      this.searchDone = true;
      this.loading.searchThreatShieldDecision = false;
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

.maxwidth {
  max-width: 38rem;
  width: 100%;
}

.mg-bottom {
  margin-bottom: $spacing-06;
}

.mg-top {
  margin-top: $spacing-05;
}

.mg-left {
  margin-left: $spacing-05;
}

.feed-name {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
}

.confidence {
  display: flex;
  align-items: center;
  gap: $spacing-03;
}

.confidence-label {
  min-width: 2.5rem;
  text-align: right;
}

.confidence-bar {
  width: 4.5rem;
  height: 4px;
}

.search-row {
  display: flex;
  align-items: flex-start;
}

// Match the input height to the Search button, as in Blocklists.vue
.search-row ::v-deep .bx--form-item {
  flex: 1;
}

.search-row ::v-deep .bx--label {
  display: none;
}

.search-row ::v-deep .bx--text-input {
  height: 3rem;
}

// Center the toggle in its row and keep its absolute text inside the cell
.status-toggle {
  min-width: 8.5rem;
}

.status-toggle ::v-deep .bx--toggle__switch {
  margin-top: 0;
}

::v-deep .empty-state {
  background-color: $ui-01;
}
</style>
