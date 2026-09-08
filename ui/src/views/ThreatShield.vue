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
    <cv-row v-if="error.listThreatShield">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.list-threat-shield')"
          :description="error.listThreatShield"
          :showCloseButton="false"
        />
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
          kind="warning"
          :title="$t('threat_shield.no_entitlement_title')"
          :description="$t('threat_shield.no_entitlement_description')"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <cv-row class="equal-height-row">
      <cv-column class="bx--col-lg-8">
        <cv-tile light>
          <h4 class="mg-bottom">{{ $t("threat_shield.feeds_title") }}</h4>
          <p class="mg-bottom">{{ $t("threat_shield.feeds_description") }}</p>
          <cv-skeleton-text
            v-if="loading.listThreatShield"
            heading
            paragraph
            :line-count="6"
            width="80%"
          ></cv-skeleton-text>
          <cv-form v-else @submit.prevent="setThreatShield">
            <div v-for="feed in feeds" :key="feed.key" class="feed-row">
              <NsToggle
                :label="feed.description"
                class="maxwidth"
                :value="feed.key"
                :form-item="true"
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
              <span class="feed-count">{{
                $t("threat_shield.ips_listed", { count: feed.count })
              }}</span>
            </div>
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
              :disabled="!canEdit || loading.setThreatShield"
              >{{ $t("settings.save") }}</NsButton
            >
          </cv-form>
        </cv-tile>
      </cv-column>
      <cv-column class="bx--col-lg-8">
        <cv-tile light>
          <div class="last-import-header">
            <h4>{{ $t("threat_shield.last_import_title") }}</h4>
            <NsButton
              kind="secondary"
              :icon="Restart20"
              :loading="loading.listThreatShield"
              @click="listThreatShield"
              >{{ $t("threat_shield.refresh") }}</NsButton
            >
          </div>
          <cv-skeleton-text
            v-if="loading.listThreatShield"
            paragraph
            :line-count="3"
            width="80%"
          ></cv-skeleton-text>
          <div v-else-if="lastImport" class="mg-top">
            <div class="info-row">
              <span class="info-label">{{
                $t("threat_shield.last_import_timestamp")
              }}</span>
              <span>{{ formatDateTime(lastImport.timestamp) }}</span>
            </div>
            <NsInlineNotification
              v-if="lastImport.error"
              kind="error"
              :title="$t('threat_shield.last_import_failure')"
              :description="lastImport.error"
              :showCloseButton="false"
              class="mg-top"
            />
            <div
              v-for="feed in importedFeeds"
              :key="feed.key"
              class="info-row mg-top"
            >
              <span class="info-label">{{ feed.description }}</span>
              <NsTag
                :kind="feed.result.success ? 'green' : 'red'"
                :label="
                  feed.result.success
                    ? $t('threat_shield.last_import_entries', {
                        count: feed.result.entries,
                      })
                    : feed.result.error ||
                      $t('threat_shield.last_import_failure')
                "
              />
            </div>
          </div>
          <NsEmptyState v-else :title="$t('threat_shield.no_import_yet')" />
        </cv-tile>
      </cv-column>
    </cv-row>
    <cv-row class="equal-height-row">
      <cv-column class="bx--col-lg-8">
        <cv-tile light>
          <h4 class="mg-bottom">{{ $t("threat_shield.search_title") }}</h4>
          <p class="mg-bottom">{{ $t("threat_shield.search_hint") }}</p>
          <div class="search-row">
            <cv-text-input
              v-model="searchIp"
              :placeholder="$t('threat_shield.search_placeholder')"
              :label="''"
              :invalid-message="
                searchIp.trim() && !isValidIp
                  ? $t('threat_shield.invalid_ip')
                  : ''
              "
              @keyup.enter.native="searchThreatShieldDecision"
            ></cv-text-input>
            <NsButton
              kind="primary"
              :icon="Search20"
              class="mg-left"
              @click="searchThreatShieldDecision"
              :loading="loading.searchThreatShieldDecision"
              :disabled="loading.searchThreatShieldDecision || !isValidIp"
              >{{ $t("threat_shield.search_button") }}
            </NsButton>
          </div>
          <NsInlineNotification
            v-if="error.searchThreatShieldDecision"
            kind="error"
            :title="$t('action.search-threat-shield-decision')"
            :description="error.searchThreatShieldDecision"
            :showCloseButton="false"
            class="mg-top"
          />
          <div v-if="searchDone" class="mg-top">
            <div v-if="searchFound">
              <NsInlineNotification
                kind="warning"
                :title="$t('threat_shield.ip_found_title')"
                :description="$t('threat_shield.ip_found', { ip: searchedIp })"
                :showCloseButton="false"
              />
              <div
                v-for="(d, i) in searchDecisions"
                :key="i"
                class="decision-info mg-top"
              >
                <div class="info-row">
                  <span class="info-label">{{
                    $t("threat_shield.col_feed")
                  }}</span>
                  <span>{{ feedLabel(d.scenario) }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">{{
                    $t("threat_shield.col_value")
                  }}</span>
                  <span>{{ d.value }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">{{
                    $t("threat_shield.col_duration")
                  }}</span>
                  <span>{{ d.duration }}</span>
                </div>
              </div>
            </div>
            <NsInlineNotification
              v-else
              kind="success"
              :title="$t('threat_shield.ip_not_found_title')"
              :description="
                $t('threat_shield.ip_not_found', { ip: searchedIp })
              "
              :showCloseButton="false"
            />
          </div>
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
      Restart20,
      urlCheckInterval: null,
      feeds: [],
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
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    canEdit() {
      return this.subscription && this.entitled;
    },
    // Only the feeds the last run actually reported on: a feed enabled after
    // that run has no result to show yet.
    importedFeeds() {
      if (!this.lastImport || !this.lastImport.feeds) {
        return [];
      }
      return this.feeds
        .filter((feed) => this.lastImport.feeds[feed.key])
        .map((feed) => ({
          key: feed.key,
          description: feed.description,
          result: this.lastImport.feeds[feed.key],
        }));
    },
    isValidIp() {
      const ip = this.searchIp.trim();
      if (!ip) return false;
      const ipv4 =
        /^(25[0-5]|2[0-4]\d|1\d{2}|[1-9]\d|\d)(\.(25[0-5]|2[0-4]\d|1\d{2}|[1-9]\d|\d)){3}$/;
      const ipv6 = /^[0-9a-fA-F]{0,4}(:[0-9a-fA-F]{0,4}){2,7}$/;
      return ipv4.test(ip) || ipv6.test(ip);
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
    // Format a date in the user's locale so it matches their regional settings.
    formatDateTime(value) {
      return new Date(value).toLocaleString(this.$i18n.locale);
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
      if (!this.isValidIp) return;
      const ip = this.searchIp.trim();
      this.searchedIp = ip;
      this.searchFound = false;
      this.searchDecisions = [];
      this.searchDone = false;
      const taskAction = "search-threat-shield-decision";
      const eventId = this.getUuid();
      this.loading.searchThreatShieldDecision = true;
      this.error.searchThreatShieldDecision = "";

      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.searchThreatShieldDecisionAborted
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.searchThreatShieldDecisionAborted
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

.feed-row {
  margin-bottom: $spacing-05;
}

.feed-count {
  color: $text-02;
  font-size: 0.75rem;
}

.last-import-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.decision-info {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.info-row {
  display: flex;
  align-items: center;
  gap: 2rem;
}

.info-label {
  width: 12rem;
  font-weight: 600;
}

.search-row {
  display: flex;
  align-items: flex-end;
}

.equal-height-row {
  display: flex;
  flex-wrap: wrap;
}

.equal-height-row > [class*="bx--col"] {
  display: flex;
}

.equal-height-row ::v-deep .bx--tile {
  width: 100%;
}
</style>
