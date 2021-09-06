include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-zerotier
PKG_VERSION:=1.0
PKG_RELEASE:=1
PKG_MAINTAINER:=Small_5

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=LuCI
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI for Zerotier
  DEPENDS:=+zerotier +luci-compat
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	LuCI for Zerotier.
endef

define Build/Prepare
	chmod -R 755 luasrc/* root/*
	find luasrc -type f -exec chmod 644 {} \;
	find root -type f -exec chmod 644 {} \;
	chmod 755 root/etc/init.d/* root/usr/share/zerotier/*
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	cp -pr luasrc/* $(1)/usr/lib/lua/luci
	cp -pr root/* $(1)/
	po2lmo po/zh-cn/zerotier.po $(1)/usr/lib/lua/luci/i18n/zerotier.zh-cn.lmo
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
