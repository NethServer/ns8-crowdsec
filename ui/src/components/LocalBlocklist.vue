<!--
  Copyright (C) 2026 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <p class="mg-bottom">{{ $t("local_blocklist.description") }}</p>
    <cv-tile light>
      <cv-text-area
        :label="$t('local_blocklist.entries')"
        v-model="entries"
        :invalid-message="error.entries"
        :helper-text="$t('local_blocklist.entries_helper')"
        class="maxwidth"
        ref="entries"
        :rows="6"
        :placeholder="$t('local_blocklist.entries_placeholder')"
        :disabled="loadingConfig || loading.save"
      >
      </cv-text-area>
      <NsInlineNotification
        v-if="error.save"
        kind="error"
        :title="$t('error_title.set-local-blocklist')"
        :description="error.save"
        :showCloseButton="false"
        class="mg-top maxwidth"
      />
      <NsButton
        kind="primary"
        :icon="Save20"
        class="mg-top"
        :loading="loading.save"
        :disabled="loadingConfig || loading.save"
        @click="save"
        >{{ $t("settings.save") }}</NsButton
      >
    </cv-tile>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { UtilService, IconService, TaskService } from "@nethserver/ns8-ui-lib";
import to from "await-to-js";
import { isValidIpAddress } from "@/lib/ip";

export default {
  name: "LocalBlocklist",
  mixins: [UtilService, IconService, TaskService],
  props: {
    // get-configuration output, loaded by the page; null until then
    config: { type: Object, default: null },
    loadingConfig: Boolean,
  },
  data() {
    return {
      entries: "",
      loading: { save: false },
      error: { save: "", entries: "" },
    };
  },
  computed: {
    ...mapState(["instanceName", "core"]),
  },
  watch: {
    config: {
      immediate: true,
      handler(config) {
        if (config) this.entries = (config.local_blocklist || []).join("\n");
      },
    },
  },
  methods: {
    async save() {
      this.error.save = "";
      this.error.entries = "";
      const lines = this.entries
        .split("\n")
        .map((line) => line.trim())
        .filter(Boolean);
      const bad = lines.find((line) => !isValidIpAddress(line));
      if (bad) {
        this.error.entries = this.$t("local_blocklist.not_valid", {
          value: bad,
        });
        this.focusElement("entries");
        return;
      }
      this.loading.save = true;
      const taskAction = "set-local-blocklist";
      const eventId = this.getUuid();
      this.core.$root.$once(`${taskAction}-aborted-${eventId}`, (r, ctx) => {
        console.error(`${ctx.action} aborted`, r);
        this.error.save = this.$t("error.generic_error");
        this.loading.save = false;
      });
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        (validationErrors) => {
          for (const e of validationErrors) {
            this.error.entries = this.$t(`local_blocklist.${e.error}`, {
              value: e.value,
            });
          }
          this.loading.save = false;
        }
      );
      this.core.$root.$once(`${taskAction}-completed-${eventId}`, () => {
        this.loading.save = false;
        this.$emit("config-changed");
      });
      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: { local_blocklist: lines },
          extra: {
            title: this.$t("action." + taskAction),
            description: this.$t("settings.processing"),
            eventId,
          },
        })
      );
      if (res[0]) {
        console.error(`error creating task ${taskAction}`, res[0]);
        this.error.save = this.getErrorMessage(res[0]);
        this.loading.save = false;
      }
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

.maxwidth {
  max-width: 38rem;
}

.mg-top {
  margin-top: $spacing-05;
}

.mg-bottom {
  margin-bottom: $spacing-06;
}
</style>
