#
# Copyright (C) 2006-2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

	PKG_NAME:=luci-app-eqos
	PKG_VERSION:=1
	PKG_RELEASE:=3-20201105

	PKG_MAINTAINER:=Jianhui Zhao <jianhuizhao329@gmail.com>

include $(INCLUDE_DIR)/package.mk


define Package/luci-app-eqos
	SECTION:=luci
	CATEGORY:=LuCI
	TITLE:=Easy QoS(Support speed limit based on IP address)
	PKGARCH:=all
	DEPENDS:=+luci-base +tc +kmod-sched-core +kmod-ifb
	SUBMENU:=3. Applications
endef

define Package/luci-app-eqos/description
	Luci interface for the eqos.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-eqos/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pR ./luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/
	cp -pR ./root/* $(1)/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo ./po/zh-cn/eqos.po $(1)/usr/lib/lua/luci/i18n/eqos.zh-cn.lmo
endef

$(eval $(call BuildPackage,luci-app-eqos))
