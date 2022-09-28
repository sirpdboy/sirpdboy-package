#
# Copyright (C) 2006-2016 OpenWrt.org
# Copyright (C) 2016 lede-project.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=cups-opfilter
PKG_REALNAME:=cups-filters
PKG_VERSION:=1.27.2
PKG_VERSION_D:=1-27-2
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_REALNAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/OpenPrinting/cups-filters/releases/download/release-$(PKG_VERSION_D)/
PKG_MD5SUM:=90ebcae31f2eabd802236408646b1dd9
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_REALNAME)-$(PKG_VERSION)
TARGET_LDFLAGS+=-Wl,-rpath-link=$(STAGING_DIR)/usr/lib

include $(INCLUDE_DIR)/package.mk

define Package/cups-opfilter
  URL:=https://github.com/OpenPrinting/cups-filters
  SUBMENU:=Printing
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+cups +libcups +libcupsimage +libstdcpp +libtiff +libpng +libjpeg +glib2 +libfreetype +fontconfig
  TITLE:=Common UNIX Printing System - OpenPrinting Image Filters
endef

define Package/cups-opfilter/description
	Common UNIX Printing System - OpenPrinting Image Filters
	Filters used to convert jpeg, png or tiff images to raster files
endef

define Build/Configure
	$(call Build/Configure/Default, \
		--disable-avahi \
		--disable-ghostscript \
		--disable-nls \
		--disable-avahi \
		--disable-ldap \
		--disable-largefile \
		--disable-mutool \
		--disable-ghostscript \
		--disable-gs-ps2write \
		--disable-foomatic \
		--disable-lcms \
		--disable-poppler \
		--disable-dbus \
		--enable-imagefilters \
		--prefix=$(PKG_INSTALL_DIR) \
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
endef

define Package/cups-opfilter/install
	$(INSTALL_DIR) $(1)/usr/lib/cups/driver
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/.libs/driverless $(1)/usr/lib/cups/driver
	$(INSTALL_DIR) $(1)/usr/lib/cups/backend
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/{beh,cups-brf,parallel,serial} $(1)/usr/lib/cups/backend
	ln -s /usr/lib/cups/driver/driverless $(1)/usr/lib/cups/backend/driverless
	$(INSTALL_DIR) $(1)/usr/lib/cups/filter
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/.libs/imagetoraster $(1)/usr/lib/cups/filter
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/.libs/cups-browsed $(1)/usr/bin
	ln -s /usr/lib/cups/driver/driverless $(1)/usr/bin/driverless
	$(INSTALL_DIR) $(1)/usr/lib/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/.libs/libcupsfilters.so* $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/share/cups/drv
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/drv/*.drv $(1)/usr/share/cups/drv
	$(INSTALL_DIR) $(1)/usr/share/cups/mime
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/mime/* $(1)/usr/share/cups/mime
	$(INSTALL_DIR) $(1)/etc/cups
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/utils/cups-browsed.conf $(1)/etc/cups
endef

$(eval $(call BuildPackage,cups-opfilter))

