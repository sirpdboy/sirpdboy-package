# Copyright (C) 2019-2021  sirpdboy  https://github.com/sirpdboy/luci-app-autotimeset
# 
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for Scheduled Time setting
LUCI_DEPENDS:=+luci
LUCI_PKGARCH:=all
PKG_NAME:=luci-app-autotimeset
PKG_VERSION:=1.4
PKG_RELEASE:=5

PKG_MAINTAINER:=sirpdboy  https://github.com/sirpdboy/luci-app-autotimeset

define Package/luci-app-eqos/conffiles
/etc/config/autotimeset
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

