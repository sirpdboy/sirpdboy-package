# luci-app-wrtbwmon

[![CI](https://github.com/brvphoenix/luci-app-wrtbwmon/workflows/CI/badge.svg)](https://github.com/brvphoenix/luci-app-wrtbwmon/actions)
[![GitHub All Releases](https://img.shields.io/github/downloads/brvphoenix/luci-app-wrtbwmon/total)](https://github.com/brvphoenix/luci-app-wrtbwmon/releases)
[![Lastest Release](https://img.shields.io/github/release/brvphoenix/luci-app-wrtbwmon.svg?style=flat)](https://github.com/brvphoenix/luci-app-wrtbwmon/releases)

This repo provides yet another LuCI module for wrtbwmon, which has similar features with [Kiougar's one](https://github.com/Kiougar/luci-wrtbwmon). The differnence is that this one has more features supported:
1. Support IPV6.
1. Identify a host by the unique MAC rather than its IP.
1. Use the progress bar to display the total bandwidth.
1. For brevity, some columns are hidden by default.
1. Convert to client side for rendering just as what the new openwrt release has done.

#### Attention:
The [pyrovski's wrtbwmon](https://github.com/pyrovski/wrtbwmon) is **incompatible** with this LuCI app. **You must download the compatible one from [here](https://github.com/brvphoenix/wrtbwmon)**.

## Screenshots
![Screenshots](https://github.com/brvphoenix/luci-app-wrtbwmon/blob/master/screenshot.png?raw=true)

## Downloading
Openwrt 19.07 has been fully supported after commit: [ff4909d](https://github.com/brvphoenix/luci-app-wrtbwmon/tree/ff4909d8f5d06fee87f7ec5a365ac5dde6492130).

* `openwrt-19.07`: [release-2.0.7](https://github.com/brvphoenix/luci-app-wrtbwmon/releases/download/release-2.0.7/luci-app-wrtbwmon_2.0.7-1_all.ipk)
* `openwrt-18.06`: [release-1.6.3](https://github.com/brvphoenix/luci-app-wrtbwmon/releases/download/release-1.6.3/luci-app-wrtbwmon_1.6.3-1_all.ipk)

After installing, you will see a new `Traffic status` menu item  in the `Network` menu list in the LuCI Page.

## Information
In principle, the lua version (based on the old openwrt 18.06) has been dropped support since [ff4909d](https://github.com/brvphoenix/luci-app-wrtbwmon/tree/ff4909d8f5d06fee87f7ec5a365ac5dde6492130), and the new features will not backport to the old lua version. However, it is welcomed if someone can implement it and make a pr.

If anyone would like to help translate this luci app, just upload the translation files or make a pr.

## Credits
Thanks to
* [Kiougar](https://github.com/Kiougar/luci-wrtbwmon) for the original codes.
* [pyrovski](https://github.com/pyrovski) for creating `wrtbwmon`.
