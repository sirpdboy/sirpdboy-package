#
# Copyright (C) 2020 tencentcloud <https://github.com/Tencent-Cloud-Plugins>
#
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-tencentddns
PKG_VERSION:=0.1.0
PKG_RELEASE:=3

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=tencentcloud <https://github.com/Tencent-Cloud-Plugins>

LUCI_TITLE:=LuCI Support for tencentddns
LUCI_DESCRIPTION:=LuCI Support for TencentDDNS
LUCI_DEPENDS:=+bash +curl +openssl-util
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
