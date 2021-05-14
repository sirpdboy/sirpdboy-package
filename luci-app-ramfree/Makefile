# Copyright (C) 2020-2021 sirpdboy <herboy2008@gmail.com>
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-ramfree

PKG_VERSION:=1.0
PKG_RELEASE:=4

include $(INCLUDE_DIR)/package.mk
define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  LUCI_TITLE:=Add Release ramfree Button
  PKGARCH:=all
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
rm -f /tmp/luci-indexcache /tmp/luci-modulecache
endef
define Package/$(PKG_NAME)/install
	$(INSTALL_DIR)  $(1)/usr/lib/lua/luci
	$(CP) ./luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./file/ramfree.sh $(1)/usr/bin
endef

include $(TOPDIR)/feeds/luci/luci.mk
