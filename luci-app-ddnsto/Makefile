# Copyright (C) 2017 XiaoShan https://www.mivm.cn

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-ddnsto
PKG_VERSION:=1.0.0
PKG_RELEASE:=20210403

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
endef

define Package/$(PKG_NAME)/description
	LuCI Support for ddnsto.
endef

define Build/Prepare
	$(foreach po,$(wildcard ${CURDIR}/po/zh-cn/*.po), \
	 po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/ddnsto
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/postinst
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pR ./luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/
	cp -pR ./root/* $(1)/
	$(INSTALL_DIR)	$(1)/usr/bin/
	$(INSTALL_BIN) ./files/x86/ddnsto $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/ddnsto.*.lmo $(1)/usr/lib/lua/luci/i18n/
endef

include $(TOPDIR)/feeds/luci/luci.mk
