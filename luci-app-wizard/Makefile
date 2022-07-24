#
#  Copyright 2019 X-WRT <dev@x-wrt.com>
#  Copyright 2022 sirpdboy

# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-wizard
PKG_VERSION:=1.4
PKG_RELEASE:=15

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Chen Minqiang <ptpt52@gmail.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-wizard
	CATEGORY:=X
	SUBMENU:=Configuration Wizard Support
	TITLE:=LuCI Support for wizard
	PKGARCH:=all
	DEPENDS:=
endef

define Package/luci-app-wizard/description
	LuCI Support for wizard.
endef

define Build/Prepare
	$(foreach po,$(wildcard ${CURDIR}/files/luci/i18n/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-wizard/conffiles
/etc/config/wizard
endef

define Package/luci-app-wizard/postinst
#!/bin/sh
if [ -z "$$IPKG_INSTROOT" ]; then
  ( . /etc/uci-defaults/40_luci-app-wizard )
  rm -f /etc/uci-defaults/40_luci-app-wizard
  ( . /etc/uci-defaults/99-uci-defaults )
  rm -f /etc/uci-defaults/99-uci-defaults
  rm -rf /tmp/luci-indexcache /tmp/luci-modulecache
fi
exit 0
endef
define Package/luci-app-wizard/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/wizard.*.lmo $(1)/usr/lib/lua/luci/i18n/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/luci/controller/wizard.lua $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/wizard
	$(INSTALL_DATA) ./files/luci/model/cbi/wizard/*.lua $(1)/usr/lib/lua/luci/model/cbi/wizard/
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/root/etc/config/wizard $(1)/etc/config/wizard
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/root/etc/init.d/wizard $(1)/etc/init.d/wizard
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DATA) ./files/root/etc/uci-defaults/40_luci-app-wizard $(1)/etc/uci-defaults/40_luci-app-wizard
	$(INSTALL_DATA) ./files/uci.defaults $(1)/etc/uci-defaults/99-uci-defaults
endef

$(eval $(call BuildPackage,luci-app-wizard))
