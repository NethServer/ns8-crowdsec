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
            {{ $t("blocklists.title") }}
            <cv-interactive-tooltip
              alignment="start"
              direction="right"
              class="tooltip info mg-left-sm"
            >
              <template slot="trigger"></template>
              <template slot="content">
                <div>{{ $t("blocklists.tooltip") }}</div>
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
          <NsTabs>
            <!-- Local blocklist -->
            <cv-tab :label="$t('blocklists.tab_local')" selected>
              <cv-row class="toolbar">
                <cv-column>
                  <NsButton
                    kind="secondary"
                    :icon="Restart20"
                    @click="listBans"
                    :disabled="loading.listBans || loading.setDeleteBan"
                    >{{ $t("unban.reload_bans") }}
                  </NsButton>
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
                          v-for="(row, rowIndex) in tablePage"
                          :key="`${rowIndex}`"
                          :value="`${rowIndex}`"
                        >
                          <cv-data-table-cell>
                            <div>
                              {{
                                formatDate(
                                  new Date(row.created_at),
                                  "yyyy-MM-dd HH.mm"
                                )
                              }}
                            </div>
                          </cv-data-table-cell>
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
            </cv-tab>

            <!-- Community blocklist -->
            <cv-tab :label="$t('blocklists.tab_community')">
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
              <cv-row>
                <cv-column class="bx--col-lg-8">
                  <cv-tile light>
                    <h4>{{ $t("blocklists.community_configuration") }}</h4>
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
                        {{ $t("capi.syncing") }}
                      </span>
                      <span v-else-if="capiCount !== null">
                        {{ $t("capi.ip_count", { count: capiCount }) }}
                      </span>
                    </div>
                    <NsToggle
                      :label="$t('settings.enable_online_api')"
                      value="enable_online_api"
                      :form-item="true"
                      v-model="enable_online_api"
                      class="mg-top"
                      :disabled="
                        loading.getConfiguration || loading.saveCommunityConfig
                      "
                      ref="enable_online_api"
                    >
                      <template slot="tooltip">
                        <span>{{ $t("settings.disable_online_api_tips") }}</span>
                      </template>
                      <template slot="text-left">{{
                        $t("settings.disabled")
                      }}</template>
                      <template slot="text-right">{{
                        $t("settings.enabled")
                      }}</template>
                    </NsToggle>
                    <template v-if="enable_online_api">
                      <NsButton
                        kind="tertiary"
                        size="field"
                        :icon="Launch20"
                        :disabled="loading.getConfiguration"
                        @click="goToAppCrowdsec"
                        class="mg-bottom mg-top"
                      >
                        {{ $t("settings.open_app_crowdsec") }}
                      </NsButton>
                      <NsTextInput
                        :label="$t('settings.enroll_instance')"
                        v-model="enroll_instance"
                        class="mg-bottom"
                        :invalid-message="error.enroll_instance"
                        :disabled="
                          loading.getConfiguration || loading.saveCommunityConfig
                        "
                        ref="enroll_instance"
                        tooltipAlignment="center"
                        tooltipDirection="right"
                      >
                        <template slot="tooltip">
                          <div>
                            {{ $t("settings.enroll_instance_must_be_real_token") }}
                          </div>
                        </template>
                      </NsTextInput>
                      <NsToggle
                        :label="$t('settings.pull_community_blocklist')"
                        value="pull_community_blocklist"
                        :form-item="true"
                        v-model="pull_community_blocklist"
                        :disabled="
                          loading.getConfiguration || loading.saveCommunityConfig
                        "
                        ref="pull_community_blocklist"
                      >
                        <template slot="tooltip">
                          <span>{{
                            $t("settings.pull_community_blocklist_tips")
                          }}</span>
                        </template>
                        <template slot="text-left">{{
                          $t("settings.disabled")
                        }}</template>
                        <template slot="text-right">{{
                          $t("settings.enabled")
                        }}</template>
                      </NsToggle>
                    </template>
                    <cv-row v-if="error.saveCommunityConfig">
                      <cv-column>
                        <NsInlineNotification
                          kind="error"
                          :title="$t('action.configure-module')"
                          :description="error.saveCommunityConfig"
                          :showCloseButton="false"
                        />
                      </cv-column>
                    </cv-row>
                    <NsButton
                      kind="primary"
                      :icon="Save20"
                      class="mg-top"
                      :loading="loading.saveCommunityConfig"
                      :disabled="
                        loading.getConfiguration || loading.saveCommunityConfig
                      "
                      @click="saveCommunityConfig"
                      >{{ $t("settings.save") }}</NsButton
                    >
                  </cv-tile>
                </cv-column>
                <cv-column class="bx--col-lg-8">
                  <cv-tile light>
                    <h4>{{ $t("blocklists.community_search") }}</h4>
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
                          <NsButton
                            kind="ghost"
                            :icon="Launch20"
                            @click="openRemoval"
                          >
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
            </cv-tab>

            <!-- Allowlist -->
            <cv-tab :label="$t('blocklists.tab_allowlist')">
              <cv-row>
                <cv-column>
                  <cv-tile light>
                    <NsInlineNotification
                      kind="info"
                      :title="$t('blocklists.allowlist_info_title')"
                      :description="$t('blocklists.allowlist_info_description')"
                      :showCloseButton="false"
                      class="mg-bottom"
                    />
                    <cv-text-area
                      :label="$t('settings.whitelists')"
                      v-model.trim="whitelists"
                      :invalid-message="error.whitelists"
                      :helper-text="$t('settings.whitelists_tips')"
                      :value="whitelists"
                      class="maxwidth textarea"
                      ref="whitelists"
                      :placeholder="$t('settings.whitelist_placeholder')"
                      :disabled="loading.getConfiguration || loading.saveAllowlist"
                    >
                    </cv-text-area>
                    <cv-row v-if="error.saveAllowlist">
                      <cv-column>
                        <NsInlineNotification
                          kind="error"
                          :title="$t('action.configure-module')"
                          :description="error.saveAllowlist"
                          :showCloseButton="false"
                        />
                      </cv-column>
                    </cv-row>
                    <NsButton
                      kind="primary"
                      :icon="Save20"
                      class="mg-top"
                      :loading="loading.saveAllowlist"
                      :disabled="loading.getConfiguration || loading.saveAllowlist"
                      @click="saveAllowlist"
                      >{{ $t("settings.save") }}</NsButton
                    >
                  </cv-tile>
                </cv-column>
              </cv-row>
            </cv-tab>
          </NsTabs>
        </cv-column>
      </cv-row>
    </cv-grid>
    <ConfirmUnbanIpModal
      :isShown="isShownConfirmUnbanIp"
      :ban="currentBan"
      :core="core"
      @hide="hideConfirmUnbanIP"
      @confirm="setDeleteBan"
    />
    <ConfirmUnbanAllIpsModal
      :isShown="isShownConfirmUnbanIPAll"
      :isLoading="loading.setUnbanAll"
      :core="core"
      @hide="hideConfirmUnbanIPAll"
      @confirm="setUnbanAll"
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
  PageTitleService,
} from "@nethserver/ns8-ui-lib";
import to from "await-to-js";
import ConfirmUnbanIpModal from "@/components/ConfirmUnbanIpModal.vue";
import ConfirmUnbanAllIpsModal from "@/components/ConfirmUnbanAllIpsModal.vue";
import Unlocked20 from "@carbon/icons-vue/es/unlocked/20";

