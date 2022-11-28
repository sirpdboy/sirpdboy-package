# Copyright 2019 X-WRT <dev@x-wrt.com>
# Copyright 2022 sirpdboy  

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-wizard
PKG_VERSION:=1.4
PKG_RELEASE:=16

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Chen Minqiang <ptpt52@gmail.com>

LUCI_TITLE:=LuCI Support for Wizard
LUCI_DEPENDS:=+luci-compat
LUCI_PKGARCH:=all

define Package/$(PKG_NAME)/conffiles
/etc/config/wizard
endef

include $(TOPDIR)/feeds/luci/luci.mk

define Package/luci-app-wizard/postinst
#!/bin/sh
if [ -z "$$IPKG_INSTROOT" ]; then
  ( . /etc/uci-defaults/40_luci-app-wizard )
  rm -f /etc/uci-defaults/40_luci-app-wizard
  ( . /etc/uci-defaults/99-uci-defaults )
  rm -f /etc/uci-defaults/99-uci-defaults

  rm -rf /tmp/luci-indexcache /tmp/luci-modulecache
fi
exit 0
endef

# call BuildPackage - OpenWrt buildroot signature
