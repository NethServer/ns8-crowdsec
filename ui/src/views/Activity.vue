<!--
  Copyright (C) 2026 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <cv-grid fullWidth>
      <cv-row>
        <cv-column class="page-title">
          <h2>{{ $t("activity.title") }}</h2>
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
      <cv-row>
        <cv-column>
          <p class="mg-bottom">{{ $t("detections.page_description") }}</p>
          <cv-tile light>
            <div class="toolbar">
              <NsButton
                kind="secondary"
                :icon="Unlocked20"
                @click="isShownConfirmUnbanAll = true"
                :disabled="busy || !alerts.some(isBlocked)"
                >{{ $t("unban.delete_all") }}
              </NsButton>
              <NsButton
                kind="tertiary"
                :icon="TrashCan20"
                class="mg-left-sm"
                @click="showConfirmDelete"
                :disabled="busy || !alerts.length"
                >{{ $t("detections.delete_alerts") }}
              </NsButton>
              <NsButton
                kind="ghost"
                :icon="Restart20"
                class="mg-left-sm"
                @click="listAlerts"
                :disabled="busy"
                >{{ $t("detections.reload_alerts") }}
              </NsButton>
            </div>
            <NsInlineNotification
              v-if="error.unban"
              kind="error"
              :title="$t('error_title.unban-ip')"
              :description="error.unban"
              :showCloseButton="false"
            />
            <div class="data-table-filters">
              <div style="flex: 2">
                <cv-search
                  v-model="alertsSearchFilter"
                  :placeholder="$t('detections.search_alerts')"
                  :label="$t('detections.search_alerts')"
                  :clear-aria-label="core.$t('common.clear_search')"
                ></cv-search>
              </div>
              <div style="flex: 1; min-width: 220px">
                <cv-select
                  v-model="actionFilter"
                  :label="$t('activity.action_label')"
                >
                  <cv-select-option value="all">{{
                    $t("activity.action_all")
                  }}</cv-select-option>
                  <cv-select-option value="none">{{
                    $t("activity.action_none")
                  }}</cv-select-option>
                  <cv-select-option value="banned">{{
                    $t("activity.action_banned")
                  }}</cv-select-option>
                  <cv-select-option value="expired">{{
                    $t("activity.action_expired")
                  }}</cv-select-option>
                </cv-select>
              </div>
              <div style="flex: 1; min-width: 220px">
                <cv-select
                  v-model="alertsLimit"
                  :label="$t('detections.history_label')"
                >
                  <cv-select-option
                    v-for="opt in alertsLimitOptions"
                    :key="opt.value"
                    :value="opt.value"
                    >{{ opt.label }}</cv-select-option
                  >
                </cv-select>
              </div>
            </div>
            <NsDataTable
              :allRows="filteredAlerts"
              :columns="i18nTableColumns"
              :rawColumns="tableColumns"
              :sortable="true"
              :pageSizes="[10, 25, 50, 100]"
              :overflow-menu="true"
              :isSearchable="false"
              :noSearchResultsLabel="core.$t('common.no_search_results')"
              :noSearchResultsDescription="
                core.$t('common.no_search_results_description')
              "
              :isLoading="loading.listAlerts || loading.unban"
              :skeletonRows="5"
              :isErrorShown="!!error.listAlerts"
              :errorTitle="$t('error_title.list-detections')"
              :errorDescription="error.listAlerts"
              :itemsPerPageLabel="core.$t('pagination.items_per_page')"
              :rangeOfTotalItemsLabel="
                core.$t('pagination.range_of_total_items')
              "
              :ofTotalPagesLabel="core.$t('pagination.of_total_pages')"
              :backwardText="core.$t('pagination.previous_page')"
              :forwardText="core.$t('pagination.next_page')"
              :pageNumberLabel="core.$t('pagination.page_number')"
              @updatePage="tablePage = $event"
            >
              <template slot="empty-state">
                <NsEmptyState
                  v-if="alertsSearchFilter.trim() || actionFilter !== 'all'"
                  :title="$t('detections.no_alerts_filtered')"
                  :animationData="GhostLottie"
                  animationTitle="ghost"
                  :loop="1"
                >
                  <template #description>
                    <div>
                      {{ $t("detections.no_alerts_filtered_description") }}
                    </div>
                    <NsButton
                      kind="ghost"
                      :icon="Reset20"
                      class="mg-top-sm"
                      @click="resetFilters"
                      >{{ $t("activity.reset_filters") }}
                    </NsButton>
                  </template>
                </NsEmptyState>
                <NsEmptyState v-else :title="$t('detections.no_alerts')">
                  <template #pictogram>
                    <CircleCheckPictogram />
                  </template>
                  <template #description>
                    <div>{{ $t("detections.no_alerts_description") }}</div>
                  </template>
                </NsEmptyState>
              </template>
              <template slot="data">
                <cv-data-table-row
                  v-for="(row, rowIndex) in tablePage"
                  :key="`${rowIndex}`"
                  :value="`${rowIndex}`"
                >
                  <cv-data-table-cell>
                    {{ formatDateTime(row.created_at) }}
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    {{ row.scenario }}
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    {{ row.source_ip }}
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    {{ row.source_cn || "-" }}
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    <NsTag
                      v-if="isBlocked(row)"
                      kind="red"
                      :label="$t('detections.decision_ban')"
                    />
                    <NsTag
                      v-else-if="row.decision_expired"
                      kind="blue"
                      :label="$t('detections.inspect_block_expired')"
                    />
                    <span v-else>-</span>
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    {{ row.events_count }}
                  </cv-data-table-cell>
                  <cv-data-table-cell class="table-overflow-menu-cell">
                    <div class="row-actions">
                      <NsButton
                        v-if="isBlocked(row)"
                        kind="ghost"
                        size="small"
                        :disabled="busy"
                        @click="showConfirmUnban(row.source_ip)"
                        :data-test-id="row.id + '-unban'"
                        >{{ $t("unban.delete") }}
                      </NsButton>
                      <cv-overflow-menu flip-menu class="row-menu">
                        <cv-overflow-menu-item
                          @click="inspectAlert(row)"
                          :data-test-id="row.id + '-inspect'"
                        >
                          <NsMenuItem
                            :icon="ZoomIn20"
                            :label="$t('detections.inspect_details')"
                          />
                        </cv-overflow-menu-item>
                      </cv-overflow-menu>
                    </div>
                  </cv-data-table-cell>
                </cv-data-table-row>
              </template>
            </NsDataTable>
          </cv-tile>
        </cv-column>
      </cv-row>
    </cv-grid>
    <ConfirmDeleteDetectionsModal
      :isShown="isShownConfirmDelete"
      :core="core"
      @hide="hideConfirmDelete"
      @confirm="setDeleteAlerts"
    />
    <ConfirmUnbanIpModal
      :isShown="isShownConfirmUnban"
      :ban="currentBan"
      :core="core"
      @hide="isShownConfirmUnban = false"
      @confirm="unban"
    />
    <ConfirmUnbanAllIpsModal
      :isShown="isShownConfirmUnbanAll"
      :isLoading="loading.unbanAll"
      :core="core"
      @hide="isShownConfirmUnbanAll = false"
      @confirm="unbanAll"
    />
    <InspectDetectionModal
      :isShown="isShownInspectAlert"
      :alert="currentAlertDetail"
      :core="core"
      @hide="hideInspectAlert"
      @after-hide="clearAlertDetail"
      @unban="unbanFromDetails"
    />
  </div>
