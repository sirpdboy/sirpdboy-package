#
# Copyright (C) 2020-2021 sirpdboy <herboy2008@gmail.com>
# The LuCI Network diagnosis and speed test <https://github.com/sirpdboy/NetSpeedTest>
# Use the speed measurement program provided by ookla. 
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=speedtest
PKG_VERSION:=1.0.0
PKG_RELEASE:=2


PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=ookla speedtest by sirpdboy

ifeq ($(ARCH),x86_64)
	PKG_ARCH:=x86_64
endif

PKG_FILE:=ookla-$(PKG_NAME)-$(PKG_VERSION)-$(PKG_ARCH)-linux.tgz
PKG_URL:=https://ookla.bintray.com/download/ookla-$(PKG_NAME)-$(PKG_VERSION)-$(PKG_ARCH)-linux.tgz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  CATEGORY:=ookla speedtest by sirpdboy
  SUBMENU:=1. Performance
  TITLE:=A Speedtest application
  URL:=https://ookla.bintray.com/download/
  DEPENDS:=+python +kmod-tun +wget +curl
endef

define Package/$(PKG_NAME)/description
Command line interface for testing internet bandwidth using speedtest.net
endef

define Build/Prepare
	if [ ! -f $(DL_DIR)/$(PKG_FILE) ] ; then \
		curl -f --connect-timeout 20 --retry 5 --location --insecure $(PKG_URL) -o $(DL_DIR)/$(PKG_FILE); \
	fi
	rm -r $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)
	tar -zxvf $(DL_DIR)/$(PKG_FILE) -C $(PKG_BUILD_DIR) --strip-components 1
	$(CP) ./file/speedtest $(PKG_BUILD_DIR)/$(PKG_NAME)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/usr/bin/$(PKG_NAME)
endef

define Package/$(PKG_NAME)/postinst
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
