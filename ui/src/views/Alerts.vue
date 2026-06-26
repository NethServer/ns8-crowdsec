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
            {{ $t("alerts.title") }}
            <cv-interactive-tooltip
              alignment="start"
              direction="right"
              class="tooltip info mg-left-sm"
            >
              <template slot="trigger"></template>
              <template slot="content">
                <div>{{ $t("alerts.tooltip") }}</div>
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
      <cv-row>
        <cv-column>
          <p class="page-description">{{ $t('alerts.page_description') }}</p>
        </cv-column>
      </cv-row>
      <cv-row class="toolbar mg-top-sm">
        <cv-column>
          <NsButton
            kind="secondary"
            :icon="Restart20"
            @click="listAlerts"
            :disabled="loading.listAlerts || loading.deleteAlerts"
            >{{ $t("alerts.reload_alerts") }}
          </NsButton>
          <NsButton
            kind="tertiary"
            :icon="TrashCan20"
            class="mg-left-sm"
            @click="showConfirmDelete"
            :disabled="loading.listAlerts || loading.deleteAlerts || !alerts.length"
            >{{ $t("alerts.delete_alerts") }}
          </NsButton>
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column>
          <cv-tile light>
            <div class="data-table-filters">
              <div style="flex: 2;">
                <cv-search
                  v-model="alertsSearchFilter"
                  :placeholder="$t('alerts.search_alerts')"
                  :label="$t('alerts.search_alerts')"
                  :clear-aria-label="core.$t('common.clear_search')"
                ></cv-search>
              </div>
              <div style="flex: 1; min-width: 220px;">
                <cv-select
                  v-model="alertsLimit"
                  :label="$t('alerts.history_label')"
                >
                  <cv-select-option
                    v-for="opt in alertsLimitOptions"
                    :key="opt.value"
                    :value="opt.value"
                  >{{ opt.label }}</cv-select-option>
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
              :isLoading="loading.listAlerts"
              :skeletonRows="5"
              :isErrorShown="!!error.listAlerts"
              :errorTitle="$t('action.list-alerts')"
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
                <NsEmptyState :title="$t('alerts.no_alerts')">
                  <template #pictogram>
                    <FaceSatisfiedPictogram />
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
                    <div>
                      {{
                        formatDate(new Date(row.created_at), "yyyy-MM-dd HH:mm")
                      }}
                    </div>
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
                      v-if="row.decision_types"
                      kind="red"
                      :label="$t('alerts.decision_ban')"
                    />
                    <span v-else>-</span>
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    {{ row.events_count }}
                  </cv-data-table-cell>
                  <cv-data-table-cell class="table-overflow-menu-cell">
                    <NsButton
                      kind="ghost"
                      size="small"
                      @click="inspectAlert(row)"
                      :data-test-id="row.id + '-inspect'"
                      >{{ $t("alerts.inspect_details") }}
                    </NsButton>
                  </cv-data-table-cell>
                </cv-data-table-row>
              </template>
            </NsDataTable>
          </cv-tile>
        </cv-column>
      </cv-row>
    </cv-grid>
    <ConfirmDeleteAlertsModal
      :isShown="isShownConfirmDelete"
      :core="core"
      @hide="hideConfirmDelete"
      @confirm="setDeleteAlerts"
    />
    <InspectAlertModal
      :isShown="isShownInspectAlert"
      :alert="currentAlertDetail"
      :core="core"
      @hide="hideInspectAlert"
      @after-hide="clearAlertDetail"
    />
  </div>
</template>

<script>
import { mapState } from "vuex";
import {
  QueryParamService,
  UtilService,
  IconService,
  TaskService,
  DateTimeService,
  PageTitleService
} from "@nethserver/ns8-ui-lib";
import to from "await-to-js";
import ConfirmDeleteAlertsModal from "@/components/ConfirmDeleteAlertsModal.vue";
import InspectAlertModal from "@/components/InspectAlertModal.vue";
import Restart20 from "@carbon/icons-vue/es/restart/20";
import TrashCan20 from "@carbon/icons-vue/es/trash-can/20";

export default {
  name: "Alerts",
  components: {
    ConfirmDeleteAlertsModal,
    InspectAlertModal,
  },
  mixins: [
    QueryParamService,
    UtilService,
    IconService,
    TaskService,
    DateTimeService,
    PageTitleService
  ],
  pageTitle() {
    return this.$t("alerts.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "alerts",
      },
      Restart20,
      TrashCan20,
      urlCheckInterval: null,
      alertsLimit: "500",
      alertsSearchFilter: "",
      tablePage: [],
      tableColumns: ["created_at", "scenario", "source_ip", "source_cn", "decision_types", "events_count"],
      alerts: [],
      isShownConfirmDelete: false,
      isShownInspectAlert: false,
      currentAlertDetail: null,
      loading: {
        listAlerts: false,
        deleteAlerts: false,
        inspectAlert: false,
      },
      error: {
        listAlerts: "",
        deleteAlerts: "",
        inspectAlert: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    i18nTableColumns() {
      return this.tableColumns.map((column) => {
        return this.$t("alerts.col_" + column);
      });
    },
    filteredAlerts() {
      const q = this.alertsSearchFilter.trim().toLowerCase();
      if (!q) return this.alerts;
      return this.alerts.filter(
        (a) =>
          (a.source_ip || "").toLowerCase().includes(q) ||
          (a.scenario || "").toLowerCase().includes(q) ||
          (a.source_cn || "").toLowerCase().includes(q) ||
          (a.decision_types || "").toLowerCase().includes(q)
      );
    },
    alertsLimitOptions() {
      return [
        { value: "500",  label: this.$t("alerts.history_option", { count: 500 }) },
        { value: "1000", label: this.$t("alerts.history_option", { count: 1000 }) },
        { value: "2000", label: this.$t("alerts.history_option", { count: 2000 }) },
        { value: "3000", label: this.$t("alerts.history_option", { count: 3000 }) },
        { value: "4000", label: this.$t("alerts.history_option", { count: 4000 }) },
        { value: "all",  label: this.$t("alerts.history_all") },
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
    async listAlerts() {
      this.alerts = [];
      this.error.listAlerts = "";
      const taskAction = "list-alerts";
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
      const taskAction = "delete-alerts";
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
      const taskAction = "inspect-alert";
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
        this.alerts.push({
          id: alert.id,
          created_at: alert.created_at,
          scenario: alert.scenario,
          source_ip: alert.source ? alert.source.ip : "",
          source_cn: alert.source ? (alert.source.cn || "") : "",
          decision_types: alert.decisions && alert.decisions.length > 0 ? "ban" : "",
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

</style>
