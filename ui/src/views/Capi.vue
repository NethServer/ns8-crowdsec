<!--
  Copyright (C) 2026 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <cv-grid fullWidth>
      <cv-row>
        <cv-column class="page-title">
          <h2>
            {{ $t("capi.title") }}
            <cv-interactive-tooltip
              alignment="start"
              direction="right"
              class="tooltip info mg-left-sm"
            >
              <template slot="trigger"></template>
              <template slot="content">
                <div>{{ $t("capi.tooltip") }}</div>
              </template>
            </cv-interactive-tooltip>
          </h2>
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column>
          <NsInlineNotification
            kind="warning"
            :title="core.$t('common.use_landscape_mode')"
            :description="core.$t('common.use_landscape_mode_description')"
            class="landscape-warning"
          />
        </cv-column>
      </cv-row>

      <!-- CAPI disabled warning -->
      <cv-row v-if="capiDisabled">
        <cv-column>
          <NsInlineNotification
            kind="warning"
            :title="$t('capi.capi_disabled_title')"
            :description="$t('capi.capi_disabled')"
            :showCloseButton="false"
          />
        </cv-column>
      </cv-row>

      <!-- Toolbar -->
      <cv-row class="toolbar">
        <cv-column>
          <NsButton
            kind="secondary"
            :icon="Restart20"
            @click="getCapiStatus"
            :disabled="loading.getCapiStatus || loading.searchCapiDecision"
            >{{ $t("capi.reload") }}
          </NsButton>
        </cv-column>
      </cv-row>

      <!-- Status + Search in a single tile -->
      <cv-row>
        <cv-column>
          <cv-tile light>
            <NsInlineNotification
              v-if="!loading.getCapiStatus && capiStatus"
              :kind="capiStatus.connected ? 'info' : 'error'"
              :title="
                capiStatus.connected
                  ? $t('capi.status_connected')
                  : $t('capi.status_disconnected')
              "
              :showCloseButton="false"
            />
            <div
              v-if="capiStatus && capiStatus.connected"
              class="capi-chips mg-top"
            >
              <NsTag
                v-if="capiStatus.subscription"
                kind="blue"
                :label="
                  $t('capi.subscription') + ': ' + capiStatus.subscription
                "
              />
              <NsTag
                :kind="capiStatus.sharing ? 'green' : 'red'"
                :label="$t('capi.sharing_signals')"
              />
              <NsTag
                :kind="capiStatus.pull_community ? 'green' : 'red'"
                :label="$t('capi.pull_community')"
              />
            </div>
            <div
              v-if="capiStatus && capiStatus.connected"
              class="ip-count mg-top"
            >
              <span v-if="loading.getCapiCount">
                <cv-skeleton-text :width="'200px'"></cv-skeleton-text>
              </span>
              <span v-else-if="capiCount !== null">
                {{ $t("capi.ip_count", { count: capiCount }) }}
              </span>
            </div>
            <h4 class="mg-top">{{ $t("capi.search_ip") }}</h4>
            <div class="search-row mg-top">
              <cv-text-input
                v-model="searchIp"
                :placeholder="$t('capi.search_placeholder')"
                :label="''"
                :invalid-message="searchIp.trim() && !isValidIp ? $t('capi.invalid_ip') : ''"
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
                  :title="$t('capi.ip_found_desc')"
                  :showCloseButton="false"
                />
                <div class="decisions mg-top-sm">
                  <NsTag
                    v-for="(d, i) in searchDecisions"
                    :key="i"
                    kind="red"
                    :label="d.scenario + ' · ' + d.type + ' · ' + d.duration"
                  />
                </div>
                <div class="cti-links mg-top-sm">
                  <NsButton kind="ghost" :icon="Launch20" @click="openCti">
                    {{ $t("capi.view_cti") }}
                  </NsButton>
                  <NsButton kind="ghost" :icon="Launch20" @click="openRemoval">
                    {{ $t("capi.request_removal") }}
                  </NsButton>
                </div>
              </div>
              <NsEmptyState v-else :title="$t('capi.no_results')">
                <template #pictogram>
                  <FaceSatisfiedPictogram />
                </template>
              </NsEmptyState>
            </div>
          </cv-tile>
        </cv-column>
      </cv-row>
    </cv-grid>
  </div>
</template>

<script>
import { mapState } from "vuex";
import {
  QueryParamService,
  UtilService,
  IconService,
  TaskService,
  PageTitleService,
} from "@nethserver/ns8-ui-lib";
import to from "await-to-js";
import Restart20 from "@carbon/icons-vue/es/restart/20";
import Search20 from "@carbon/icons-vue/es/search/20";
import Launch20 from "@carbon/icons-vue/es/launch/20";

export default {
  name: "Capi",
  mixins: [
    QueryParamService,
    UtilService,
    IconService,
    TaskService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("capi.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "capi",
      },
      Restart20,
      Search20,
      Launch20,
      urlCheckInterval: null,
      capiStatus: null,
      capiCount: null,
      capiDisabled: false,
      searchIp: "",
      searchDone: false,
      searchFound: false,
      searchDecisions: [],
      loading: {
        getCapiStatus: false,
        getCapiCount: false,
        searchCapiDecision: false,
      },
      error: {
        getCapiStatus: "",
        getCapiCount: "",
        searchCapiDecision: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    isValidIp() {
      const ip = this.searchIp.trim();
      if (!ip) return false;
      const ipv4 = /^(25[0-5]|2[0-4]\d|1\d{2}|[1-9]\d|\d)(\.(25[0-5]|2[0-4]\d|1\d{2}|[1-9]\d|\d)){3}$/;
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
    this.getCapiStatus();
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
        this.loading.getCapiCount = false;
      }
    },
    getCapiCountAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.capiCount = 0;
      this.loading.getCapiCount = false;
    },
    getCapiCountCompleted(taskContext, taskResult) {
      this.capiCount = taskResult.output.count;
      this.loading.getCapiCount = false;
    },
    async searchCapiDecision() {
      const ip = this.searchIp.trim();
      if (!ip) return;
      this.searchFound = false;
      this.searchDecisions = [];
      this.searchDone = false;
      if (this.capiCount === 0) {
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
    openCti() {
      window.open(
        "https://app.crowdsec.net/cti/" + this.searchIp.trim(),
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
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

.capi-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.ip-count {
  font-size: 0.875rem;
  color: $text-02;
}

.search-row {
  display: flex;
  align-items: flex-end;
  max-width: 36rem;
}

.decisions {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.cti-links {
  display: flex;
  gap: 1rem;
}

.mg-top {
  margin-top: 1rem;
}

.mg-left {
  margin-left: 1rem;
}
</style>
