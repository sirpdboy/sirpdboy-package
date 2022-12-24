#
# Copyright (C) 2021 ZeakyX
#

include $(TOPDIR)/rules.mk

PKG_NAME:=speedtest-web
PKG_VERSION:=1.1.5
PKG_RELEASE:=$(AUTORELESE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/ZeaKyX/speedtest-go.git
PKG_SOURCE_VERSION:=d8ccc31d3ae0ed2833691e3b8fc6fd1795d1ec13
PKG_MIRROR_HASH:=skip

PKG_LICENSE:=LGPL-3.0
PKG_LICENSE_FILES:=LICENSE


PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/librespeed/speedtest
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:=main.VersionString=v$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/speedtest-web
  SECTION:=net
  CATEGORY:=Network
  TITLE:=speedtest-web is a Openwrt package for speedtest-go, a Go backend for LibreSpeed
  URL:=https://github.com/librespeed/speedtest-go
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/speedtest-web/description
	speedtest-web is a Openwrt package for speedtest-go, a Go backend for LibreSpeed
endef


endef


$(eval $(call GoBinPackage,speedtest-web))
$(eval $(call BuildPackage,speedtest-web))
