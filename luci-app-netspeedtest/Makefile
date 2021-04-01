#
# Copyright (C) 2020-2021 sirpdboy <herboy2008@gmail.com>
# The LuCI Network diagnosis and speed test <https://github.com/sirpdboy/NetSpeedTest>
# This is free software, licensed under the GNU General Public License v3.
# 

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-netspeedtest
PKG_VERSION:=1.6
PKG_RELEASE:=20210401
PKG_LICENSE:=GPLv2
PKG_MAINTAINER:=sirpdboy

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

LUA_LIBRARYDIR = /usr/lib/lua
LUCI_LIBRARYDIR = $(LUA_LIBRARYDIR)/luci
define Package/$(PKG_NAME)
  SECTION:=LuCI
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI Support for netspeedtest
  DEPENDS:=+iperf3 +python3 +speedtest
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	Luci Support for netspeedtest.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./* $(PKG_BUILD_DIR)/
endef

define Build/Configure
endef



define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)$(LUCI_LIBRARYDIR)
	cp -pR $(PKG_BUILD_DIR)/luasrc/* $(1)$(LUCI_LIBRARYDIR)/

	$(INSTALL_DIR) $(1)/
	cp -pR ./root/* $(1)/
	$(INSTALL_DIR)	$(1)/usr/bin/
	
	$(INSTALL_BIN) ./files/speedtest $(1)/usr/bin/
endef

include $(TOPDIR)/feeds/luci/luci.mk

