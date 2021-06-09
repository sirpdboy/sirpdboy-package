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

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pR ./luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/
	cp -pR ./root/* $(1)/
endef

define Package/$(PKG_NAME)/postinst
	rm $(1)/usr/share/netdata/web/dashboard.js
	rm $(1)/usr/share/netdata/web/dashboard_info.js
	rm $(1)/usr/share/netdata/web/index.html
	rm $(1)/usr/share/netdata/web/main.js
	$(CP) ./files/web $(1)/usr/share/netdata/web
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

