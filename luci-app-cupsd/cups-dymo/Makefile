#
# Copyright (C) 2006-2016 OpenWrt.org
# Copyright (C) 2016 lede-project.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=cups-dymo
PKG_VERSION:=1.4.0
PKG_VERSION_RC:=1.4.0.5
PKG_RELEASE:=1

PKG_SOURCE:=dymo-cups-drivers-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://download.dymo.com/dymo/Software/Download%20Drivers/Linux/Download/
PKG_MD5SUM:=8774f98bbe8d57f5b337019ae86a23f0
PKG_BUILD_DIR:=$(BUILD_DIR)/dymo-cups-drivers-$(PKG_VERSION_RC)
TARGET_LDFLAGS+=-Wl,-rpath-link=$(STAGING_DIR)/usr/lib

include $(INCLUDE_DIR)/package.mk

define Package/cups-dymo
  URL:=https://www.dymo.com/de-DE/dymo-label-sdk-cups-linux-p
  SUBMENU:=Printing
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+libcups +libcupsimage +libstdcpp 
  TITLE:=Common UNIX Printing System - Dymo Label Printer Driver
endef

define Package/cups-dymo/description
	Common UNIX Printing System - Dymo Label Printer Driver
endef

define Build/Configure
	$(call Build/Configure/Default, \
		UNAME="Linux" \
		LIBS="$(TARGET_LDFLAGS)" \
	)
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS) \
		DSTROOT="$(PKG_INSTALL_DIR)" \
		STRIP="/bin/true" \
		all
	#install ignores DSTROOT/prefix and I am too lazy to look for the correct syntax
endef

define Package/cups-dymo/install
	$(INSTALL_DIR) $(1)/usr/lib/cups/filter
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/lm/raster2dymolm $(1)/usr/lib/cups/filter
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/lw/raster2dymolw $(1)/usr/lib/cups/filter
	$(INSTALL_DIR) $(1)/usr/share/cups/model/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/ppd/*.ppd $(1)/usr/share/cups/model
endef

$(eval $(call BuildPackage,cups-dymo))