</template>

<script>
import { mapState } from "vuex";
import {
  QueryParamService,
  PageTitleService,
  UtilService,
  IconService,
  TaskService,
  DateTimeService,
  LottieService,
} from "@nethserver/ns8-ui-lib";
import to from "await-to-js";
import ConfirmDeleteDetectionsModal from "@/components/ConfirmDeleteDetectionsModal.vue";
import InspectDetectionModal from "@/components/InspectDetectionModal.vue";
import ConfirmUnbanIpModal from "@/components/ConfirmUnbanIpModal.vue";
import ConfirmUnbanAllIpsModal from "@/components/ConfirmUnbanAllIpsModal.vue";
import { formatCountry } from "@/lib/country";
import Restart20 from "@carbon/icons-vue/es/restart/20";
import Reset20 from "@carbon/icons-vue/es/reset/20";
import TrashCan20 from "@carbon/icons-vue/es/trash-can/20";
import Unlocked20 from "@carbon/icons-vue/es/unlocked/20";

export default {
  name: "Activity",
  components: {
    ConfirmDeleteDetectionsModal,
    InspectDetectionModal,
    ConfirmUnbanIpModal,
    ConfirmUnbanAllIpsModal,
  },
  mixins: [
    QueryParamService,
    PageTitleService,
    UtilService,
    IconService,
    TaskService,
    DateTimeService,
    LottieService,
  ],
  pageTitle() {
    return this.$t("activity.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "activity",
      },
      urlCheckInterval: null,
      Restart20,
      Reset20,
      TrashCan20,
      Unlocked20,
      alertsLimit: "500",
      alertsSearchFilter: "",
      // "all", "none" (no ban), "banned" (ban still active) or "expired" (ban over)
      actionFilter: "all",
      tablePage: [],
      tableColumns: [
        "created_at",
        "scenario",
        "source_ip",
        "source_cn",
        "decision_types",
        "events_count",
      ],
      alerts: [],
      isShownConfirmDelete: false,
      isShownInspectAlert: false,
      isShownConfirmUnban: false,
      isShownConfirmUnbanAll: false,
      currentAlertDetail: null,
      currentBan: { value: "" },
      loading: {
        listAlerts: false,
        deleteAlerts: false,
        inspectAlert: false,
        unban: false,
        unbanAll: false,
      },
      error: {
        listAlerts: "",
        deleteAlerts: "",
        inspectAlert: "",
        unban: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    busy() {
      return (
        this.loading.listAlerts ||
        this.loading.deleteAlerts ||
        this.loading.unban ||
        this.loading.unbanAll
      );
    },
    i18nTableColumns() {
      return this.tableColumns.map((column) => {
        return this.$t("detections.col_" + column);
      });
    },
    filteredAlerts() {
      const q = this.alertsSearchFilter.trim().toLowerCase();
      const rows =
        this.actionFilter === "banned"
          ? this.alerts.filter(this.isBlocked)
          : this.actionFilter === "expired"
          ? this.alerts.filter((a) => a.decision_expired)
          : this.actionFilter === "none"
          ? this.alerts.filter((a) => !a.decision_types)
          : this.alerts;
      if (!q) return rows;
      return rows.filter((a) => this.alertSearchText(a).includes(q));
    },
    alertsLimitOptions() {
      return [
        {
          value: "500",
          label: this.$t("detections.history_option", { count: 500 }),
        },
        {
          value: "1000",
          label: this.$t("detections.history_option", { count: 1000 }),
        },
        {
          value: "2000",
          label: this.$t("detections.history_option", { count: 2000 }),
        },
        {
          value: "3000",
          label: this.$t("detections.history_option", { count: 3000 }),
        },
        {
          value: "4000",
          label: this.$t("detections.history_option", { count: 4000 }),
        },
        { value: "all", label: this.$t("detections.history_all") },
      ];
    },
  },
  watch: {
    alertsLimit() {
      this.listAlerts();
    },
  },
  beforeRouteEnter(to, from, next) {
    next((vm) => {
      // An old "page=detections" link: point the URL at this page first
      if (vm.getPage() === "detections") {
        vm.dataToQueryParams(vm);
      }
      vm.watchQueryData(vm);
      vm.urlCheckInterval = vm.initUrlBindingForApp(vm, vm.q.page);
    });
  },
  beforeRouteLeave(to, from, next) {
    clearInterval(this.urlCheckInterval);
    next();
  },
  created() {
    this.listAlerts();
  },
  methods: {
    // Format a date in the user's locale so it matches their regional settings.
    formatDateTime(value) {
      return new Date(value).toLocaleString(this.$i18n.locale);
    },
    // Build a lowercase haystack from every displayed column so the filter
    // matches on date, scenario, IP, country, action label and events count.
    alertSearchText(a) {
      const parts = [
        this.formatDateTime(a.created_at),
        a.scenario,
        a.source_ip,
        a.source_cn,
        a.events_count,
      ];
      if (this.isBlocked(a)) {
        parts.push(this.$t("detections.decision_ban"));
      } else if (a.decision_expired) {
        parts.push(this.$t("detections.inspect_block_expired"));
      }
      return parts.filter(Boolean).join(" ").toLowerCase();
    },
    isBlocked(row) {
      return !!row.decision_types && !row.decision_expired;
    },
    resetFilters() {
      this.alertsSearchFilter = "";
      this.actionFilter = "all";
      this.alertsLimit = "500";
    },
    showConfirmUnban(ip) {
      this.currentBan = { value: ip };
      this.isShownConfirmUnban = true;
    },
    unbanFromDetails() {
      const ip = this.currentAlertDetail.source.ip;
      this.hideInspectAlert();
      this.showConfirmUnban(ip);
    },
    unban() {
      this.isShownConfirmUnban = false;
      // temporary bans only: permanent and Threat Shield ones stay
      this.runUnban("unban", { ip: this.currentBan.value });
    },
    unbanAll() {
      this.runUnban("unbanAll", { action: "unban_all", ip: "0.0.0.0" });
    },
    async runUnban(loadingKey, data) {
      this.loading[loadingKey] = true;
      this.error.unban = "";
      const taskAction = "unban-ip";
      const eventId = this.getUuid();
      this.core.$root.$once(`${taskAction}-aborted-${eventId}`, () => {
        this.error.unban = this.$t("error.generic_error");
        this.loading[loadingKey] = false;
        this.isShownConfirmUnbanAll = false;
      });
      this.core.$root.$once(`${taskAction}-completed-${eventId}`, () => {
        this.loading[loadingKey] = false;
        this.isShownConfirmUnbanAll = false;
        this.listAlerts();
      });
      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: { action: "unban", ...data },
          extra: {
            title: this.$t("action." + taskAction),
            isNotificationHidden: true,
            eventId,
          },
        })
      );
      if (res[0]) {
        console.error(`error creating task ${taskAction}`, res[0]);
        this.error.unban = this.getErrorMessage(res[0]);
        this.loading[loadingKey] = false;
      }
    },
    async listAlerts() {
      this.alerts = [];
      this.error.listAlerts = "";
      const taskAction = "list-detections";
      const eventId = this.getUuid();
      this.loading.listAlerts = true;
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.listAlertsAborted
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.listAlertsCompleted
      );
      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: { limit: this.alertsLimit },
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
        const errMessage = this.getErrorMessage(err);
        this.error.listAlerts = errMessage;
        this.loading.listAlerts = false;
      }
    },
    listAlertsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.listAlerts = this.$t("error.generic_error");
      this.loading.listAlerts = false;
    },
    showConfirmDelete() {
      this.isShownConfirmDelete = true;
    },
    hideConfirmDelete() {
      this.isShownConfirmDelete = false;
    },
    async setDeleteAlerts() {
      this.hideConfirmDelete();
      this.loading.deleteAlerts = true;
      this.error.deleteAlerts = "";
      const taskAction = "delete-detections";
      const eventId = this.getUuid();
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.deleteAlertsAborted
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.deleteAlertsCompleted
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
        this.error.deleteAlerts = this.getErrorMessage(err);
        this.loading.deleteAlerts = false;
      }
    },
    deleteAlertsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.deleteAlerts = this.$t("error.generic_error");
      this.loading.deleteAlerts = false;
    },
    deleteAlertsCompleted() {
      this.loading.deleteAlerts = false;
      this.listAlerts();
    },
    async inspectAlert(row) {
      this.loading.inspectAlert = true;
      this.error.inspectAlert = "";
      const taskAction = "inspect-detection";
      const eventId = this.getUuid();
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.inspectAlertAborted
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.inspectAlertCompleted
      );
      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: { id: row.id },
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
        this.error.inspectAlert = this.getErrorMessage(err);
        this.loading.inspectAlert = false;
      }
    },
    inspectAlertAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.inspectAlert = this.$t("error.generic_error");
      this.loading.inspectAlert = false;
    },
    inspectAlertCompleted(taskContext, taskResult) {
      this.currentAlertDetail = taskResult.output;
      this.loading.inspectAlert = false;
      this.isShownInspectAlert = true;
    },
    hideInspectAlert() {
      this.isShownInspectAlert = false;
    },
    clearAlertDetail() {
      this.currentAlertDetail = null;
    },
    listAlertsCompleted(taskContext, taskResult) {
      const listAlerts = taskResult.output;
      listAlerts.forEach((alert) => {
        if (alert.scenario && alert.scenario.startsWith("update :")) return;
        const decision =
          alert.decisions && alert.decisions.length ? alert.decisions[0] : null;
        this.alerts.push({
          id: alert.id,
          created_at: alert.created_at,
          scenario: alert.scenario,
          source_ip: alert.source ? alert.source.ip : "",
          source_cn: formatCountry(
            alert.source ? alert.source.cn : "",
            this.$i18n.locale
          ),
          decision_types: decision ? "ban" : "",
          decision_expired: decision
            ? (decision.duration || "").split(".")[0].startsWith("-")
            : false,
          events_count: alert.events_count,
        });
      });
      this.loading.listAlerts = false;
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

.row-actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
}
.toolbar {
  display: flex;
  align-items: center;
  margin-bottom: $spacing-05;
}

.mg-top-sm {
  margin-top: $spacing-05;
}
.mg-bottom {
  margin-bottom: $spacing-06;
}
</style>
