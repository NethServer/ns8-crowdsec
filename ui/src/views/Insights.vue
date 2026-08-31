<!--
  Copyright (C) 2026 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <cv-grid fullWidth>
    <cv-row>
      <cv-column class="page-title">
        <h2>{{ $t("insights.title") }}</h2>
      </cv-column>
    </cv-row>
    <cv-row v-if="error.getConfiguration">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.get-configuration')"
          :description="error.getConfiguration"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <cv-row class="equal-height-row">
      <cv-column class="bx--col-lg-8">
        <cv-tile light>
          <h4 class="mg-bottom">{{ $t("insights.connection_title") }}</h4>
          <cv-skeleton-text
            v-if="loading.getConfiguration"
            heading
            paragraph
            :line-count="6"
            width="80%"
          ></cv-skeleton-text>
          <cv-form v-else @submit.prevent="setInsights">
            <NsToggle
              :label="$t('insights.enable_insights')"
              class="maxwidth"
              value="enabled"
              :form-item="true"
              v-model="enabled"
              :disabled="loading.getConfiguration || loading.setInsights"
              ref="enabled"
            >
              <template slot="tooltip">
                <span>{{ $t("insights.enable_insights_tips") }}</span>
              </template>
              <template slot="text-left">{{
                $t("settings.disabled")
              }}</template>
              <template slot="text-right">{{
                $t("settings.enabled")
              }}</template>
            </NsToggle>
            <cv-accordion v-if="enabled" class="dependent-fields">
              <cv-accordion-item>
                <template slot="title">{{ $t("insights.advanced") }}</template>
                <template slot="content">
                  <NsTextInput
                    :label="$t('insights.base_url')"
                    :helper-text="$t('insights.base_url_helper')"
                    v-model="base_url"
                    class="mg-bottom maxwidth"
                    :disabled="loading.getConfiguration || loading.setInsights"
                    ref="base_url"
                  />
                  <NsToggle
                    :label="$t('insights.verify_tls')"
                    class="maxwidth"
                    value="verify_tls"
                    :form-item="true"
                    v-model="verify_tls"
                    :disabled="loading.getConfiguration || loading.setInsights"
                    ref="verify_tls"
                  >
                    <template slot="tooltip">
                      <span>{{ $t("insights.verify_tls_tips") }}</span>
                    </template>
                    <template slot="text-left">{{
                      $t("settings.disabled")
                    }}</template>
                    <template slot="text-right">{{
                      $t("settings.enabled")
                    }}</template>
                  </NsToggle>
                </template>
              </cv-accordion-item>
            </cv-accordion>
            <cv-row v-if="error.setInsights">
              <cv-column>
                <NsInlineNotification
                  kind="error"
                  :title="$t('action.set-insights')"
                  :description="error.setInsights"
                  :showCloseButton="false"
                />
              </cv-column>
            </cv-row>
            <NsButton
              kind="primary"
              :icon="Save20"
              :loading="loading.setInsights"
              :disabled="loading.getConfiguration || loading.setInsights"
              >{{ $t("settings.save") }}</NsButton
            >
          </cv-form>
        </cv-tile>
      </cv-column>
      <cv-column class="bx--col-lg-8">
        <cv-tile light>
          <div class="last-import-header">
            <h4>{{ $t("insights.last_import_title") }}</h4>
            <NsButton
              kind="secondary"
              :icon="Restart20"
              :loading="loading.getConfiguration"
              @click="getConfiguration"
              >{{ $t("insights.refresh") }}</NsButton
            >
          </div>
          <cv-skeleton-text
            v-if="loading.getConfiguration"
            paragraph
            :line-count="3"
            width="80%"
          ></cv-skeleton-text>
          <div
            v-else-if="config.insights && config.insights.last_import"
            class="capi-info mg-top"
          >
            <div class="info-row">
              <span class="info-label">{{
                $t("insights.last_import_timestamp")
              }}</span>
              <span>{{
                formatDateTime(config.insights.last_import.timestamp)
              }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">{{
                $t("insights.last_import_result")
              }}</span>
              <NsTag
                :kind="config.insights.last_import.success ? 'green' : 'red'"
                :label="
                  config.insights.last_import.success
                    ? $t('insights.last_import_success')
                    : $t('insights.last_import_failure')
                "
              />
            </div>
            <div class="info-row">
              <span class="info-label">{{
                $t("insights.last_import_entries")
              }}</span>
              <span>{{ config.insights.last_import.entries }}</span>
            </div>
            <NsInlineNotification
              v-if="
                !config.insights.last_import.success &&
                config.insights.last_import.error
              "
              kind="error"
              :title="$t('insights.last_import_failure')"
              :description="config.insights.last_import.error"
              :showCloseButton="false"
              class="mg-top"
            />
          </div>
          <NsEmptyState v-else :title="$t('insights.no_import_yet')" />
        </cv-tile>
      </cv-column>
    </cv-row>
    <cv-row class="equal-height-row">
      <cv-column class="bx--col-lg-8">
        <cv-tile light>
          <h4 class="mg-bottom">{{ $t("insights.allowlist_title") }}</h4>
          <p class="mg-bottom">{{ $t("insights.allowlist_description") }}</p>
          <cv-form @submit.prevent="requestAllowlist">
            <NsTextInput
              :label="$t('insights.cidr')"
              v-model.trim="cidr"
              class="mg-bottom maxwidth"
              :disabled="!enabled || loading.requestAllowlist"
              ref="cidr"
            />
            <NsTextInput
              :label="$t('insights.reason')"
              :helper-text="$t('insights.reason_helper')"
              v-model.trim="reason"
              class="mg-bottom maxwidth"
              :disabled="!enabled || loading.requestAllowlist"
              ref="reason"
            />
            <cv-row v-if="error.requestAllowlist">
              <cv-column>
                <NsInlineNotification
                  kind="error"
                  :title="$t('action.request-allowlist')"
                  :description="error.requestAllowlist"
                  :showCloseButton="false"
                />
              </cv-column>
            </cv-row>
            <NsInlineNotification
              v-if="requestResult"
              kind="success"
              :title="$t('action.request-allowlist')"
              :description="
                $t('insights.request_success', {
                  count: requestResult.requests,
                })
              "
              :showCloseButton="false"
              class="mg-bottom"
            />
            <NsButton
              kind="primary"
              :loading="loading.requestAllowlist"
              :disabled="
                !enabled ||
                loading.requestAllowlist ||
                !cidr.trim() ||
                !reason.trim()
              "
              >{{ $t("insights.request") }}</NsButton
            >
          </cv-form>
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
  name: "Insights",
  mixins: [
    TaskService,
    IconService,
    UtilService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("insights.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "insights",
      },
      Restart20,
      urlCheckInterval: null,
      config: {},
      enabled: false,
      base_url: "",
      verify_tls: true,
      cidr: "",
      reason: "",
      requestResult: null,
      loading: {
        getConfiguration: false,
        setInsights: false,
        requestAllowlist: false,
      },
      error: {
        getConfiguration: "",
        setInsights: "",
        requestAllowlist: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
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
    this.getConfiguration();
  },
  methods: {
    // Format a date in the user's locale so it matches their regional settings.
    formatDateTime(value) {
      return new Date(value).toLocaleString(this.$i18n.locale);
    },
    async getConfiguration() {
      this.loading.getConfiguration = true;
      this.error.getConfiguration = "";
      const taskAction = "get-configuration";
      const eventId = this.getUuid();

      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getConfigurationAborted
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getConfigurationCompleted
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
        this.error.getConfiguration = this.getErrorMessage(err);
        this.loading.getConfiguration = false;
        return;
      }
    },
    getConfigurationAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getConfiguration = this.$t("error.generic_error");
      this.loading.getConfiguration = false;
    },
    getConfigurationCompleted(taskContext, taskResult) {
      const config = taskResult.output;
      this.config = config;
      this.enabled = config.insights.enabled;
      this.base_url = config.insights.base_url;
      this.verify_tls = config.insights.verify_tls;
      this.loading.getConfiguration = false;
    },
    setInsightsValidationFailed(validationErrors) {
      console.error("set-insights validation failed", validationErrors);
      this.error.setInsights = this.$t("error.generic_error");
      this.loading.setInsights = false;
    },
    async setInsights() {
      this.loading.setInsights = true;
      this.error.setInsights = "";
      const taskAction = "set-insights";
      const eventId = this.getUuid();

      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setInsightsAborted
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.setInsightsValidationFailed
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setInsightsCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            enabled: this.enabled,
            verify_tls: this.verify_tls,
            ...(this.enabled && this.base_url.trim()
              ? { base_url: this.base_url.trim() }
              : {}),
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
        this.error.setInsights = this.getErrorMessage(err);
        this.loading.setInsights = false;
        return;
      }
    },
    setInsightsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.setInsights = this.$t("error.generic_error");
      this.loading.setInsights = false;
    },
    setInsightsCompleted() {
      this.loading.setInsights = false;
      this.getConfiguration();
    },
    requestAllowlistValidationFailed(validationErrors) {
      console.error("request-allowlist validation failed", validationErrors);
      this.error.requestAllowlist = this.$t("error.generic_error");
      this.loading.requestAllowlist = false;
    },
    async requestAllowlist() {
      if (!this.cidr.trim() || !this.reason.trim()) {
        return;
      }
      this.loading.requestAllowlist = true;
      this.error.requestAllowlist = "";
      this.requestResult = null;
      const taskAction = "request-allowlist";
      const eventId = this.getUuid();

      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.requestAllowlistAborted
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.requestAllowlistValidationFailed
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.requestAllowlistCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            cidr: this.cidr,
            reason: this.reason,
          },
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
        this.error.requestAllowlist = this.getErrorMessage(err);
        this.loading.requestAllowlist = false;
        return;
      }
    },
    requestAllowlistAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.requestAllowlist = this.getErrorMessage(taskResult);
      this.loading.requestAllowlist = false;
    },
    requestAllowlistCompleted(taskContext, taskResult) {
      this.requestResult = taskResult.output;
      this.loading.requestAllowlist = false;
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

.dependent-fields {
  margin-top: $spacing-05;
  margin-bottom: $spacing-07;
}

.last-import-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.capi-info {
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
  width: 10rem;
  font-weight: 600;
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
