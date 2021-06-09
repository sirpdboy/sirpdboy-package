# Copyright (C) 2016 Openwrt.org
# Copyright (C) 2020-2021 sirpdboy <herboy2008@gmail.com>
# https://github.com/sirpdboy/luci-app-netdata for  v 1.30.1 cn
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for Netdata
LUCI_DEPENDS:=+netdata
LUCI_PKGARCH:=all
PKG_VERSION:=1.0
PKG_RELEASE:=6

define Build/Compile
endef

define Package/luci-app-netdata/postinst
#!/bin/sh
[ -f /usr/share/netdata/webcn/dashboard.js ] && mv -f /usr/share/netdata/webcn/dashboard.js /usr/share/netdata/web/dashboard.js
[ -f /usr/share/netdata/webcn/dashboard_info.js ] && mv -f /usr/share/netdata/webcn/dashboard_info.js /usr/share/netdata/web/dashboard_info.js
[ -f /usr/share/netdata/webcn/main.js ] && mv -f /usr/share/netdata/webcn/dashboard.js /usr/share/netdata/web/main.js
[ -f /usr/share/netdata/webcn/index.html ] && mv -f /usr/share/netdata/webcn/index.html /usr/share/netdata/web/index.html
rm -Rf /var/luci-modulecache
rm -Rf /var/luci-indexcache
exit 0
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

