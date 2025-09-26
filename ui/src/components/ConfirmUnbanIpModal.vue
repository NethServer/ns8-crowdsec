<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <NsModal
    size="default"
    :visible="isShown"
    @modal-hidden="$emit('hide')"
    @primary-click="$emit('confirm')"
  >
    <template slot="title"
      >{{ $t("unban.unban_ip") }}: {{ ban.value }}</template
    >
    <template slot="content">
      <div>{{ $t("unban.confirm_unban_ip_message") }}</div>
    </template>
    <template slot="secondary-button">{{ core.$t("common.cancel") }}</template>
    <template slot="primary-button">{{ $t('unban.delete') }}</template>
  </NsModal>
</template>

<script>
import { UtilService, IconService } from "@nethserver/ns8-ui-lib";
export default {
  name: "ConfirmUnbanIpModal",
  mixins: [UtilService, IconService],
  props: {
    isShown: Boolean,
    ban: { type: [Object, null] },
    core: { type: Object },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";
</style>
