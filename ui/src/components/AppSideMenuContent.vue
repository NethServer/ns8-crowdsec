<!--
  Copyright (C) 2022 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div class="app-side-menu-content">
    <div class="instance-name">
      <div v-if="instanceLabel">{{ instanceLabel }}</div>
      <div v-else-if="instanceName">{{ instanceName }}</div>
      <cv-skeleton-text
        v-else
        :width="instanceNameSkeletonWidth"
      ></cv-skeleton-text>
    </div>

    <cv-side-nav-items>
      <cv-side-nav-link
        @click="goToAppPage(instanceName, 'status')"
        :class="{ 'current-page': isLinkActive('status') }"
      >
        <template v-slot:nav-icon><Activity20 /></template>
        <span>{{ $t("status.title") }}</span>
      </cv-side-nav-link>
      <cv-side-nav-link
        @click="goToAppPage(instanceName, 'detections')"
        :class="{ 'current-page': isLinkActive('detections') }"
      >
        <template v-slot:nav-icon><Report20 /></template>
        <span>{{ $t("detections.title") }}</span>
      </cv-side-nav-link>
      <cv-side-nav-link
        @click="goToAppPage(instanceName, 'collections')"
        :class="{ 'current-page': isLinkActive('collections') }"
      >
        <template v-slot:nav-icon><Catalog20 /></template>
        <span>{{ $t("collections.title") }}</span>
      </cv-side-nav-link>
      <cv-side-nav-link
        @click="goToAppPage(instanceName, 'blocklists')"
        :class="{ 'current-page': isLinkActive('blocklists') }"
      >
        <template v-slot:nav-icon><FirewallClassic20 /></template>
        <span>{{ $t("blocklists.title") }}</span>
      </cv-side-nav-link>
      <cv-side-nav-link
        @click="goToAppPage(instanceName, 'insights')"
        :class="{ 'current-page': isLinkActive('insights') }"
      >
        <template v-slot:nav-icon><ConnectionTwoWay20 /></template>
        <span>{{ $t("insights.title") }}</span>
      </cv-side-nav-link>
      <cv-side-nav-link
        @click="goToAppPage(instanceName, 'settings')"
        :class="{ 'current-page': isLinkActive('settings') }"
      >
        <template v-slot:nav-icon><Settings20 /></template>
        <span>{{ $t("settings.title") }}</span>
      </cv-side-nav-link>
      <cv-side-nav-link
        @click="goToAppPage(instanceName, 'about')"
        :class="{ 'current-page': isLinkActive('about') }"
      >
        <template v-slot:nav-icon><Information20 /></template>
        <span>{{ $t("about.title") }}</span>
      </cv-side-nav-link>
    </cv-side-nav-items>
  </div>
</template>

<script>
import Settings20 from "@carbon/icons-vue/es/settings/20";
import Information20 from "@carbon/icons-vue/es/information/20";
import Activity20 from "@carbon/icons-vue/es/activity/20";
import Catalog20 from "@carbon/icons-vue/es/catalog/20";
import Report20 from "@carbon/icons-vue/es/report/20";
import FirewallClassic20 from "@carbon/icons-vue/es/firewall--classic/20";
import ConnectionTwoWay20 from "@carbon/icons-vue/es/connection--two-way/20";
import { mapState } from "vuex";
import { QueryParamService, UtilService } from "@nethserver/ns8-ui-lib";

export default {
  name: "AppSideMenuContent",
  components: {
    Settings20,
    Information20,
    Activity20,
    Catalog20,
    Report20,
    FirewallClassic20,
    ConnectionTwoWay20,
  },
  mixins: [QueryParamService, UtilService],
  data() {
    return {
      instanceNameSkeletonWidth: "70%",
    };
  },
  computed: {
    ...mapState(["instanceName", "instanceLabel", "core"]),
  },
  created() {
    // register to appNavigation event
    this.$root.$on("appNavigation", this.onAppNavigation);
  },
  beforeDestroy() {
    // remove event listener
    this.$root.$off("appNavigation");
  },
  methods: {
    isLinkActive(page) {
      return this.getPage() === page;
    },
    onAppNavigation() {
      // highlight current page in side menu
      this.$forceUpdate();
    },
  },
};
</script>

<style scoped lang="scss">
.instance-name span {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
