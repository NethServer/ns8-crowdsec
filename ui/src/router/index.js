//
// Copyright (C) 2022 Nethesis S.r.l.
// SPDX-License-Identifier: GPL-3.0-or-later
//
import Vue from "vue";
import VueRouter from "vue-router";
import Status from "../views/Status.vue";
import Settings from "../views/Settings.vue";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "Status",
    component: Status,
    alias: "/status", // important
  },
  {
    path: "/settings",
    name: "Settings",
    component: Settings,
  },
  {
    path: "/activity",
    name: "Activity",
    component: () =>
      import(/* webpackChunkName: "activity" */ "../views/Activity.vue"),
  },
  // Renamed to Activity.
  { path: "/detections", redirect: "/activity" },
  // Its tabs are now in Threat Shield IP.
  { path: "/blocklists", redirect: "/threat-shield" },
  {
    path: "/threat-shield",
    name: "ThreatShield",
    component: () =>
      import(
        /* webpackChunkName: "threat-shield" */ "../views/ThreatShield.vue"
      ),
  },
  {
    path: "/about",
    name: "About",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () =>
      import(/* webpackChunkName: "about" */ "../views/About.vue"),
  },
];

const router = new VueRouter({
  base: process.env.BASE_URL,
  routes,
});

export default router;
