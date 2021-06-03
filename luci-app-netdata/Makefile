# Copyright (C) 2016 Openwrt.org
# Copyright (C) 2020-2021 sirpdboy <herboy2008@gmail.com>
# https://github.com/sirpdboy/luci-app-netdata
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-netdata
PKG_VERSION:=1.1
PKG_RELEASE:=20210603
PKG_MAINTAINER:=sirpdboy

include $(INCLUDE_DIR)/package.mk
define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI support for Netdata
	DEPENDS:=+netdata
	DESCRIPTION:=LuCI support Network speed test intranet and Extranet
	PKGARCH:=all
endef
define Build/Compile
endef


define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pR ./luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/usr/share/netdata/web
	cp -pR ./web $(1)/usr/share/netdata/web
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