export default {
  name: "Blocklists",
  components: {
    ConfirmUnbanIpModal,
    ConfirmUnbanAllIpsModal,
  },
  mixins: [
    QueryParamService,
    UtilService,
    IconService,
    TaskService,
    DateTimeService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("blocklists.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "blocklists",
      },
      Unlocked20,
      urlCheckInterval: null,
      // local blocklist (unban)
      tablePage: [],
      tableColumns: [
        "col_created_at",
        "col_value",
        "col_duration",
        "col_scenario",
        "",
      ],
      bans: [],
      check_bans: false,
      isShownConfirmUnbanIp: false,
      isShownConfirmUnbanIPAll: false,
      currentBan: {
        created_at: "",
        value: "",
        duration: "",
        scenario: "",
      },
      // community blocklist (capi)
      capiStatus: null,
      capiCount: null,
      capiCountUnknown: false,
      capiDisabled: false,
      searchIp: "",
      searchDone: false,
      searchFound: false,
      searchDecisions: [],
      // shared configuration, used by community blocklist + allowlist tabs
      config: null,
      enable_online_api: true,
      enroll_instance: "",
      pull_community_blocklist: true,
      whitelists: "",
      loading: {
        listBans: false,
        setDeleteBan: false,
        setUnbanAll: false,
        getCapiStatus: false,
        getCapiCount: false,
        searchCapiDecision: false,
        getConfiguration: false,
        saveCommunityConfig: false,
        saveAllowlist: false,
      },
      error: {
        listBans: "",
        setDeleteBan: "",
        setUnbanAll: "",
        getCapiStatus: "",
        getCapiCount: "",
        searchCapiDecision: "",
        getConfiguration: "",
        saveCommunityConfig: "",
        saveAllowlist: "",
        enroll_instance: "",
        whitelists: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    i18nTableColumns() {
      return this.tableColumns.map((c) => (c ? this.$t("unban." + c) : ""));
    },
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
    clearTimeout(this._capiCountTimeout);
    next();
  },
  created() {
    this.listBans();
    this.getCapiStatus();
    this.getConfiguration();
  },
  methods: {
    // ---- Local blocklist ----
    async listBans() {
      this.bans = [];
      const taskAction = "list-banned-ip";
      const eventId = this.getUuid();
      this.loading.listBans = true;
      this.error.listBans = "";
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
        this.error.listBans = this.getErrorMessage(err);
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
      listBans.forEach((ban) => {
        if (ban.decisions[0]) {
          const splitSecond = ban.decisions[0].duration.split(".");
          ban.decisions[0].duration = splitSecond[0];
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
      this.loading.setUnbanAll = false;
      this.error.setUnbanAll = "";
      this.isShownConfirmUnbanIPAll = true;
    },
    hideConfirmUnbanIPAll() {
      this.isShownConfirmUnbanIPAll = false;
    },
    toggleUnban(row) {
      this.showConfirmUnbanIP(row);
    },
    showConfirmUnbanIP(row) {
      this.currentBan = row;
      this.loading.setDeleteBan = false;
      this.error.setDeleteBan = "";
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
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setUnbanIpAborted
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setUnbanIpCompleted
      );
      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            action: "unban",
            ip: this.currentBan.value,
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
      }
    },
    setUnbanIpAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.setDeleteBan = this.$t("error.generic_error");
      this.loading.setDeleteBan = false;
    },
    setUnbanIpCompleted() {
      this.loading.setDeleteBan = false;
      this.isShownConfirmUnbanIp = false;
      this.listBans();
    },
    async setUnbanAll() {
      this.loading.setUnbanAll = true;
      this.error.setUnbanAll = "";
      const taskAction = "unban-ip";
      const eventId = this.getUuid();
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setUnbanIpAllAborted
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setUnbanIpAllCompleted
      );
      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            action: "unban_all",
            ip: "0.0.0.0",
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
      }
    },
    setUnbanIpAllAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.setUnbanAll = this.$t("error.generic_error");
      this.loading.setUnbanAll = false;
    },
    setUnbanIpAllCompleted() {
      this.loading.setUnbanAll = false;
      this.isShownConfirmUnbanIPAll = false;
      this.listBans();
    },
    // ---- Community blocklist ----
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
      const ip = this.searchIp.trim();
      if (!ip) return;
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
    goToAppCrowdsec(e) {
      window.open("https://app.crowdsec.net/", "_blank", "noopener,noreferrer");
      e.preventDefault();
    },
    // ---- Shared configuration (community blocklist + allowlist) ----
    async getConfiguration() {
      const taskAction = "get-configuration";
      const eventId = this.getUuid();
      this.loading.getConfiguration = true;
      this.error.getConfiguration = "";
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
      }
    },
    getConfigurationAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getConfiguration = this.$t("error.generic_error");
      this.loading.getConfiguration = false;
    },
    getConfigurationCompleted(taskContext, taskResult) {
      this.config = taskResult.output;
      this.enable_online_api = this.config.enable_online_api;
      this.enroll_instance = this.config.enroll_instance;
      this.pull_community_blocklist =
        this.config.pull_community_blocklist !== undefined
          ? this.config.pull_community_blocklist
          : true;
      this.whitelists = this.config.whitelists.join("\n");
      this.loading.getConfiguration = false;
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
        (validationErrors) =>
          this.configureModuleValidationFailed(
            "saveCommunityConfig",
            "enroll_instance",
            validationErrors
          )
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
      this.getConfiguration();
      this.getCapiStatus();
    },
    async saveAllowlist() {
      this.loading.saveAllowlist = true;
      this.error.saveAllowlist = "";
      this.error.whitelists = "";
      const taskAction = "configure-module";
      const eventId = this.getUuid();
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.saveAllowlistAborted
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        (validationErrors) =>
          this.configureModuleValidationFailed(
            "saveAllowlist",
            "whitelists",
            validationErrors
          )
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.saveAllowlistCompleted
      );
      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            ...this.config,
            whitelists: this.whitelists.toLowerCase().split("\n"),
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
        this.error.saveAllowlist = this.getErrorMessage(err);
        this.loading.saveAllowlist = false;
      }
    },
    saveAllowlistAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.saveAllowlist = this.$t("error.generic_error");
      this.loading.saveAllowlist = false;
    },
    saveAllowlistCompleted() {
      this.loading.saveAllowlist = false;
      this.getConfiguration();
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

.maxwidth {
  max-width: 38rem;
}

.mg-top {
  margin-top: 1rem;
}

.mg-bottom {
  margin-bottom: 1rem;
}

.mg-left {
  margin-left: 1rem;
}
</style>
