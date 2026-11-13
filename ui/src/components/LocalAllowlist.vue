<!--
  Copyright (C) 2026 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <cv-row>
      <cv-column>
        <p class="mg-bottom">
          {{ $t("blocklists.allowlist_description") }}
        </p>
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column>
        <cv-tile light>
          <cv-text-area
            :label="$t('settings.whitelists')"
            v-model.trim="whitelists"
            :invalid-message="error.whitelists"
            :helper-text="$t('settings.whitelists_tips')"
            :value="whitelists"
            class="maxwidth textarea"
            ref="whitelists"
            :rows="6"
            :placeholder="$t('settings.whitelist_placeholder')"
            :disabled="loadingConfig || loading.saveAllowlist"
          >
          </cv-text-area>
          <NsInlineNotification
            kind="info"
            :title="$t('blocklists.allowlist_info_title')"
            :description="$t('blocklists.allowlist_info_description')"
            :showCloseButton="false"
            class="mg-top mg-bottom maxwidth"
          />
          <cv-row v-if="error.saveAllowlist">
            <cv-column>
              <NsInlineNotification
                kind="error"
                :title="$t('error_title.configure-module')"
                :description="error.saveAllowlist"
                :showCloseButton="false"
                class="mg-bottom"
              />
            </cv-column>
          </cv-row>
          <NsButton
            kind="primary"
            :icon="Save20"
            class="mg-top"
            :loading="loading.saveAllowlist"
            :disabled="loadingConfig || loading.saveAllowlist"
            @click="saveAllowlist"
            >{{ $t("settings.save") }}</NsButton
          >
        </cv-tile>
      </cv-column>
    </cv-row>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { UtilService, IconService, TaskService } from "@nethserver/ns8-ui-lib";
import to from "await-to-js";

export default {
  name: "LocalAllowlist",
  mixins: [UtilService, IconService, TaskService],
  props: {
    // get-configuration output, loaded by the page; null until then
    config: { type: Object, default: null },
    loadingConfig: Boolean,
  },
  data() {
    return {
      whitelists: "",
      loading: { saveAllowlist: false },
      error: { saveAllowlist: "", whitelists: "" },
    };
  },
  computed: {
    ...mapState(["instanceName", "core"]),
  },
  watch: {
    config: {
      immediate: true,
      handler(config) {
        if (config) this.whitelists = config.whitelists.join("\n");
      },
    },
  },
  methods: {
    configureModuleValidationFailed(loadingKey, errorKey, validationErrors) {
      this.loading[loadingKey] = false;
      for (const validationError of validationErrors) {
        const param = validationError.parameter;
        this.error[param] = this.$t("settings." + validationError.error, {
          value: validationError.value,
        });
      }
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
      this.$emit("config-changed");
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
