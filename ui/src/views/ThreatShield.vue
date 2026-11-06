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
            :icon="Add20"
            class="mg-bottom"
            :disabled="loading.listThreatShield || loading.setThreatShield"
            @click="showListModal('blocklist')"
            >{{ $t("threat_shield.add_blocklist") }}</NsButton
          >
          <cv-form @submit.prevent="setThreatShield('blocklists')">
            <NsInlineNotification
              v-for="failure in !loading.listThreatShield ? importFailures : []"
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
              <template slot="headings">
                <cv-data-table-heading
                  v-for="(column, index) in i18nTableColumns"
                  :key="index"
                  :heading="column"
                >
                  <span v-if="tableColumns[index] === 'blocked'">
                    {{ column }}
                    <cv-interactive-tooltip
                      alignment="center"
                      direction="bottom"
                      class="info"
                    >
                      <template slot="content">
                        {{ $t("threat_shield.blocked_tooltip") }}
                      </template>
                    </cv-interactive-tooltip>
                  </span>
                  <template v-else>{{ column }}</template>
                </cv-data-table-heading>
              </template>
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
                      {{ feedTitle(feed) }}
                      <NsTag
                        v-if="feed.custom"
                        kind="blue"
                        size="sm"
                        :label="$t('threat_shield.custom')"
                      />
                      <cv-interactive-tooltip
                        v-if="feed.key === insightsFeedKey"
                        alignment="center"
                        direction="bottom"
                        class="info"
                      >
                        <template slot="content">
                          {{ $t("threat_shield.insights_tooltip") }}
                        </template>
                      </cv-interactive-tooltip>
                    </span>
                    <div v-if="feed.custom" class="list-url">
                      {{ feed.url }}
                    </div>
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    <NsToggle
                      :label="feedTitle(feed)"
                      class="status-toggle"
                      hideLabel
                      :value="feed.key"
                      :form-item="false"
                      v-model="selected[feed.key]"
                      :disabled="
                        (!canEdit && !feed.custom) || loading.setThreatShield
                      "
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
                    {{
                      lastResult("feeds", feed.key, feed.enabled)
                        ? lastResult("feeds", feed.key, feed.enabled).entries
                        : "-"
                    }}
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    {{ feed.enabled ? feed.blocked_24h : "-" }}
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    {{
                      lastResult("feeds", feed.key, feed.enabled)
                        ? formatDateTime(
                            lastResult("feeds", feed.key, feed.enabled)
                              .timestamp
                          )
                        : "-"
                    }}
                  </cv-data-table-cell>
                  <cv-data-table-cell class="table-overflow-menu-cell">
                    <cv-overflow-menu
                      v-if="feed.custom"
                      flip-menu
                      class="table-overflow-menu"
                    >
                      <cv-overflow-menu-item
                        @click="showListModal('blocklist', feed)"
                      >
                        <NsMenuItem
                          :icon="Edit20"
                          :label="core.$t('common.edit')"
                        />
                      </cv-overflow-menu-item>
                      <cv-overflow-menu-item
                        danger
                        @click="showDeleteModal('blocklist', feed)"
                      >
                        <NsMenuItem
                          :icon="TrashCan20"
                          :label="core.$t('common.delete')"
                        />
                      </cv-overflow-menu-item>
                    </cv-overflow-menu>
                  </cv-data-table-cell>
                </cv-data-table-row>
              </template>
            </NsDataTable>
            <NsInlineNotification
              v-if="error.setThreatShield && saveSource === 'blocklists'"
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
              :loading="loading.setThreatShield && saveSource === 'blocklists'"
              :disabled="
                (!canEdit && !feeds.some((feed) => feed.custom)) ||
                loading.listThreatShield ||
                loading.setThreatShield
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
          <h4>{{ $t("threat_shield.allowlist_title") }}</h4>
          <p class="mg-bottom">
            {{ $t("threat_shield.allowlist_description") }}
          </p>
          <NsButton
            kind="secondary"
            :icon="Add20"
            class="mg-bottom"
            :disabled="loading.listThreatShield || loading.setThreatShield"
            @click="showListModal('allowlist')"
            >{{ $t("threat_shield.add_allowlist") }}</NsButton
          >
          <cv-form @submit.prevent="setThreatShield('allowlists')">
            <template v-if="!loading.listThreatShield">
              <NsInlineNotification
                v-if="hasNethesisAllowlist && !allowlistSelected.nethesis"
                kind="warning"
                :title="$t('threat_shield.nethesis_allowlist_off_title')"
                :description="$t('threat_shield.nethesis_allowlist_off')"
                :showCloseButton="false"
              />
              <NsInlineNotification
                v-for="failure in allowlistFailures"
                :key="failure.key"
                kind="error"
                :title="failure.title"
                :description="failure.error"
                :showCloseButton="false"
              />
            </template>
            <NsDataTable
              :allRows="allowlists"
              :columns="i18nAllowlistColumns"
              :rawColumns="allowlistColumns"
              :sortable="false"
              :pageSizes="[]"
              :overflow-menu="false"
              :isLoading="loading.listThreatShield"
              :skeletonRows="2"
              :isErrorShown="!!error.listThreatShield"
              :errorTitle="$t('action.list-threat-shield')"
              :errorDescription="error.listThreatShield"
              @updatePage="allowlistPage = $event"
            >
              <template slot="empty-state">
                <NsEmptyState :title="$t('threat_shield.no_allowlists')" />
              </template>
              <template slot="data">
                <cv-data-table-row
                  v-for="row in allowlistPage"
                  :key="row.name"
                  :value="row.name"
                >
                  <cv-data-table-cell>
                    <span class="feed-name">
                      {{
                        row.builtin
                          ? $t("threat_shield.nethesis_allowlist")
                          : row.name
                      }}
                      <cv-interactive-tooltip
                        v-if="row.builtin"
                        alignment="center"
                        direction="bottom"
                        class="info"
                      >
                        <template slot="content">
                          {{ $t("threat_shield.nethesis_allowlist_tooltip") }}
                        </template>
                      </cv-interactive-tooltip>
                    </span>
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    {{ row.builtin ? "" : row.description || "-" }}
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    <NsToggle
                      :label="allowlistTitle(row)"
                      class="status-toggle"
                      hideLabel
                      :value="row.name"
                      :form-item="false"
                      v-model="allowlistSelected[row.name]"
                      :disabled="loading.setThreatShield"
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
                    {{
                      lastResult("allowlists", row.name, row.enabled)
                        ? lastResult("allowlists", row.name, row.enabled)
                            .entries
                        : "-"
                    }}
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    {{
                      lastResult("allowlists", row.name, row.enabled)
                        ? formatDateTime(
                            lastResult("allowlists", row.name, row.enabled)
                              .timestamp
                          )
                        : "-"
                    }}
                  </cv-data-table-cell>
                  <cv-data-table-cell class="table-overflow-menu-cell">
                    <cv-overflow-menu
                      v-if="!row.builtin"
                      flip-menu
                      class="table-overflow-menu"
                    >
                      <cv-overflow-menu-item
                        @click="showListModal('allowlist', row)"
                      >
                        <NsMenuItem
                          :icon="Edit20"
                          :label="core.$t('common.edit')"
                        />
                      </cv-overflow-menu-item>
                      <cv-overflow-menu-item
                        danger
                        @click="showDeleteModal('allowlist', row)"
                      >
                        <NsMenuItem
                          :icon="TrashCan20"
                          :label="core.$t('common.delete')"
                        />
                      </cv-overflow-menu-item>
                    </cv-overflow-menu>
                  </cv-data-table-cell>
                </cv-data-table-row>
              </template>
            </NsDataTable>
            <NsInlineNotification
              v-if="error.setThreatShield && saveSource === 'allowlists'"
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
              :loading="loading.setThreatShield && saveSource === 'allowlists'"
              :disabled="
                !allowlists.length ||
                loading.listThreatShield ||
                loading.setThreatShield
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
    <NsModal
      size="default"
      :visible="listModal.visible"
      :primaryButtonDisabled="loading.setThreatShield"
      :isLoading="loading.setThreatShield"
      hasFormContent
      @modal-hidden="listModal.visible = false"
      @primary-click="saveListModal"
    >
      <template slot="title">{{
        $t(
          `threat_shield.${listModal.isEdit ? "edit" : "add"}_${listModal.kind}`
        )
      }}</template>
      <template slot="content">
        <cv-form @submit.prevent="saveListModal">
          <NsTextInput
            v-model.trim="listModal.name"
            :label="$t('threat_shield.name')"
            :helper-text="$t('threat_shield.name_helper')"
            :invalid-message="error.listName"
            :disabled="listModal.isEdit || loading.setThreatShield"
            ref="listName"
          />
          <NsTextInput
            v-model.trim="listModal.description"
            :label="$t('threat_shield.list_description')"
            :invalid-message="error.listDescription"
            :disabled="loading.setThreatShield"
            ref="listDescription"
          />
          <NsTextInput
            v-model.trim="listModal.url"
            :label="$t('threat_shield.url')"
            placeholder="https://"
            :helper-text="$t('threat_shield.url_credentials_hint')"
            :invalid-message="error.listUrl"
            :disabled="loading.setThreatShield"
            ref="listUrl"
          />
          <NsToggle
            v-if="listModal.kind === 'allowlist'"
            :label="$t('threat_shield.col_status')"
            value="enabled"
            v-model="listModal.enabled"
            :disabled="loading.setThreatShield"
          >
            <template slot="text-left">{{ $t("settings.disabled") }}</template>
            <template slot="text-right">{{ $t("settings.enabled") }}</template>
          </NsToggle>
          <NsInlineNotification
            kind="info"
            :title="$t('threat_shield.list_format_title')"
            :description="$t(`threat_shield.${listModal.kind}_format`)"
            :showCloseButton="false"
          />
          <NsInlineNotification
            v-if="error.setThreatShield && saveSource === 'modal'"
            kind="error"
            :title="$t('action.set-threat-shield')"
            :description="error.setThreatShield"
            :showCloseButton="false"
          />
        </cv-form>
      </template>
      <template slot="secondary-button">{{
        core.$t("common.cancel")
      }}</template>
      <template slot="primary-button">{{ $t("settings.save") }}</template>
    </NsModal>
    <NsModal
      size="default"
      kind="danger"
      :visible="deleteModal.visible"
      :primaryButtonDisabled="loading.setThreatShield"
      :isLoading="loading.setThreatShield"
      @modal-hidden="deleteModal.visible = false"
      @primary-click="deleteList"
    >
      <template slot="title">{{
        $t(`threat_shield.delete_${deleteModal.kind}`)
      }}</template>
      <template slot="content">
        <div>
          {{ $t("threat_shield.delete_confirm", { name: deleteModal.name }) }}
        </div>
        <NsInlineNotification
          v-if="error.setThreatShield && saveSource === 'modal'"
          kind="error"
          :title="$t('action.set-threat-shield')"
          :description="error.setThreatShield"
          :showCloseButton="false"
        />
      </template>
      <template slot="secondary-button">{{
        core.$t("common.cancel")
      }}</template>
      <template slot="primary-button">{{ core.$t("common.delete") }}</template>
    </NsModal>
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
        "blocked",
        "last_update",
        "actions",
      ],
      allowlistColumns: [
        "name",
        "description",
        "enabled",
        "entries",
        "last_update",
        "actions",
      ],
      urlCheckInterval: null,
      // Must match threat_shield.INSIGHTS_FEED_KEY in the backend.
      insightsFeedKey: "nethesis-insights",
      feeds: [],
      tablePage: [],
      selected: {},
      allowlists: [],
      allowlistPage: [],
      allowlistSelected: {},
      // Which form the last set-threat-shield came from, to place its errors.
      saveSource: "",
      listModal: {
        visible: false,
        kind: "blocklist",
        isEdit: false,
        name: "",
        url: "",
        description: "",
        enabled: true,
      },
      deleteModal: { visible: false, kind: "blocklist", name: "" },
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
        listName: "",
        listUrl: "",
        listDescription: "",
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
        this.$t("threat_shield.col_blocked"),
        this.$t("threat_shield.col_last_update"),
        "",
      ];
    },
    i18nAllowlistColumns() {
      return [
        this.$t("threat_shield.name"),
        this.$t("threat_shield.col_description"),
        this.$t("threat_shield.col_status"),
        this.$t("threat_shield.col_entries"),
        this.$t("threat_shield.col_last_update"),
        "",
      ];
    },
    hasNethesisAllowlist() {
      return this.allowlists.some((row) => row.builtin);
    },
    // Failed runs and failed enabled feeds; the table only shows "-" for them.
    importFailures() {
      const failures = [];
      if (!this.lastImport) {
        return failures;
      }
      const runError = this.lastImport.error;
      // Catalog feeds stay quiet without the entitlement; custom ones don't need it.
      const showRunError =
        runError === "no_subscription"
          ? this.feeds.some((f) => !f.custom && f.enabled)
          : runError &&
            (this.canEdit || this.feeds.some((f) => f.custom && f.enabled));
      if (showRunError) {
        failures.push({
          key: "run",
          title: this.$t("threat_shield.last_import_failure"),
          error:
            runError === "no_subscription"
              ? this.$t("threat_shield.import_no_subscription")
              : runError,
        });
      }
      const results = this.lastImport.feeds || {};
      for (const feed of this.feeds) {
        const result = results[feed.key];
        if (
          (this.canEdit || feed.custom) &&
          feed.enabled &&
          result &&
          !result.success
        ) {
          failures.push({
            key: feed.key,
            title: this.$t("threat_shield.feed_import_failure", {
              feed: this.feedTitle(feed),
            }),
            error: result.error || this.$t("error.generic_error"),
          });
        }
      }
      return failures;
    },
    allowlistFailures() {
      const results = (this.lastImport && this.lastImport.allowlists) || {};
      return this.allowlists
        .filter((row) => row.enabled && results[row.name])
        .filter((row) => !results[row.name].success)
        .map((row) => ({
          key: row.name,
          title: this.$t("threat_shield.feed_import_failure", {
            feed: this.allowlistTitle(row),
          }),
          error: results[row.name].error || this.$t("error.generic_error"),
        }));
    },
    isValidIp() {
      return isValidIpAddress(this.searchIp);
    },
    // Names of the blocklists matching the searched IP, once each.
    searchFeeds() {
      return [
        ...new Set(this.searchDecisions.map((d) => this.feedLabel(d.scenario))),
      ];
    },
  },
  watch: {
    searchIp() {
      this.error.searchIp = "";
      this.searchDone = false;
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
    // Last successful import of an enabled feed or allowlist, or null.
    lastResult(section, key, enabled) {
      const results = (this.lastImport && this.lastImport[section]) || {};
      const result = enabled && results[key];
      return result && result.success ? result : null;
    },
    feedLabel(scenario) {
      const key = (scenario || "").replace("threat-shield/", "");
      const feed = this.feeds.find((f) => f.key === key);
      return feed ? this.feedTitle(feed) : scenario;
    },
    // Name of a custom list; a custom feed has it in its "custom-<name>" key.
    listName(row) {
      return row.name || row.key.replace(/^custom-/, "");
    },
    feedTitle(feed) {
      return feed.description || this.listName(feed);
    },
    allowlistTitle(row) {
      return row.builtin
        ? this.$t("threat_shield.nethesis_allowlist")
        : row.description || row.name;
    },
    showListModal(kind, row = null) {
      this.clearListErrors();
      this.listModal = {
        visible: true,
        kind,
        isEdit: !!row,
        name: row ? this.listName(row) : "",
        url: row ? row.url : "",
        description: row ? row.description || "" : "",
        enabled: row ? !!this.allowlistSelected[row.name] : true,
      };
    },
    showDeleteModal(kind, row) {
      this.clearListErrors();
      this.deleteModal = {
        visible: true,
        kind,
        name: this.listName(row),
      };
    },
    clearListErrors() {
      this.error.listName = "";
      this.error.listUrl = "";
      this.error.listDescription = "";
      this.error.setThreatShield = "";
    },
    validateListModal() {
      this.clearListErrors();
      const m = this.listModal;
      const names =
        m.kind === "allowlist"
          ? this.allowlists.filter((a) => !a.builtin).map((a) => a.name)
          : this.feeds.filter((f) => f.custom).map(this.listName);
      if (!/^[a-z0-9][a-z0-9-]{0,19}$/.test(m.name)) {
        this.error.listName = this.$t("threat_shield.invalid_name");
      } else if (m.kind === "allowlist" && m.name === "nethesis") {
        this.error.listName = this.$t("threat_shield.reserved_name");
      } else if (!m.isEdit && names.includes(m.name)) {
        this.error.listName = this.$t("threat_shield.duplicated_name");
      }
      if (!/^https?:\/\/\S+$/.test(m.url) || m.url.length > 512) {
        this.error.listUrl = this.$t("threat_shield.invalid_url");
      } else if (!/^https?:\/\/[^/?#@\s]+([/?#]\S*)?$/.test(m.url)) {
        this.error.listUrl = this.$t("threat_shield.url_credentials");
      }
      if (m.description.length > 128) {
        this.error.listDescription = this.$t(
          "threat_shield.invalid_description"
        );
      }
      const invalid = ["listName", "listDescription", "listUrl"].find(
        (key) => this.error[key]
      );
      if (invalid) {
        this.focusElement(invalid);
        return false;
      }
      return true;
    },
    // Full set-threat-shield input from the current (staged) page state.
    currentPayload() {
      const data = {
        feeds: this.feeds
          .filter((feed) => this.selected[feed.key])
          .map((feed) => feed.key),
        custom_allowlists: this.allowlists
          .filter((row) => !row.builtin)
          .map((row) => ({
            name: row.name,
            url: row.url,
            description: row.description || "",
            enabled: !!this.allowlistSelected[row.name],
          })),
        custom_blocklists: this.feeds
          .filter((feed) => feed.custom)
          .map((feed) => ({
            name: this.listName(feed),
            url: feed.url,
            description: feed.description || "",
          })),
      };
      if (this.hasNethesisAllowlist) {
        data.nethesis_allowlist = !!this.allowlistSelected.nethesis;
      }
      return data;
    },
    saveListModal() {
      if (!this.validateListModal()) return;
      const m = this.listModal;
      const data = this.currentPayload();
      const item = { name: m.name, url: m.url, description: m.description };
      const field =
        m.kind === "allowlist" ? "custom_allowlists" : "custom_blocklists";
      if (m.kind === "allowlist") {
        item.enabled = m.enabled;
      } else if (!m.isEdit) {
        // A new custom blocklist starts enabled.
        data.feeds.push(`custom-${m.name}`);
      }
      const rows = data[field];
      const i = rows.findIndex((row) => row.name === m.name);
      rows.splice(i < 0 ? rows.length : i, 1, item);
      this.setThreatShield("modal", data);
    },
    deleteList() {
      const { kind, name } = this.deleteModal;
      const data = this.currentPayload();
      const field = `custom_${kind}s`;
      data[field] = data[field].filter((row) => row.name !== name);
      if (kind === "blocklist") {
        data.feeds = data.feeds.filter((key) => key !== `custom-${name}`);
      }
      this.setThreatShield("modal", data);
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
      this.allowlists = output.allowlists || [];
      // The built-in row is "nethesis", a name custom allowlists cannot use.
      this.allowlistSelected = this.allowlists.reduce((acc, row) => {
        acc[row.name] = row.enabled;
        return acc;
      }, {});
      // Replace the whole object so every key is reactive in Vue 2.
      this.selected = output.feeds.reduce((acc, feed) => {
        acc[feed.key] = feed.enabled;
        return acc;
      }, {});
      this.loading.listThreatShield = false;
    },
    async setThreatShield(source, data = null) {
      this.saveSource = source;
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
          data: data || this.currentPayload(),
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
      for (const e of validationErrors) {
        if (
          this.listModal.visible &&
          ["duplicated_name", "reserved_name"].includes(e.error)
        ) {
          this.error.listName = this.$t(`threat_shield.${e.error}`);
        } else {
          this.error.setThreatShield = this.$t(
            e.error === "unknown_feed"
              ? "threat_shield.unknown_feed"
              : "error.validation_error"
          );
        }
      }
      this.loading.setThreatShield = false;
    },
    setThreatShieldCompleted() {
      this.loading.setThreatShield = false;
      this.listModal.visible = false;
      this.deleteModal.visible = false;
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

.list-url {
  color: $text-02;
  font-size: 0.75rem;
  word-break: break-all;
}

.status-toggle ::v-deep .bx--toggle__switch {
  margin-top: 0;
}

::v-deep .empty-state {
  background-color: $ui-01;
}
</style>
