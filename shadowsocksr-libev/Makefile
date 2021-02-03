include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocksr-libev
PKG_VERSION:=2.5.6
PKG_RELEASE:=6

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/shadowsocksrr/shadowsocksr-libev
PKG_SOURCE_DATE:=2018-03-07
PKG_SOURCE_VERSION:=d63ff863800a5645aca4309d5dd5962bd1e95543
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.xz

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/shadowsocksr-libev/template
	SECTION:=net
	CATEGORY:=Network
	SUBMENU:=Web Servers/Proxies
	TITLE:=Lightweight Secured Socks5 Proxy
	URL:=https://github.com/shadowsocksrr/shadowsocksr-libev
	DEPENDS:=+libev +libsodium +libopenssl +libpthread +libpcre +libudns +zlib
endef

Package/shadowsocksr-libev-server = $(Package/shadowsocksr-libev)
Package/shadowsocksr-libev-alt = $(Package/shadowsocksr-libev)
define Package/shadowsocksr-libev-ssr-local
	$(call Package/shadowsocksr-libev/template,$(1))
	TITLE+= ssr-local
endef
CONFIGURE_ARGS += \
	--disable-documentation \
	--disable-ssp \
	--disable-assert \
	--enable-system-shared-lib

TARGET_CFLAGS += -flto
TARGET_LDFLAGS += -Wl,--gc-sections,--as-needed

define Package/shadowsocksr-libev-ssr-check
	$(call Package/shadowsocksr-libev/template,$(1))
	TITLE+= ssr-check
endef
define Package/shadowsocksr-libev-ssr-nat
	$(call Package/shadowsocksr-libev/template,$(1))
	TITLE+= ssr-nat
endef
define Package/shadowsocksr-libev/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-redir $(1)/usr/bin/ssr-redir
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-local $(1)/usr/bin/ssr-local
	$(LN) ssr-local $(1)/usr/bin/ssr-tunnel
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/server/ss-check $(1)/usr/bin/ssr-check
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/server/ss-server $(1)/usr/bin/ssr-server
endef

define Package/shadowsocksr-libev-ssr-redir
	$(call Package/shadowsocksr-libev/template,$(1))
	TITLE+= ssr-redir
endef

define Package/shadowsocksr-libev-ssr-server
	$(call Package/shadowsocksr-libev/template,$(1))
	TITLE+= ssr-server
endef
define Package/shadowsocksr-libev-alt/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-redir $(1)/usr/bin/ssr-redir
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/server/ss-check $(1)/usr/bin/ssr-check
endef

define Package/shadowsocksr-libev-server/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/server/ss-server $(1)/usr/bin/ssr-server
endef

define Package/shadowsocksr-libev/install/template
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/ss-$(2) $(1)/usr/bin/ssr-$(2)
endef

define Package/shadowsocksr-libev-ssr-check/install
	$(call Package/shadowsocksr-libev/install/template,$(1),check)
endef
define Package/shadowsocksr-libev-ssr-local/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-local $(1)/usr/bin/ssr-local
	$(call Package/shadowsocksr-libev/install/template,$(1),local)
	$(LN) ssr-local $(1)/usr/bin/ssr-tunnel
endef


define Package/shadowsocksr-libev-ssr-nat/install
	$(call Package/shadowsocksr-libev/install/template,$(1),nat)
endef

define Package/shadowsocksr-libev-ssr-redir/install
	$(call Package/shadowsocksr-libev/install/template,$(1),redir)
endef

define Package/shadowsocksr-libev-ssr-server/install
	$(call Package/shadowsocksr-libev/install/template,$(1),server)
endef
$(eval $(call BuildPackage,shadowsocksr-libev))
$(eval $(call BuildPackage,shadowsocksr-libev-alt))

$(eval $(call BuildPackage,shadowsocksr-libev-ssr-check))
$(eval $(call BuildPackage,shadowsocksr-libev-server))
$(eval $(call BuildPackage,shadowsocksr-libev-ssr-local))
$(eval $(call BuildPackage,shadowsocksr-libev-ssr-nat))
$(eval $(call BuildPackage,shadowsocksr-libev-ssr-redir))
$(eval $(call BuildPackage,shadowsocksr-libev-ssr-server))
