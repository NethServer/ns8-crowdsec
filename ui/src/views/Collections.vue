<!--
  Copyright (C) 2026 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <cv-grid fullWidth>
      <cv-row>
        <cv-column class="page-title">
          <h2>{{ $t("collections.title") }}</h2>
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
          <i18n
            path="collections.hub_description"
            tag="p"
            class="page-description mg-bottom"
          >
            <template #hub>
              <cv-link
                href="https://app.crowdsec.net/hub/collections"
                target="_blank"
                rel="noopener noreferrer"
                >{{ $t("collections.hub_link") }}</cv-link
              >
            </template>
          </i18n>
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column>
          <cv-tile light>
            <NsDataTable
              :allRows="collections"
              :columns="i18nTableColumns"
              :rawColumns="tableColumns"
              :sortable="true"
              :pageSizes="[10, 25, 50, 100]"
              :overflow-menu="true"
              :isSearchable="check_collections"
              :searchPlaceholder="$t('collections.search_collections')"
              :searchClearLabel="core.$t('common.clear_search')"
              :noSearchResultsLabel="core.$t('common.no_search_results')"
              :noSearchResultsDescription="
                core.$t('common.no_search_results_description')
              "
              :isLoading="loading.listCollections || loading.toggleCollection"
              :skeletonRows="5"
              :isErrorShown="!!error.listCollections"
              :errorTitle="$t('action.list-collections')"
              :errorDescription="error.listCollections"
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
                <NsEmptyState :title="$t('collections.no_collections')">
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
                    {{ row.name }}
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    <NsTag
                      :label="row.status.includes('enabled') ? $t('settings.enabled') : $t('settings.disabled')"
                      :kind="row.status.includes('enabled') ? 'green' : 'gray'"
                    />
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    {{ row.local_version || "-" }}
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    {{ row.description || "-" }}
                  </cv-data-table-cell>
                  <cv-data-table-cell class="table-overflow-menu-cell">
                    <NsButton
                      kind="ghost"
                      size="small"
                      @click="toggleCollectionMenu(row, row.status.includes('enabled') ? 'remove' : 'install')"
                      :data-test-id="row.name + '-toggle'"
                      >{{ row.status.includes('enabled') ? $t('collections.disable_collection') : $t('collections.enable_collection') }}
                    </NsButton>
                  </cv-data-table-cell>
                </cv-data-table-row>
              </template>
            </NsDataTable>
          </cv-tile>
        </cv-column>
      </cv-row>
    </cv-grid>
    <ConfirmToggleCollectionModal
      :isShown="isShownConfirmToggleCollection"
      :collection="currentCollection"
      :action="currentAction"
      :core="core"
      :isLoading="loading.toggleCollection"
      @hide="hideConfirmToggleCollection"
      @confirm="setToggleCollection"
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
import ConfirmToggleCollectionModal from "@/components/ConfirmToggleCollectionModal.vue";

export default {
  name: "Collections",
  components: {
    ConfirmToggleCollectionModal,
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
    return this.$t("collections.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "collections",
      },
      urlCheckInterval: null,
      tablePage: [],
      tableColumns: ["name", "status", "local_version", "description"],
      collections: [],
      check_collections: false,
      isShownConfirmToggleCollection: false,
      currentCollection: {
        name: "",
        status: "",
      },
      currentAction: "",
      loading: {
        listCollections: false,
        toggleCollection: false,
      },
      error: {
        listCollections: "",
        toggleCollection: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    i18nTableColumns() {
      return this.tableColumns.map((column) => {
        return this.$t("collections.col_" + column);
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
    this.listCollections();
  },
  methods: {
    async listCollections() {
      this.collections = [];
      this.error.listCollections = "";
      const taskAction = "list-collections";
      const eventId = this.getUuid();
      this.loading.listCollections = true;
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.listCollectionsAborted
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.listCollectionsCompleted
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
        this.error.listCollections = errMessage;
        this.loading.listCollections = false;
      }
    },
    listCollectionsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.listCollections = this.$t("error.generic_error");
      this.loading.listCollections = false;
    },
    listCollectionsCompleted(taskContext, taskResult) {
      let listCollections = taskResult.output;
      if (Array.isArray(listCollections)) {
        listCollections.forEach((collection) => {
          this.collections.push(collection);
        });
      } else if (listCollections && typeof listCollections === 'object') {
        Object.values(listCollections).forEach((collection) => {
          this.collections.push(collection);
        });
      }
      this.collections.sort((a, b) => {
        const aEnabled = a.status.includes("enabled");
        const bEnabled = b.status.includes("enabled");
        if (aEnabled !== bEnabled) {
          return aEnabled ? -1 : 1;
        }
        return a.name.localeCompare(b.name);
      });
      this.check_collections = this.collections.length ? true : false;
      this.loading.listCollections = false;
    },
    toggleCollectionMenu(collection, action) {
      this.currentCollection = collection;
      this.currentAction = action;
      this.showConfirmToggleCollection();
    },
    showConfirmToggleCollection() {
      this.loading.toggleCollection = false;
      this.error.toggleCollection = "";
      this.isShownConfirmToggleCollection = true;
    },
    hideConfirmToggleCollection() {
      this.isShownConfirmToggleCollection = false;
      this.loading.toggleCollection = false;
      this.error.toggleCollection = "";
    },
    async setToggleCollection() {
      this.loading.toggleCollection = true;
      this.error.toggleCollection = "";
      const taskAction = "toggle-collection";
      const eventId = this.getUuid();
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.toggleCollectionAborted
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.toggleCollectionCompleted
      );
      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            name: this.currentCollection.name,
            action: this.currentAction,
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
        this.error.toggleCollection = this.getErrorMessage(err);
        this.loading.toggleCollection = false;
        return;
      }
      this.hideConfirmToggleCollection();
    },
    toggleCollectionAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.toggleCollection = this.$t("error.generic_error");
      this.loading.toggleCollection = false;
    },
    toggleCollectionCompleted() {
      this.loading.toggleCollection = false;
      this.hideConfirmToggleCollection();
      this.listCollections();
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

.mg-bottom {
  margin-bottom: $spacing-06;
}
</style>
