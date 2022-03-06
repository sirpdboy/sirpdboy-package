--[[
LuCI - Lua Configuration Interface
Copyright 2021 jjm2473
]]--

local m, s, o

m = Map("tuning", nil, translate("Select IPK Mirror server"))

s = m:section(TypedSection, "ipk")
s.addremove=false
s.anonymous=true

o = s:option(ListValue, "mirror", translate("Mirror server"))
o:value("disable", "")
o:value("http://downloads.openwrt.org/", translate("OpenWrt") .. " (HTTP)")
o:value("https://downloads.openwrt.org/", translate("OpenWrt") .. " (HTTPS)")
o:value("https://mirrors.tuna.tsinghua.edu.cn/openwrt/", translate("Tsinghua University"))
o:value("https://mirrors.ustc.edu.cn/openwrt/", translate("USTC"))
o:value("https://mirrors.aliyun.com/openwrt/", translate("Alibaba Cloud"))
o:value("https://mirrors.cloud.tencent.com/openwrt/", translate("Tencent Cloud"))

o.rmempty = false
o.default = "disable"

return m
