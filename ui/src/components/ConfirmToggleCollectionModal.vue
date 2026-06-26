<!--
  Copyright (C) 2026 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <NsModal
    size="default"
    :visible="isShown"
    :primaryButtonDisabled="isLoading"
    @modal-hidden="$emit('hide')"
    @primary-click="$emit('confirm')"
  >
    <template slot="title">
      {{
        action === "install"
          ? $t("collections.confirm_enable_title")
          : $t("collections.confirm_disable_title")
      }}
    </template>
    <template slot="content">
      <div>
        {{
          action === "install"
            ? $t("collections.confirm_enable_message", { name: collection.name })
            : $t("collections.confirm_disable_message", { name: collection.name })
        }}
      </div>
    </template>
    <template slot="secondary-button">{{ core.$t("common.cancel") }}</template>
    <template slot="primary-button">
      {{
        action === "install"
          ? $t("collections.enable_collection")
          : $t("collections.disable_collection")
      }}
    </template>
  </NsModal>
</template>

<script>
import { UtilService, IconService } from "@nethserver/ns8-ui-lib";
export default {
  name: "ConfirmToggleCollectionModal",
  mixins: [UtilService, IconService],
  props: {
    isShown: Boolean,
    collection: { type: Object },
    action: { type: String },
    core: { type: Object },
    isLoading: {
      type: Boolean,
      default: false,
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";
</style>
