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


STRIP:=true


include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=speedtest
  TITLE:=A Speedtest application
  DEPENDS:=+kmod-tun +wget +curl +python3
endef


define Package/$(PKG_NAME)/description
  A Speedtest application
  ookla speedtest by sirpdboy
endef
define Download/speedtest
  URL:=https://ookla.bintray.com/download
  URL_FILE:=ookla-$(PKG_NAME)-$(PKG_VERSION)-$(PKG_ARCH)-linux.tgz
  FILE:=speedtest
  HASH:=skip
endef


define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(DL_DIR)/speedtest $(1)/usr/bin
endef



$(eval $(call Download,speedtest))
$(eval $(call BuildPackage,$(PKG_NAME)))
