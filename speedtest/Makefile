#
# Copyright (C) 2020-2021 sirpdboy <herboy2008@gmail.com>
# The LuCI Network diagnosis and speed test <https://github.com/sirpdboy/NetSpeedTest>
# Use the speed measurement program provided by ookla. 
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_ARCH:=x86_64
PKG_NAME:=speedtest
PKG_VERSION:=1.0.0
PKG_RELEASE:=5

PKG_SOURCE_URL:=https://ookla.bintray.com/download
PKG_SOURCE:=ookla-$(PKG_NAME)-$(PKG_VERSION)-$(PKG_ARCH)-linux.tgz
PKG_HASH:=skip
PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE

PKG_MAINTAINER:=sirpdboy <herboy2008@gmail.com>

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=net
  CATEGORY:=Network
  TITLE:=A Speedtest application 
  DEPENDS:=+kmod-tun +wget +curl +python3
  URL:=https://github.com/sirpdboy/NetSpeedTest
endef

# define Download/speedtest
#  URL:=https://ookla.bintray.com/download
#  URL_FILE:=ookla-$(PKG_NAME)-$(PKG_VERSION)-$(PKG_ARCH)-linux.tgz
#   FILE:=tmpspeedtest
#   HASH:=skip
# endef

define Package/$(PKG_NAME)/description
  luci for testing internet bandwidth using speedtest.net
  ookla speedtest by sirpdboy
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/$(PKG_NAME)
	$(CP) ./file/speedtest $(PKG_BUILD_DIR)/$(PKG_NAME)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME)/speedtest  $(1)/usr/bin

endef

define Package/$(PKG_NAME)/postinst
endef
$(eval $(call BuildPackage,$(PKG_NAME)))
