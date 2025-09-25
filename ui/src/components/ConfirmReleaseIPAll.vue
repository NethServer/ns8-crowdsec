<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <NsModal
    size="default"
    :visible="isShown"
    :isLoading="isLoading"
    :primary-button-disabled="isLoading"
    @modal-hidden="$emit('hide')"
    @primary-click="$emit('confirm')"
  >
    <template slot="title">{{ $t("unban.release_all_ip") }}</template>
    <template slot="content">
      <div>{{ $t("unban.confirm_delete_all_bans_message") }}</div>
    </template>
    <template slot="secondary-button">{{ core.$t("common.cancel") }}</template>
    <template slot="primary-button">{{ $t("unban.delete") }}</template>
  </NsModal>
</template>

<script>
import { UtilService, IconService } from "@nethserver/ns8-ui-lib";
export default {
  name: "ConfirmReleaseIPAll",
  mixins: [UtilService, IconService],
  props: {
    isShown: Boolean,
    isLoading: Boolean,
    core: { type: Object },
  },
};

</script>
<style scoped lang="scss">	
@import "../styles/carbon-utils";
</style>
