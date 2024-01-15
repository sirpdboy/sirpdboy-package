#
# Copyright (C) 2016-2020 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=webui-aria2
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2021-09-01
PKG_SOURCE_URL:=https://github.com/ziahamza/webui-aria2.git
PKG_SOURCE_VERSION:=109903f0e2774cf948698cd95a01f77f33d7dd2c
PKG_MIRROR_HASH:=skip

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Hsing-Wang Liao <kuoruan@gmail.com>

include $(INCLUDE_DIR)/package.mk

define Package/webui-aria2
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Download Manager
  TITLE:=An interface to interact with aria2
  URL:=https://github.com/ziahamza/webui-aria2
  DEPENDS:=+aria2
  PKGARCH:=all
endef

define Package/webui-aria2/description
  The aim for this project is to create the worlds best and hottest
  interface to interact with aria2. Very simple to use.
endef

define Build/Compile
endef

define Package/webui-aria2/install
	$(INSTALL_DIR) $(1)/www/webui-aria2
	$(CP) \
		$(PKG_BUILD_DIR)/docs/* \
		$(PKG_BUILD_DIR)/{LICENSE,favicon.ico} \
		$(1)/www/webui-aria2
endef

$(eval $(call BuildPackage,webui-aria2))
