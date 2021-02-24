include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI Support for docker
LUCI_DEPENDS:=@(aarch64||arm||x86_64) \
	+luci-compat \
	+luci-lib-docker \
	+docker-ce \
	+ttyd \
	+fdisk
LUCI_PKGARCH:=all

PKG_LICENSE:=AGPL-3.0
PKG_MAINTAINER:=lisaac <https://github.com/lisaac/luci-app-dockerman> \
		Florian Eckert <fe@dev.tdt.de>

PKG_VERSION:=v0.5.13
PKG_RELEASE:=leanmod

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
