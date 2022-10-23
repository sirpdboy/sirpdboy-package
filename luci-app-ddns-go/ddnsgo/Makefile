# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2021-2022  sirpdboy  <herboy2008@gmail.com> https://github.com/sirpdboy/luci-app-ddnsgo 
# 
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ddnsgo
PKG_VERSION:=4.2.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/jeessy2/ddns-go.git
PKG_SOURCE_VERSION:=40910a944dda1f4d843e77531bd32c630671954a
PKG_MIRROR_HASH:=0c74d4b843bebac9d10adba420a466fbb09f92e45e77caf293a8e5ede62b6c50

PKG_LICENSE:=AGPL-3.0-only
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=herboy2008 <herboy2008@gmail.com>

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/jeessy2/ddns-go/v4
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:=m.version=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/ddnsgo
  TITLE:=A Linux web GUI client of ddns-go
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  DEPENDS:=$(GO_ARCH_DEPENDS) +ca-bundle 
  URL:=https://github.com/jeessy2/ddns-go
endef

define Package/ddnsgo/description
  ddns-go is a automatically obtain your public IPv4 or IPv6 address and resolve it to the corresponding domain name service,
  support Alidns Dnspod Cloudflare Hicloud Callback Baiducloud porkbun GoDaddy Google Domains.
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	[ -f /etc/uci-defaults/luci-ddns-go ] && /etc/uci-defaults/luci-ddns-go && rm -f /etc/uci-defaults/luci-ddns-go
fi
endef

define Package/ddnsgo/install
	$(call GoPackage/Package/Install/Bin,$(1))

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./file/ddnsgo.init $(1)/etc/init.d/ddnsgo

	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./file/luci-ddns-go.uci-default $(1)/etc/uci-defaults/luci-ddns-go
endef

$(eval $(call GoBinPackage,ddnsgo))
$(eval $(call BuildPackage,ddnsgo))
