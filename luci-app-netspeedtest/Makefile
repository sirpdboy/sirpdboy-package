#
# Copyright (C) 2020-2021 sirpdboy <herboy2008@gmail.com>
# The LuCI Network diagnosis and speed test <https://github.com/sirpdboy/NetSpeedTest>
# This is free software, licensed under the GNU General Public License v3.
# 

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-netspeedtest
PKG_VERSION:=1.6
PKG_RELEASE:=20210402
PKG_LICENSE:=GPLv2
PKG_MAINTAINER:=sirpdboy

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=LuCI
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI Support for netspeedtest
  DEPENDS:=+iperf3 +python3
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	Luci Support for netspeedtest.
endef

define Build/Prepare
endef

define Build/Configure
endef



define Package/$(PKG_NAME)/install

	$(INSTALL_DIR)	$(1)/usr/bin/
	
	$(INSTALL_BIN) ./files/speedtest $(1)/usr/bin/
endef

include $(TOPDIR)/feeds/luci/luci.mk

