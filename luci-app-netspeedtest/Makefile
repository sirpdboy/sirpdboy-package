#
# Copyright (C) 2020-2021 sirpdboy <herboy2008@gmail.com>
# The LuCI Network diagnosis and speed test <https://github.com/sirpdboy/NetSpeedTest>
# This is free software, licensed under the GNU General Public License v3.
# 

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-netspeedtest
PKG_VERSION:=1.6
PKG_RELEASE:=20210331
PKG_LICENSE:=GPLv2
PKG_MAINTAINER:=NetSpeedTest by sirpdboy <herboy2008@gmail.com>


include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=LuCI
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=luci-app-netspeedtest
  DEPENDS:=+iperf3 +python3
  DESCRIPTION:=LuCI support Network speed test intranet and Extranet
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	Luci Support for netspeedtest.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/$(PKG_NAME)
	cp -pR  ./root/usr/bin/$(PKG_NAME)/speedtest $(PKG_BUILD_DIR)/
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/netspeedtest
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME)/speedtest  $(1)/usr/bin
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

