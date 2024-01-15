include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-aria2

PKG_VERSION:=1.0.1
PKG_RELEASE:=3

PKG_LICENSE:=Apache-2.0
PKG_MAINTAINER:=Hsing-Wang Liao <kuoruan@gmail.com>
LUCI_TITLE:=LuCI Support for Aria2
LUCI_DEPENDS:=+aria2 +ariang
LUCI_PKGARCH:=all

define Package/$(PKG_NAME)/config
help
		$(LUCI_TITLE)
		.
		Version: $(PKG_VERSION)-$(PKG_RELEASE)
		$(PKG_MAINTAINER)
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
