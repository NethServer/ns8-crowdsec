<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <cv-grid fullWidth>
    <cv-row>
      <cv-column class="page-title">
        <h2>{{ $t("settings.title") }}</h2>
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
    <cv-row>
      <cv-column>
        <cv-tile light>
          <cv-skeleton-text
            v-if="loading.getConfiguration || loading.getDefaults"
            heading
            paragraph
            :line-count="15"
            width="80%"
          ></cv-skeleton-text>
          <cv-form v-else @submit.prevent="configureModule">
            <template v-if="!mail_configured">
              <NsInlineNotification
                kind="info"
                :title="$t('settings.smarthost_is_disabled')"
                :description="
                  $t('settings.smarthosts_is_needed_to_send_notifications')
                "
                :actionLabel="
                  $t('settings.enable_smarthosts_for_notifications')
                "
                @action="goToSmarthost()"
                :showCloseButton="false"
              />
            </template>
            <cv-text-area
              :label="$t('settings.receiver_emails')"
              v-model.trim="receiver_emails"
              :invalid-message="error.receiver_emails"
              :helper-text="$t('settings.receiver_emails_list')"
              :value="receiver_emails"
              class="maxwidth textarea"
              ref="receiver_emails"
              :disabled="
                loading.getConfiguration ||
                loading.configureModule ||
                !mail_configured
              "
            >
            </cv-text-area>
            <NsTextInput
              :label="$t('settings.group_threshold_label')"
              :placeholder="$t('settings.group_threshold_placeholder')"
              v-model="group_threshold"
              class="mg-bottom maxwidth"
              type="number"
              min="1"
              max="10000"
              step="1"
              :invalid-message="error.group_threshold"
              :disabled="
                loading.getConfiguration ||
                loading.configureModule ||
                !mail_configured
              "
              ref="group_threshold"
              tooltipAlignment="center"
              tooltipDirection="right"
            >
              <template slot="tooltip">
                <div>
                  {{ $t("settings.group_threshold_tooltips") }}
                </div>
              </template>
            </NsTextInput>
            <NsTextInput
              :label="$t('settings.helo_host')"
              :placeholder="$t('settings.helo_host_placeholder')"
              v-model="helo_host"
              class="mg-bottom maxwidth"
              :invalid-message="error.helo_host"
              :disabled="
                loading.getConfiguration ||
                loading.configureModule ||
                !mail_configured
              "
              ref="helo_host"
              tooltipAlignment="center"
              tooltipDirection="right"
            >
              <template slot="tooltip">
                <div>
                  {{ $t("settings.helo_host_must_be_relevant_for_smtp") }}
                </div>
              </template>
            </NsTextInput>
            <NsToggle
              :label="$t('settings.ban_local_network')"
              class="mg-top-md maxwidth"
              value="ban_local_network"
              :form-item="true"
              v-model="ban_local_network"
              :disabled="loading.getConfiguration || loading.configureModule"
              ref="ban_local_network"
            >
              <template slot="tooltip">
                <span>{{ $t("settings.ban_local_network_tips") }}</span>
              </template>
              <template slot="text-left">{{
                $t("settings.disabled")
              }}</template>
              <template slot="text-right">{{
                $t("settings.enabled")
              }}</template>
            </NsToggle>
            <label class="bx--label">
              {{ $t("settings.bantime") }}
              <cv-interactive-tooltip
                alignment="center"
                direction="bottom"
                class="info"
              >
                <template slot="content">
                  {{ $t("settings.bantime_tips") }}
                </template>
              </cv-interactive-tooltip>
            </label>
            <cv-radio-group vertical class="mg-bottom maxwidth">
              <cv-radio-button
                :label="$t('settings.dynamic_bantime_increment')"
                value="dynamic"
                ref="dynamicBanTimeEnabled"
                v-model="dyn_bantime"
                :disabled="loading.getConfiguration || loading.configureModule"
              />
              <p class="bantime-description">
                {{ $t("settings.dynamic_bantime_increment_description") }}
              </p>
              <NsSlider
                v-if="dyn_bantime === 'dynamic'"
                :disabled="loading.getConfiguration || loading.configureModule"
                :label="$t('settings.dynamic_bantime_duration')"
                v-model="dynamicBantimeDuration"
                min="1"
                max="1440"
                step="1"
                stepMultiplier="10"
                minLabel=""
                maxLabel=""
                :limitedLabel="$t('settings.specify_duration')"
                :invalidMessage="error.bantime"
                :unitLabel="$t('settings.minutes')"
              />
              <cv-radio-button
                :label="$t('settings.static_bantime_increment')"
                value="static"
                ref="dynamicBanTimeDisabled"
                v-model="dyn_bantime"
                :disabled="loading.getConfiguration || loading.configureModule"
              />
              <p class="bantime-description">
                {{ $t("settings.static_bantime_increment_description") }}
              </p>
              <NsSlider
                v-if="dyn_bantime === 'static'"
                :disabled="loading.getConfiguration || loading.configureModule"
                :label="$t('settings.static_bantime_duration')"
                v-model="bantime"
                min="1"
                max="1440"
                step="1"
                stepMultiplier="10"
                minLabel=""
                maxLabel=""
                :limitedLabel="$t('settings.specify_duration')"
                :invalidMessage="error.bantime"
                :unitLabel="$t('settings.minutes')"
              />
            </cv-radio-group>
            <cv-row v-if="error.configureModule">
              <cv-column>
                <NsInlineNotification
                  kind="error"
                  :title="$t('action.configure-module')"
                  :description="error.configureModule"
                  :showCloseButton="false"
                />
              </cv-column>
            </cv-row>
            <NsButton
              kind="primary"
              :icon="Save20"
              :loading="loading.configureModule"
              :disabled="loading.getConfiguration || loading.configureModule"
              >{{ $t("settings.save") }}</NsButton
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

