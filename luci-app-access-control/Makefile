# Copyright (C) 2016 Openwrt.org
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI Internet Access Control
LUCI_NAME:=luci-app-access-control
PKG_VERSION:=0.4.3
PKG_RELEASE=$(PKG_SOURCE_VERSION)

define Package/luci-app-access-control/postinst
#!/bin/sh
/etc/init.d/inetac enable
/etc/init.d/inetac start
exit 0
endef

define Package/luci-app-access-control/prerm
#!/bin/sh
/etc/init.d/inetac stop
/etc/init.d/inetac disable
exit 0
This version cleans up configuration, bot fails on CC:
#!/usr/bin/lua
require "uci"
os.execute ("exec /etc/init.d/inetac stop")
os.execute ("exec /etc/init.d/inetac disable")
local x = uci.cursor()
local commit = false
x:foreach ("firewall", "rule",
    function(s)
        if s.ac_enabled~=nil  then
            x:delete ("firewall", s[".name"])
            commit = true
        end
    end)
if commit then
    x:commit("firewall")
end
endef

include ../../luci.mk
#
# call BuildPackage - OpenWrt buildroot signature
