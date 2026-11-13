<!--
  Copyright (C) 2026 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <cv-row v-if="capiDisabled">
      <cv-column>
        <NsInlineNotification
          kind="warning"
          :title="$t('capi.capi_disabled_title')"
          :description="$t('capi.capi_disabled')"
          :showCloseButton="false"
          class="mg-bottom"
        />
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column>
        <p class="mg-bottom">
          {{ $t("blocklists.community_description") }}
        </p>
        <cv-link
          href="https://app.crowdsec.net/"
          target="_blank"
          rel="noopener noreferrer"
          class="console-link mg-bottom"
        >
          {{ $t("settings.open_app_crowdsec") }}
          <component :is="Launch16" class="console-link__icon" />
        </cv-link>
      </cv-column>
    </cv-row>
    <cv-row class="equal-height-row">
      <cv-column class="bx--col-lg-8">
        <cv-tile light>
          <h4>{{ $t("blocklists.community_configuration") }}</h4>
          <div
            v-if="!loading.getCapiStatus && capiStatus"
            class="capi-info mg-top"
          >
            <div class="info-row">
              <span class="info-label">{{
                $t("capi.central_api_status")
              }}</span>
              <NsTag
                :kind="capiStatus.connected ? 'green' : 'gray'"
                :label="
                  capiStatus.connected
                    ? $t('capi.connected')
                    : $t('capi.disconnected')
                "
              />
            </div>
            <div
              v-if="capiStatus.connected && capiStatus.subscription"
              class="info-row"
            >
              <span class="info-label">{{
                $t("capi.subscription_label")
              }}</span>
              <span>{{ capiStatus.subscription }}</span>
            </div>
          </div>
          <NsToggle
            :label="$t('settings.enable_online_api')"
            value="enable_online_api"
            :form-item="true"
            v-model="enable_online_api"
            class="mg-top-lg mg-bottom"
            :disabled="loadingConfig || loading.saveCommunityConfig"
            ref="enable_online_api"
          >
            <template slot="tooltip">
              <span>{{ $t("settings.disable_online_api_tips") }}</span>
            </template>
            <template slot="text-left">{{ $t("settings.disabled") }}</template>
            <template slot="text-right">{{ $t("settings.enabled") }}</template>
          </NsToggle>
          <div v-if="enable_online_api" class="dependent-fields">
            <NsTextInput
              :label="$t('settings.enroll_instance')"
              :helper-text="$t('settings.enroll_instance_helper')"
              v-model="enroll_instance"
              class="mg-bottom"
              :invalid-message="error.enroll_instance"
              :disabled="loadingConfig || loading.saveCommunityConfig"
              ref="enroll_instance"
            />
            <NsToggle
              :label="$t('settings.pull_community_blocklist')"
              class="mg-top-lg mg-bottom"
              value="pull_community_blocklist"
              :form-item="true"
              v-model="pull_community_blocklist"
              :disabled="loadingConfig || loading.saveCommunityConfig"
              ref="pull_community_blocklist"
            >
              <template slot="tooltip">
                <span>{{ $t("settings.pull_community_blocklist_tips") }}</span>
              </template>
              <template slot="text-left">{{
                $t("settings.disabled")
              }}</template>
              <template slot="text-right">{{
                $t("settings.enabled")
              }}</template>
            </NsToggle>
          </div>
          <cv-row v-if="error.saveCommunityConfig">
            <cv-column>
              <NsInlineNotification
                kind="error"
                :title="$t('error_title.configure-module')"
                :description="error.saveCommunityConfig"
                :showCloseButton="false"
                class="mg-bottom"
              />
            </cv-column>
          </cv-row>
          <NsButton
            kind="primary"
            :icon="Save20"
            class="mg-top"
            :loading="loading.saveCommunityConfig"
            :disabled="loadingConfig || loading.saveCommunityConfig"
            @click="saveCommunityConfig"
            >{{ $t("settings.save") }}</NsButton
          >
        </cv-tile>
      </cv-column>
      <cv-column class="bx--col-lg-8">
        <cv-tile light>
          <h4 class="mg-bottom">
            {{ $t("blocklists.community_search") }}
          </h4>
          <p class="mg-bottom">{{ $t("capi.search_hint") }}</p>
          <p v-if="loading.getCapiCount">
            <cv-skeleton-text :width="'160px'"></cv-skeleton-text>
            {{ $t("capi.syncing") }}
          </p>
          <p v-else-if="capiCount !== null">
            {{ $t("capi.ips_listed", { count: capiCount }) }}
          </p>
          <div class="search-row mg-top">
            <cv-text-input
              v-model="searchIp"
              :placeholder="$t('capi.search_placeholder')"
              :label="''"
              :invalid-message="
                searchIp.trim() && !isValidIp ? $t('capi.invalid_ip') : ''
              "
              @keyup.enter.native="searchCapiDecision"
            ></cv-text-input>
            <NsButton
              kind="primary"
              :icon="Search20"
              class="mg-left"
              @click="searchCapiDecision"
              :loading="loading.searchCapiDecision"
              :disabled="loading.searchCapiDecision || !isValidIp"
              >{{ $t("capi.search_button") }}
            </NsButton>
          </div>

          <!-- Search results -->
          <div v-if="searchDone" class="mg-top">
            <div v-if="searchFound">
              <NsInlineNotification
                kind="warning"
                :title="$t('capi.ip_found_title')"
                :description="$t('capi.ip_found', { ip: searchedIp })"
                :showCloseButton="false"
              />
              <div
                v-for="(d, i) in searchDecisions"
                :key="i"
                class="capi-info mg-top"
              >
                <div class="info-row">
                  <span class="info-label">{{ $t("capi.col_reason") }}</span>
                  <span>{{ d.scenario }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">{{ $t("capi.col_action") }}</span>
                  <NsTag
                    kind="red"
                    :label="
                      d.type === 'ban' ? $t('capi.action_blocked') : d.type
                    "
                  />
                </div>
                <div class="info-row">
                  <span class="info-label">{{
                    $t("capi.col_time_remaining")
                  }}</span>
                  <span>{{ formatDuration(d.duration) }}</span>
                </div>
              </div>
              <div class="cti-links mg-top-lg">
                <NsButton kind="tertiary" :icon="Launch20" @click="openCti">
                  {{ $t("capi.view_cti") }}
                </NsButton>
                <NsButton kind="ghost" :icon="Launch20" @click="openRemoval">
                  {{ $t("capi.request_removal") }}
                </NsButton>
              </div>
            </div>
            <NsEmptyState v-else :title="$t('capi.no_results')">
              <template #pictogram>
                <CircleCheckPictogram />
              </template>
              <template #description>
                <div>{{ $t("capi.no_results_desc") }}</div>
              </template>
            </NsEmptyState>
          </div>
        </cv-tile>
      </cv-column>
    </cv-row>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { UtilService, IconService, TaskService } from "@nethserver/ns8-ui-lib";
import to from "await-to-js";
import Launch16 from "@carbon/icons-vue/es/launch/16";
import { isValidIpAddress } from "@/lib/ip";
import { formatDuration } from "@/lib/duration";

export default {
  name: "CommunityBlocklist",
  mixins: [UtilService, IconService, TaskService],
  props: {
    // get-configuration output, loaded by the page; null until then
    config: { type: Object, default: null },
    loadingConfig: Boolean,
  },
  data() {
    return {
      Launch16,
      capiStatus: null,
      capiCount: null,
      capiCountUnknown: false,
      capiDisabled: false,
      searchIp: "",
      searchedIp: "",
      searchDone: false,
      searchFound: false,
      searchDecisions: [],
      enable_online_api: true,
      enroll_instance: "",
      pull_community_blocklist: true,
      loading: {
        getCapiStatus: false,
        getCapiCount: false,
        searchCapiDecision: false,
        saveCommunityConfig: false,
      },
      error: {
        getCapiStatus: "",
        getCapiCount: "",
        searchCapiDecision: "",
        saveCommunityConfig: "",
        enroll_instance: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core"]),
    isValidIp() {
      return isValidIpAddress(this.searchIp);
    },
  },
  watch: {
    // hide the previous result as soon as the IP is edited
    searchIp() {
      this.searchDone = false;
    },
    config: {
      immediate: true,
      handler(config) {
        if (!config) return;
        this.enable_online_api = config.enable_online_api;
        // keep a rejected key in the field, next to its error
        if (!this.error.enroll_instance) {
          this.enroll_instance = config.enroll_instance;
        }
        this.pull_community_blocklist =
          config.pull_community_blocklist !== undefined
            ? config.pull_community_blocklist
            : true;
      },
    },
  },
  created() {
    this.getCapiStatus();
  },
  beforeDestroy() {
    clearTimeout(this._capiCountTimeout);
  },
  methods: {
    async getCapiStatus() {
      this.capiStatus = null;
      this.capiCount = null;
      const taskAction = "get-capi-status";
      const eventId = this.getUuid();
      this.loading.getCapiStatus = true;
      this.error.getCapiStatus = "";
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getCapiStatusAborted
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getCapiStatusCompleted
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
        this.error.getCapiStatus = this.getErrorMessage(err);
        this.loading.getCapiStatus = false;
      }
    },
    getCapiStatusAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getCapiStatus = this.$t("error.generic_error");
      this.loading.getCapiStatus = false;
    },
    getCapiStatusCompleted(taskContext, taskResult) {
      this.capiStatus = taskResult.output;
      this.capiDisabled = this.capiStatus.config_disabled === true;
      this.loading.getCapiStatus = false;
      if (this.capiStatus.connected) {
        if (this.capiStatus.pull_community) {
          this.getCapiCount();
        } else {
          this.capiCount = 0;
        }
      }
    },
    async getCapiCount() {
      const taskAction = "get-capi-count";
      const eventId = this.getUuid();
      this.loading.getCapiCount = true;
      this.error.getCapiCount = "";
      this._capiCountTimeout = setTimeout(() => {
        this.capiCount = 0;
        this.capiCountUnknown = true;
        this.loading.getCapiCount = false;
      }, 10000);
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getCapiCountAborted
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getCapiCountCompleted
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
        this.error.getCapiCount = this.getErrorMessage(err);
        clearTimeout(this._capiCountTimeout);
        this.capiCount = 0;
        this.capiCountUnknown = true;
        this.loading.getCapiCount = false;
      }
    },
    getCapiCountAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      clearTimeout(this._capiCountTimeout);
      this.capiCount = 0;
      this.capiCountUnknown = true;
      this.loading.getCapiCount = false;
    },
    getCapiCountCompleted(taskContext, taskResult) {
      clearTimeout(this._capiCountTimeout);
      this.capiCount = taskResult.output.count;
      this.capiCountUnknown = false;
      this.loading.getCapiCount = false;
    },
    async searchCapiDecision() {
      // block search (incl. Enter key) when the IP is empty or invalid
      if (!this.isValidIp) return;
      const ip = this.searchIp.trim();
      this.searchedIp = ip;
      this.searchFound = false;
      this.searchDecisions = [];
      this.searchDone = false;
      if (this.capiCount === 0 && !this.capiCountUnknown) {
        this.searchDone = true;
        return;
      }
      const taskAction = "search-capi-decision";
      const eventId = this.getUuid();
      this.loading.searchCapiDecision = true;
      this.error.searchCapiDecision = "";
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.searchCapiDecisionAborted
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.searchCapiDecisionCompleted
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
        this.error.searchCapiDecision = this.getErrorMessage(err);
        this.loading.searchCapiDecision = false;
      }
    },
    searchCapiDecisionAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.searchCapiDecision = this.$t("error.generic_error");
      this.loading.searchCapiDecision = false;
    },
    searchCapiDecisionCompleted(taskContext, taskResult) {
      this.searchFound = taskResult.output.found;
      this.searchDecisions = taskResult.output.decisions;
      this.searchDone = true;
      this.loading.searchCapiDecision = false;
    },
    formatDuration,
    openCti() {
      window.open(
        "https://app.crowdsec.net/cti/" + this.searchedIp,
        "_blank",
        "noopener,noreferrer"
      );
    },
    openRemoval() {
      window.open(
        "https://www.crowdsec.net/remove-ip-crowdsec-blocklist",
        "_blank",
        "noopener,noreferrer"
      );
    },
    configureModuleValidationFailed(loadingKey, errorKey, validationErrors) {
      this.loading[loadingKey] = false;
      for (const validationError of validationErrors) {
        const param = validationError.parameter;
        this.error[param] = this.$t("settings." + validationError.error, {
          value: validationError.value,
        });
      }
    },
    async saveCommunityConfig() {
      this.loading.saveCommunityConfig = true;
      this.error.saveCommunityConfig = "";
      this.error.enroll_instance = "";
      const taskAction = "configure-module";
      const eventId = this.getUuid();
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.saveCommunityConfigAborted
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        (validationErrors) => {
          this.configureModuleValidationFailed(
            "saveCommunityConfig",
            "enroll_instance",
            validationErrors
          );
          // the steps before the enroll check already saved the other settings
          this.$emit("config-changed");
          this.getCapiStatus();
        }
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.saveCommunityConfigCompleted
      );
      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            ...this.config,
            enable_online_api: this.enable_online_api,
            enroll_instance: this.enroll_instance,
            pull_community_blocklist: this.pull_community_blocklist,
          },
          extra: {
            title: this.$t("settings.configure_instance", {
              instance: this.instanceName,
            }),
            description: this.$t("settings.processing"),
            eventId,
          },
        })
      );
      const err = res[0];
      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.saveCommunityConfig = this.getErrorMessage(err);
        this.loading.saveCommunityConfig = false;
      }
    },
    saveCommunityConfigAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.saveCommunityConfig = this.$t("error.generic_error");
      this.loading.saveCommunityConfig = false;
    },
    saveCommunityConfigCompleted() {
      this.loading.saveCommunityConfig = false;
      this.$emit("config-changed");
      this.getCapiStatus();
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

// Prevent Carbon from truncating tab labels (e.g. "Community blocklist").
// Carbon renders these tabs in scrollable mode with a fixed width: 10rem.
::v-deep .bx--tabs__nav-link,
::v-deep .bx--tabs--scrollable .bx--tabs--scrollable__nav-link {
  width: auto;
}

.console-link {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
}

.console-link__icon {
  width: 1rem;
  height: 1rem;
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

.search-row {
  display: flex;
  align-items: flex-start;
  max-width: 36rem;
}

// Match the input height to the Search button
.search-row ::v-deep .bx--form-item {
  flex: 1;
}

// Empty label still reserves vertical space and pushes the input field down,
// misaligning it with the Search button. Collapse it.
.search-row ::v-deep .bx--label {
  display: none;
}

.search-row ::v-deep .bx--text-input {
  height: 3rem;
}

.cti-links {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.maxwidth {
  max-width: 38rem;
}

.mg-top {
  margin-top: 1rem;
}

.mg-top-lg {
  margin-top: 4rem;
}

::v-deep .empty-state {
  background-color: $ui-01;
}

.mg-bottom {
  margin-bottom: 1rem;
}

.mg-left {
  margin-left: 1rem;
}

.mg-right {
  margin-right: 1rem;
}

// Fields depending on the Central API toggle
.dependent-fields {
  margin-left: 1.5rem;
}

// Equal height for the config and search tiles
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
