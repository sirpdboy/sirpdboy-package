#
# Copyright (C) 2015-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=speedtest-openwrt
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=eSir Playground

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  CATEGORY:=eSir Playground
  SUBMENU:=1. Performance
  TITLE:=A Speedtest application
  URL:=https://github.com/esirplayground/Speedtest-openwrt
  DEPENDS:=+python
endef

define Package/$(PKG_NAME)/description
Command line interface for testing internet bandwidth using speedtest.net
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/$(PKG_NAME)
	$(CP) ./file/speedtest $(PKG_BUILD_DIR)/$(PKG_NAME)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME)/speedtest $(1)/usr/bin
endef

define Package/$(PKG_NAME)/postinst
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
