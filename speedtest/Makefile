#
# Copyright (C) 2020-2021 sirpdboy <herboy2008@gmail.com>
# The LuCI Network diagnosis and speed test <https://github.com/sirpdboy/NetSpeedTest>
# Use the speed measurement program provided by ookla. 
# This is free software, licensed under the GNU General Public License v3.
#


include $(TOPDIR)/rules.mk

PKG_NAME:=speedtest
PKG_VERSION:=1.0.0
PKG_RELEASE:=2
ifeq ($(ARCH),i386)
	PKG_ARCH:=i386
endif
ifeq ($(ARCH),x86_64)
	PKG_ARCH:=x86_64
endif
ifeq ($(ARCH),mipsel)
	PKG_ARCH:=armhf
endif
ifeq ($(ARCH),mips)
	PKG_ARCH:=armhf
endif
ifeq ($(ARCH),arm)
	PKG_ARCH:=arm
endif
ifeq ($(ARCH),arm64)
	PKG_ARCH:=aarch64
endif
ifeq ($(ARCH),aarch64)
	PKG_ARCH:=aarch64
endif
PKG_FILE:=ookla-$(PKG_NAME)-$(PKG_VERSION)-$(PKG_ARCH)-linux.tgz
PKG_URL:=https://raw.githubusercontent.com/sirpdboy/$(PKG_NAME)/master/$(PKG_VERSION)/ookla-$(PKG_NAME)-$(PKG_VERSION)-$(PKG_ARCH)-linux.tgz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_VERSION)
PKG_HASH:=skip

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	DEPENDS:=+kmod-tun +wget +curl +jq
	TITLE:=Network speed test intranet and Extranet
	URL:=https://www.github.com/sirpdboy/NetSpeedTest
endef

define Package/$(PKG_NAME)/description
Network speed test intranet and Extranet
endef

define Build/Prepare
	if [ ! -f $(DL_DIR)/$(PKG_FILE) ] ; then \
		curl -f --connect-timeout 20 --retry 5 --location --insecure $(PKG_URL) -o $(DL_DIR)/$(PKG_FILE); \
	fi
	rm -r $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)
	tar -zxvf $(DL_DIR)/$(PKG_FILE) -C $(PKG_BUILD_DIR) --strip-components 1
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/usr/bin/$(PKG_NAME)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
