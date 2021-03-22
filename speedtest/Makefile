#
# Copyright (C) 2020-2021 sirpdboy <herboy2008@gmail.com>
# The LuCI Network diagnosis and speed test <https://github.com/sirpdboy/NetSpeedTest>
# Use the speed measurement program provided by ookla. 
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=speedtest
PKG_VERSION:=1.0.0
PKG_RELEASE:=3


PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=ookla speedtest by sirpdboy

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  CATEGORY:=ookla speedtest by sirpdboy
  SUBMENU:=1. Performance
  TITLE:=A Speedtest application
  DEPENDS:=+kmod-tun +wget +curl
endef

define Package/$(PKG_NAME)/description
Command line interface for testing internet bandwidth using ookla
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(CURDIR)/file/$(PKG_NAME) $(1)/usr/bin
	$(CP) -r ./files/$(PKG_NAME)  $(1)/usr/bin/$(PKG_NAME)
endef

define Package/$(PKG_NAME)/postinst
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
