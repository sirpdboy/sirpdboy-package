# Copyright 2019 X-WRT <dev@x-wrt.com>
# Copyright 2022 sirpdboy  

include $(TOPDIR)/rules.mk

PKG_NAME:=netwizard
PKG_VERSION:=1.7
PKG_RELEASE:=26

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Chen Minqiang <ptpt52@gmail.com>

LUCI_TITLE:=LuCI Support for Wizard
LUCI_DEPENDS:=+luci-compat
LUCI_PKGARCH:=all

define Package/luci-app-$(PKG_NAME)/conffiles
/etc/config/$(PKG_NAME)
endef

include $(TOPDIR)/feeds/luci/luci.mk

define Package/luci-app-$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$$IPKG_INSTROOT" ]; then
  ( . /etc/uci-defaults/99-uci-$(PKG_NAME)-defaults )
  rm -f /etc/uci-defaults/99-uci-$(PKG_NAME)-defaults
  rm -rf /tmp/luci*
fi
exit 0
endef

# call BuildPackage - OpenWrt buildroot signature
