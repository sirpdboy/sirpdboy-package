#
# Copyright (C) 2024
#

include $(TOPDIR)/rules.mk

PKG_NAME:=vusb
PKG_RELEASE:=1
PKG_MAINTAINER:=bauw
PKG_LICENSE:=BSD-2-Clause
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/vusb
  SECTION:=net
  CATEGORY:=Network
  TITLE:=VirtualHere USB Service for LuCI
  DEPENDS:=@(x86_64||arm||arm64||mipsel||aarch64)
endef

define Package/vusb/description
    This package contains LuCI configuration pages for VirtualHere USB Service.
endef

define Build/Prepare
endef

define Build/Compile
endef

ifeq ($(ARCH),x86_64)
	EXE_FILE:=vhusbdx86
endif
ifeq ($(ARCH),arm)
	EXE_FILE:=vhusbdarm
endif
ifeq ($(ARCH),arm64)
	EXE_FILE:=vhusbdarm64
endif
ifeq ($(ARCH),mipsel)
	EXE_FILE:=vhusbdmipsel
endif
ifeq ($(ARCH),aarch64)
	EXE_FILE:=vhusbdarm64
endif

define Package/vusb/install
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_CONF) $(CURDIR)/files/vusb.conf $(1)/etc/config/vusb
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) $(CURDIR)/files/vusb.init $(1)/etc/init.d/vusb

	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(CURDIR)/files/$(EXE_FILE) $(1)/usr/bin/vusb
endef

$(eval $(call BuildPackage,vusb))
