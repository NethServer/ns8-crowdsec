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
            <cv-text-area
              :label="$t('settings.receiver_emails')"
              v-model.trim="receiver_emails"
              :invalid-message="error.receiver_emails"
              :helper-text="$t('settings.receiver_emails_list')"
              :value="receiver_emails"
              class="maxwidth textarea"
              ref="receiver_emails"
              :placeholder="$t('settings.receiver_emails_list')"
              :disabled="loading.getConfiguration || loading.configureModule"
            >
            </cv-text-area>
            <cv-text-area
              :label="$t('settings.whitelists')"
              v-model.trim="whitelists"
              :invalid-message="error.whitelists"
              :helper-text="$t('settings.whitelists')"
              :value="whitelists"
              class="maxwidth textarea"
              ref="receiver_emails"
              :placeholder="$t('settings.whitelistst')"
              :disabled="loading.getConfiguration || loading.configureModule"
            >
            </cv-text-area>

            <!-- advanced options -->
            <cv-accordion ref="accordion" class="maxwidth mg-bottom">
              <cv-accordion-item :open="toggleAccordion[0]">
                <template slot="title">{{ $t("settings.advanced") }}</template>
                <template slot="content">
                  <NsToggle
                    :label="$t('settings.ban_local_network')"
                    class="mg-left"
                    value="ban_local_network"
                    :form-item="true"
                    v-model="ban_local_network"
                    :disabled="
                      loading.getConfiguration || loading.configureModule
                    "
                    ref="ban_local_network"
                  >
                    <template slot="tooltip">
                      <span v-html="$t('settings.ban_local_network_tips')"></span>
                    </template>
                    <template slot="text-left">{{
                      $t("settings.disabled")
                    }}</template>
                    <template slot="text-right">{{
                      $t("settings.enabled")
                    }}</template>
                  </NsToggle>
                  <NsToggle
                    :label="$t('settings.dyn_bantime')"
                    class="mg-left"
                    value="dyn_bantime"
                    :form-item="true"
                    v-model="dyn_bantime"
                    :disabled="
                      loading.getConfiguration || loading.configureModule
                    "
                    ref="dyn_bantime"
                  >
                    <template slot="tooltip">
                      <span v-html="$t('settings.dyn_bantime_tips')"></span>
                    </template>
                    <template slot="text-left">{{
                      $t("settings.disabled")
                    }}</template>
                    <template slot="text-right">{{
                      $t("settings.enabled")
                    }}</template>
                  </NsToggle>
                  <template v-if="!dyn_bantime">
                    <NsSlider
                      :disabled="
                        loading.getConfiguration || loading.configureModule
                      "
                      :label="$t('settings.bantime')"
                      class="mg-left"
                      v-model="bantime"
                      min="1"
                      max="600"
                      step="1"
                      stepMultiplier="10"
                      minLabel=""
                      maxLabel=""
                      :limitedLabel="$t('settings.specify_duration')"
                      :invalidMessage="error.bantime"
                      :unitLabel="$t('settings.minutes')"
                    />
                  </template>
                  <NsToggle
                    :label="$t('settings.disable_online_api')"
                    class="mg-left"
                    value="disable_online_api"
                    :form-item="true"
                    v-model="disable_online_api"
                    :disabled="
                      loading.getConfiguration || loading.configureModule
                    "
                    ref="disable_online_api"
                  >
                    <template slot="tooltip">
                      <span
                        v-html="$t('settings.disable_online_api_tips')"
                      ></span>
                    </template>
                    <template slot="text-left">{{
                      $t("settings.disabled")
                    }}</template>
                    <template slot="text-right">{{
                      $t("settings.enabled")
                    }}</template>
                  </NsToggle>
                  <NsTextInput
                    :label="$t('settings.helo_host')"
                    :placeholder="$t('settings.helo_host_placeholder')"
                    v-model="helo_host"
                    class="mg-bottom mg-left"
                    :invalid-message="error.helo_host"
                    :disabled="
                      loading.getConfiguration || loading.configureModule
                    "
                    ref="helo_host"
                    tooltipAlignment="center"
                    tooltipDirection="right"
                  >
                    <template slot="tooltip">
                      <div
                        v-html="
                          $t('settings.helo_host_must_be_relevant_for_smtp')
                        "
                      ></div>
                    </template>
                  </NsTextInput>
                </template>
              </cv-accordion-item>
            </cv-accordion>
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
      urlCheckInterval: null,
      ban_local_network: false,
      helo_host: "",
      receiver_emails: [],
      bantime: "1m",
      dyn_bantime: true,
      whitelists: [],
      disable_online_api: false,
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
        whitelists: "",
        disable_online_api: "",
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
    goToEjabberdWebAdmin() {
      window.open(`https://${this.hostname}` + ":5280/admin/", "_blank");
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
      this.helo_host = config.helo_host;
      this.receiver_emails = config.receiver_emails.join("\n");
      this.bantime = String(config.bantime);
      this.dyn_bantime = config.dyn_bantime;
      this.whitelists = config.whitelists.join("\n");
      this.disable_online_api = config.disable_online_api;
      this.loading.getConfiguration = false;
      this.focusElement("receiver_emails");
      this.ban_local_network = config.ban_local_network;
    },
    validateConfigureModule() {
      this.clearErrors(this);
      let isValidationOk = true;

      function validateEmail(email) {
        var re = /\S+@\S+\.\S+/;
        return re.test(email);
      }
      function validateIpv4(test) {
        var re =
          /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
        return re.test(test);
      }
      function validateNetworkIpv4(test) {
        var re =
          /^(?:(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\/(?:3[0-2]|[12]*\d),)*(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\/(?:3[0-2]|[12]*\d)$/;
        return re.test(test);
      }
      function validateNetworkIpv6(test) {
        var re =
          /(?:(?:(?:[A-F0-9]{1,4}:){6}|(?=(?:[A-F0-9]{0,4}:){0,6}(?:[0-9]{1,3}\.){3}[0-9]{1,3}(?![:.\w]))(([0-9A-F]{1,4}:){0,5}|:)((:[0-9A-F]{1,4}){1,5}:|:)|::(?:[A-F0-9]{1,4}:){5})(?:(?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)|(?:[A-F0-9]{1,4}:){7}[A-F0-9]{1,4}|(?=(?:[A-F0-9]{0,4}:){0,7}[A-F0-9]{0,4}(?![:.\w]))(([0-9A-F]{1,4}:){1,7}|:)((:[0-9A-F]{1,4}){1,7}|:)|(?:[A-F0-9]{1,4}:){7}:|:(:[A-F0-9]{1,4}){7})(?![:.\w])\/(?:12[0-8]|1[01][0-9]|[1-9]?[0-9])/;
        return re.test(test);
      }
      function validateIpv6(test) {
        var re =
          /^([0-9A-Fa-f]{0,4}:){2,7}([0-9A-Fa-f]{1,4}$|((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4})$/;
        return re.test(test);
      }
      function validateHostname(test) {
        var re = /^(?:([a-z0-9-]+|\*)\.)?([a-z0-9-]{1,61})\.([a-z0-9]{2,7})$/;
        return re.test(test);
      }

      if (this.receiver_emails) {
        const array = this.receiver_emails.split("\n");
        array.forEach((element) => {
          var email = validateEmail(element.trim());
          if (!email) {
            this.error.receiver_emails =
              this.$t("settings.bad_email_address") + " ' " + element + " '";
            this.focusElement("receiver_emails");
            isValidationOk = false;
          }
        });
      }
      if (this.whitelists) {
        const array = this.whitelists.split("\n");
        array.forEach((element) => {
          var hostname = validateHostname(element.trim().toLowerCase());
          var ipv4 = validateIpv4(element.trim());
          var ipv6 = validateIpv6(element.trim());
          var NetworkIPV4 = validateNetworkIpv4(element.trim());
          var NetworkIPV6 = validateNetworkIpv6(element.trim());
          if (!hostname && !ipv4 && !ipv6 && !NetworkIPV4 && !NetworkIPV6) {
            this.error.whitelists =
              this.$t("settings.bad_IP_or_hostname") + " ' " + element + " '";
            this.focusElement("whitelists");
            isValidationOk = false;
          }
        });
      }
      return isValidationOk;
    },
    configureModuleValidationFailed(validationErrors) {
      this.loading.configureModule = false;

      for (const validationError of validationErrors) {
        const param = validationError.parameter;

        // set i18n error message
        this.error[param] = this.$t("settings." + validationError.error);
      }
    },
    async configureModule() {
      const isValidationOk = this.validateConfigureModule();
      if (!isValidationOk) {
        return;
      }

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
            helo_host: this.helo_host,
            receiver_emails: this.receiver_emails.toLowerCase().split("\n"),
            bantime: String(this.bantime),
            dyn_bantime: this.dyn_bantime,
            whitelists: this.whitelists.toLowerCase().split("\n"),
            disable_online_api: this.disable_online_api,
            ban_local_network: this.ban_local_network,
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
.mg-left {
  margin-left: 2rem;
}
.maxwidth {
  max-width: 38rem;
}
.mg-bottom {
  margin-bottom: $spacing-06;
}
</style>
