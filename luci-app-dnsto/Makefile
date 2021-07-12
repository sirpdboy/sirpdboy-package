# Copyright (C) 2017 XiaoShan https://www.mivm.cn

include $(TOPDIR)/rules.mk

PKG_ARCH_DDNSTO:=$(ARCH)
PKG_NAME:=luci-app-dnsto
PKG_VERSION:=1.0.0
PKG_RELEASE:=20210713

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=XiaoShan

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI Support for ddnsto
	PKGARCH:=all
	DEPENDS:=
endef

define Package/$(PKG_NAME)/description
	LuCI Support for dnsto.
endef

define Build/Prepare
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/ddnsto
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
rm -f /tmp/luci-*
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pR ./luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./root/etc/init.d/* $(1)/etc/init.d/
	
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./root/etc/uci-defaults/* $(1)/etc/uci-defaults/
	
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./root/etc/config/* $(1)/etc/config/ddnsto
	$(INSTALL_DIR)	$(1)/usr/bin/
	$(INSTALL_BIN) ./files/ddnsto.$(PKG_ARCH_DDNSTO) $(1)/usr/bin/ddnsto
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
