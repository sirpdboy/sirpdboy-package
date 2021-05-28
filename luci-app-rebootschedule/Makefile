include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-rebootschedule
PKG_VERSION:=1.0
PKG_RELEASE:=20210522

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI support for rebootschedule
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	LuCI support for rebootschedule  
endef

define Build/Compile
endef


define Package/$(PKG_NAME)/postinst
#!/bin/sh
rm -f /tmp/luci-indexcache /tmp/luci-modulecache
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/rebootschedule
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/init.d $(1)/etc/config $(1)/usr/lib/lua/luci
	$(CP) ./luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_CONF) ./root/etc/config/* $(1)/etc/config
	$(INSTALL_BIN) ./root/etc/init.d/* $(1)/etc/init.d
	$(INSTALL_BIN) ./file/* $(1)/usr/bin

endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

