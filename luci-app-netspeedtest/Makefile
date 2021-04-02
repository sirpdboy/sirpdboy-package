#
# Copyright (C) 2020-2021 sirpdboy <herboy2008@gmail.com>
# The LuCI Network diagnosis and speed test <https://github.com/sirpdboy/NetSpeedTest>
# This is free software, licensed under the GNU General Public License v3.
# 

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-netspeedtest
PKG_VERSION:=1.6
PKG_RELEASE:=20210402
PKG_MAINTAINER:=sirpdboy <herboy2008@gmail.com>
PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

RSTRIP:=true

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

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	( . /etc/uci-defaults/40_luci-app-netspeedtest ) && rm -f /etc/uci-defaults/40_luci-app-netspeedtest
	rm -f /tmp/luci-indexcache
fi
exit 0
endef



define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pR ./luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/
	cp -pR ./root/* $(1)/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo ./po/zh-cn/netspeedtest.po $(1)/usr/lib/lua/luci/i18n/netspeedtest.zh-cn.lmo

	$(INSTALL_DIR)	$(1)/usr/bin/
	

ifeq ($(ARCH),x86)
	$(INSTALL_BIN) ./files/speedtest $(1)/usr/bin/
endif
ifeq ($(ARCH),x86_64)
	$(INSTALL_BIN) ./files/speedtest $(1)/usr/bin/
endif
endef

$(eval $(call BuildPackage,luci-app-koolproxyR))