export default {
  name: "Settings",
  mixins: [
    TaskService,
    IconService,
    UtilService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("settings.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "settings",
      },
      dynamicBantimeDuration: "4",
      urlCheckInterval: null,
      mail_configured: false,
      ban_local_network: false,
      helo_host: "",
      receiver_emails: [],
      bantime: "1m",
      dyn_bantime: true,
      group_threshold: "100",
      config: {},
      loading: {
        getConfiguration: false,
        configureModule: false,
      },
      error: {
        getConfiguration: "",
        configureModule: "",
        ban_local_network: "",
        helo_host: "",
        receiver_emails: "",
        bantime: "",
        dyn_bantime: "",
        group_threshold: "",
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
    goToSmarthost() {
      this.core.$router.push("/settings/smarthost");
    },
    async getConfiguration() {
      this.loading.getConfiguration = true;
      this.error.getConfiguration = "";
      const taskAction = "get-configuration";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getConfigurationAborted
      );

      // register to task completion
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
      this.helo_host = config.helo_host;
      this.receiver_emails = config.receiver_emails.join("\n");
      this.bantime = String(config.bantime);
      this.dyn_bantime = config.dyn_bantime ? "dynamic" : "static";
      this.loading.getConfiguration = false;
      this.focusElement("receiver_emails");
      this.ban_local_network = config.ban_local_network;
      this.mail_configured = config.mail_configured;
      this.group_threshold = String(config.group_threshold);
      this.dynamicBantimeDuration = String(config.dynamic_bantime_duration);
    },
    configureModuleValidationFailed(validationErrors) {
      this.loading.configureModule = false;

      for (const validationError of validationErrors) {
        const param = validationError.parameter;

        // set i18n error message
        this.error[param] = this.$t("settings." + validationError.error, {
          value: validationError.value,
        });
      }
    },
    async configureModule() {
      this.loading.configureModule = true;
      const taskAction = "configure-module";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.configureModuleAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.configureModuleValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.configureModuleCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            ...this.config,
            helo_host: this.helo_host,
            receiver_emails: this.receiver_emails.toLowerCase().split("\n"),
            bantime: String(this.bantime),
            dyn_bantime: this.dyn_bantime === "dynamic",
            ban_local_network: this.ban_local_network,
            group_threshold: parseInt(this.group_threshold),
            dynamic_bantime_duration: this.dynamicBantimeDuration,
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
        this.error.configureModule = this.getErrorMessage(err);
        this.loading.configureModule = false;
        return;
      }
    },
    configureModuleAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.configureModule = this.$t("error.generic_error");
      this.loading.configureModule = false;
    },
    configureModuleCompleted() {
      this.loading.configureModule = false;

      // reload configuration
      this.getConfiguration();
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

.mg-top-md {
  margin-top: $spacing-05;
}

.bantime-description {
  font-size: 0.75rem;
  color: $text-02;
  margin-top: -0.5rem;
  margin-bottom: 0.5rem;
}

.toolbar {
  display: flex;
  align-items: center;
  margin-bottom: $spacing-05;
}

.page-toolbar {
  display: flex;
  justify-content: flex-end;
}
</style>
