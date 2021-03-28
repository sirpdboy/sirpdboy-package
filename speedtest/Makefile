#
# Copyright (C) 2020-2021 sirpdboy <herboy2008@gmail.com>
# The LuCI Network diagnosis and speed test <https://github.com/sirpdboy/NetSpeedTest>
# Use the speed measurement program provided by ookla. 
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_ARCH:=$(ARCH)
PKG_NAME:=speedtest
PKG_VERSION:=1.0.0
PKG_RELEASE:=3
PKG_SOURCE:=ookla-$(PKG_NAME)-$(PKG_VERSION)-$(PKG_ARCH)-linux.tgz
PKG_SOURCE_URL:=https://ookla.bintray.com/download/
PKG_HASH:=skip

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=ookla speedtest by sirpdboy

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=net
  CATEGORY:=Network
  TITLE:=A Speedtest application
  DEPENDS:=+kmod-tun +wget +curl +python3
endef

define Build/Configure
endef

define Build/Compile
	$(call GoPackage/Build/Compile)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/Speedtest || true
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/Speedtest $(1)/usr/bin/Speedtest
endef


$(eval $(call GoBinPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
