#qbittorrent
include $(TOPDIR)/rules.mk

PKG_NAME:=qbittorrent
PKG_VERSION:=4.3.3_v1.2.12
PKG_RELEASE=1

STRIP:=true

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	SUBMENU:=BitTorrent
	TITLE:=bittorrent client programmed in C++ / Qt
	URL:=https://www.qbittorrent.org/
endef

define Package/$(PKG_NAME)/description
  qBittorrent is a bittorrent client programmed in C++ / Qt that uses
  libtorrent (sometimes called libtorrent-rasterbar) by Arvid Norberg.
  It aims to be a good alternative to all other bittorrent clients out
  there. qBittorrent is fast, stable and provides unicode support as
  well as many features.
endef

define Download/qbittorrent
  URL:=https://github.com/userdocs/qbittorrent-nox-static/releases/download/release-$(PKG_VERSION)
  URL_FILE:=amd64-glibc-qbittorrent-nox
  FILE:=qbittorrent-nox
  HASH:=skip
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(DL_DIR)/qbittorrent-nox $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/qBittorrent
	$(INSTALL_DATA) ./files/ipfilter.dat $(1)/etc/qBittorrent/ipfilter.dat

endef

$(eval $(call Download,qbittorrent))
$(eval $(call BuildPackage,$(PKG_NAME)))

