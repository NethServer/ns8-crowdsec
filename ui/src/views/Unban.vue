<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <cv-grid fullWidth>
      <cv-row>
        <cv-column class="page-title">
          <h2>
            {{ $t("unban.title") }}
            <cv-interactive-tooltip
              alignment="start"
              direction="right"
              class="tooltip info mg-left-sm"
            >
              <template slot="trigger"></template>
              <template slot="content">
                <div v-html="$t('unban.unban_tooltip')"></div>
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
      <cv-row class="toolbar">
        <cv-column>
          <template>
            <NsButton
              kind="secondary"
              :icon="Restart20"
              @click="listBans"
              :disabled="loading.listBans || loading.setDeleteBan"
              >{{ $t("unban.reload_bans") }}
            </NsButton>
          </template>
          <template v-if="bans.length">
            <NsButton
              kind="secondary"
              class="mg-left"
              :icon="Unlocked20"
              @click="toggleUnbanAll"
              :disabled="loading.listBans || loading.setDeleteBan"
              >{{ $t("unban.delete_all") }}
            </NsButton>
          </template>
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column>
          <cv-tile light>
            <NsDataTable
              :allRows="bans"
              :columns="i18nTableColumns"
              :rawColumns="tableColumns"
              :sortable="true"
              :pageSizes="[10, 25, 50, 100]"
              :overflow-menu="true"
              :isSearchable="check_bans"
              :searchPlaceholder="$t('unban.search_bans')"
              :searchClearLabel="core.$t('common.clear_search')"
              :noSearchResultsLabel="core.$t('common.no_search_results')"
              :noSearchResultsDescription="
                core.$t('common.no_search_results_description')
              "
              :isLoading="loading.listBans || loading.setDeleteBan"
              :skeletonRows="5"
              :isErrorShown="!!error.listBans"
              :errorTitle="$t('action.unban_ip_status')"
              :errorDescription="error.listBans"
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
                <NsEmptyState :title="$t('unban.no_bans')">
                  <template #pictogram>
                    <FaceSatisfiedPictogram />
                  </template>
                </NsEmptyState>
              </template>
              <template slot="data">
                <cv-data-table-row
                  v-for="(row, rowIndex) in bans"
                  :key="`${rowIndex}`"
                  :value="`${rowIndex}`"
                >
                  <cv-data-table-row>
                    <div class="mg-top mg-left gray">
                      {{
                        formatDate(new Date(row.created_at), "yyyy-MM-dd HH.mm")
                      }}
                    </div>
                  </cv-data-table-row>
                  <cv-data-table-cell>
                    {{ row.value }}
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    {{ row.duration }}
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    {{ row.scenario }}
                  </cv-data-table-cell>
                  <cv-data-table-cell class="table-overflow-menu-cell">
                    <cv-overflow-menu
                      flip-menu
                      class="table-overflow-menu"
                      :data-test-id="row.value + '-menu'"
                    >
                      <cv-overflow-menu-item
                        @click="toggleUnban(row)"
                        :data-test-id="row.value + '-delete-ban'"
                      >
                        <NsMenuItem
                          :icon="Unlocked20"
                          :label="$t('unban.delete')"
                        />
                      </cv-overflow-menu-item>
                    </cv-overflow-menu>
                  </cv-data-table-cell>
                </cv-data-table-row>
              </template>
            </NsDataTable>
          </cv-tile>
        </cv-column>
      </cv-row>
    </cv-grid>
    <ConfirmReleaseIP
      :isShown="isShownConfirmUnbanIp"
      :ban="currentBan"
      :core="core"
      @hide="hideConfirmUnbanIP"
      @confirm="setDeleteBan(false)"
    />
    <ConfirmReleaseIPAll
      :isShown="isShownConfirmUnbanIPAll"
      :core="core"
      @hide="hideConfirmUnbanIP"
      @confirm="setUnbanAll(false)"
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
} from "@nethserver/ns8-ui-lib";
import to from "await-to-js";
import ConfirmReleaseIP from "@/components/ConfirmReleaseIP";
import ConfirmReleaseIPAll from "@/components/ConfirmReleaseIPAll";
import Unlocked20 from "@carbon/icons-vue/es/unlocked/20";
export default {
  name: "UnbanIP",
  components: {
    ConfirmReleaseIP,
    ConfirmReleaseIPAll,
  },
  mixins: [
    QueryParamService,
    UtilService,
    IconService,
    TaskService,
    DateTimeService,
  ],
  pageTitle() {
    return this.$t("unban.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "unBan",
      },
      Unlocked20,
      urlCheckInterval: null,
      tablePage: [],
      tableColumns: ["created_at", "value", "duration", "scenario"],
      bans: [],
      splitDuration: "",
      check_bans: false,
      isShownConfirmUnbanIp: false,
      isShownConfirmUnbanIPAll: false,
      currentBan: {
        created_at: "",
        value: "",
        duration: "",
        scenario: "",
      },
      loading: {
        listBans: false,
        setDeleteBan: false,
        setUnbanAll: false,
      },
      error: {
        listBans: "",
        setDeleteBan: "",
        setUnbanAll: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    i18nTableColumns() {
      return this.tableColumns.map((column) => {
        return this.$t("unban.col_" + column);
      });
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
    this.listBans();
  },
  methods: {
    async listBans() {
      this.bans = [];
      const taskAction = "list-banned-ip";
      const eventId = this.getUuid();
      this.loading.listBans = true;
      // register to task events
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.listBansAborted
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.listBansCompleted
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
        const errMessage = this.getErrorMessage(err);
        this.error.listBans = errMessage;
        this.loading.listBans = false;
      }
    },
    listBansAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.listBans = this.$t("error.generic_error");
      this.loading.listBans = false;
    },
    listBansCompleted(taskContext, taskResult) {
      let listBans = taskResult.output;
      // we protect against manual ban twice, decisions is an empty array
      // we select informations we want to push
      listBans.forEach((ban) => {
        // we want to split digit after the point of seconds to display time in human format :
        // 3h29m45s instead of 3h54m42.494246619s
        if (ban.decisions[0]) {
          const splitSecond = ban.decisions[0].duration.split(".");
          ban.decisions[0].duration = splitSecond[0] + "s";
          this.bans.push({
            duration: ban.decisions[0].duration,
            value: ban.decisions[0].value,
            scenario: ban.decisions[0].scenario,
            created_at: ban.created_at,
          });
        }
      });
      this.check_bans = this.bans.length ? true : false;
      this.loading.listBans = false;
    },
    toggleUnbanAll() {
      this.showConfirmUnbanAll();
    },
    showConfirmUnbanAll() {
      this.isShownConfirmUnbanIPAll = true;
    },
    hideConfirmUnbanIPAll() {
      this.isShownConfirmUnbanIPAll = false;
    },
    toggleUnban(ban) {
      this.currentBan = ban;
      this.showConfirmUnbanIP();
    },
    showConfirmUnbanIP() {
      this.isShownConfirmUnbanIp = true;
    },
    hideConfirmUnbanIP() {
      this.isShownConfirmUnbanIp = false;
    },
    async setDeleteBan() {
      this.loading.setDeleteBan = true;
      this.error.setDeleteBan = "";
      const taskAction = "unban-ip";
      const eventId = this.getUuid();
      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setUnbanIpAborted
      );
      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setUnbanIpCompleted
      );
      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            ip: this.currentBan.value,
            action: "unban",
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
        this.error.setDeleteBan = this.getErrorMessage(err);
        this.loading.setDeleteBan = false;
        return;
      }
      this.hideConfirmUnbanIP();
    },
    setUnbanIpAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.setDeleteBan = this.$t("error.generic_error");
      this.loading.setDeleteBan = false;
    },
    setUnbanIpCompleted() {
      this.loading.setDeleteBan = false;
      this.listBans();
    },
    async setUnbanAll() {
      this.loading.setUnbanAll = true;
      this.error.setUnbanAll = "";
      const taskAction = "unban-ip";
      const eventId = this.getUuid();
      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setUnbanIpAllAborted
      );
      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setUnbanIpAllCompleted
      );
      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            ip: "0.0.0.0",
            action: "unban_all",
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
        this.error.setUnbanAll = this.getErrorMessage(err);
        this.loading.setUnbanAll = false;
        return;
      }
    },
    setUnbanIpAllAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.setUnbanAll = this.$t("error.generic_error");
      this.loading.setUnbanAll = false;
    },
    setUnbanIpAllCompleted() {
      this.loading.setUnbanAll = false;
      this.hideConfirmUnbanIPAll();
      this.listBans();
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

.quota-stats {
  font-size: 90%;
  display: flex;
  justify-content: space-between;
}
.mg-top {
  margin-top: 1em;
}
.mg-left {
  margin-left: 1em;
}
.gray {
  color: #525252;
}
</style>
