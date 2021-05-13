# Copyright (C) 2018 Lienol
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-ramfree
LUCI_TITLE:=Add Release RAM Button
LUCI_PKGARCH:=all
PKG_VERSION:=1.0
PKG_RELEASE:=3

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/share/ramfree
	$(INSTALL_BIN) ./file/* $(1)/usr/share/ramfree
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature


