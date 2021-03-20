#
# Copyright (C) 2020-2021 sirpdboy <herboy2008@gmail.com>
# The LuCI Network diagnosis and speed test <https://github.com/sirpdboy/NetSpeedTest>
# This is free software, licensed under the GNU General Public License v3.
# 

include $(TOPDIR)/rules.mk

LUCI_TITLE:=luci-app-netspeedtest
LUCI_DESCRIPTION:=LuCI support Network speed test intranet and Extranet
LUCI_DEPENDS:=+iperf3 +speedtest
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-netspeedtest
PKG_VERSION:=1.4
PKG_RELEASE:=15


include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

