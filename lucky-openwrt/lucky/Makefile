
include $(TOPDIR)/rules.mk

PKG_NAME:=lucky
PKG_VERSION:=1.4.9

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=multimedia
  CATEGORY:=Multimedia
  DEPENDS:=@(aarch64||arm||i386||mips||mipsel||x86_64)
  TITLE:=A plug-in lucky by sirpdboy
  URL:=https://github.com/gdy666/lucky
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	[ -f /etc/uci-defaults/luci-lucky ] && /etc/uci-defaults/luci-lucky && rm -f /etc/uci-defaults/luci-lucky
fi
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/init.d $(1)/etc/uci-defaults $(1)/etc/lucky
	$(INSTALL_BIN) ./files/lucky.init $(1)/etc/init.d/lucky
	$(INSTALL_BIN) ./files/luci-lucky.uci-default $(1)/etc/uci-defaults/luci-lucky
	$(INSTALL_BIN) ./files/x86_64 $(1)/usr/bin/lucky
	$(INSTALL_DATA) ./files/lucky-default.conf $(1)/etc/lucky/lucky-default.conf

endef

$(eval $(call BuildPackage,$(PKG_NAME)))
