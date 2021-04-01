-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2008 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

local fs  = require "nixio.fs" 
local sys = require "luci.sys"
local m, s, p

local play_on = (luci.sys.call("pidof lan-play > /dev/null"))==0

local state_msg = " "

if play_on then
    local now_server = io.popen("ps | grep lan-play | grep -v 'grep' | cut -d ' ' -f 14")
    local server_info = now_server:read("*all")
    now_server:close()
    state_msg="<span style=\"color:green;font-weight:bold\">" .. translate("运行中") .. "</span>"  .. "<br /><br />当前服务器地址    " .. server_info
else
    state_msg="<span style=\"color:red;font-weight:bold\">" .. translate("未运行")  .. "</span>"
end

m = Map("switchlanplay", translate("切换LAN播放"),
	translatef("在互联网上玩本地无线交换机游戏。") .. "<br /><br />" ..translate("服务状态：") .. " - " .. state_msg)

s = m:section(TypedSection, "switch-lan-play", translate("Settings"))
s.addremove = false
s.anonymous = true

e = s:option(Flag, "enable", translate("Enabled"), translate("启用或禁用交换机lan播放守护程序。"))
e.rmempty  = false
function e.write(self, section, value)
    if value == "1" then
        luci.sys.call("/etc/init.d/switchlanplay start >/dev/null")
    else
        luci.sys.call("/etc/init.d/switchlanplay stop >/dev/null")
    end
    luci.http.write("<script>location.href='./switchlanplay';</script>")
    return Flag.write(self, section, value)
end

ifname = s:option(ListValue, "ifname", translate("Interfaces"), translate("指定要侦听的接口。"))

for k, v in ipairs(luci.sys.net.devices()) do
    if v ~= "lo" then
        ifname:value(v)
    end
end

relay_server_host = s:option(Value, "relay_server_host", translate("中继服务器主机"), translate("中继主机-IP地址或域名（必需）"))
    relay_server_host.datatype="host"
    relay_server_host.default="127.0.0.1"
    relay_server_host.rmempty="false"

relay_server_port = s:option(Value, "relay_server_port", translate("中继服务器端口"),translate("服务器端口（必需）"))
    relay_server_port.datatype="port"
    relay_server_port.default="11451"
    relay_server_port.rmempty="false"

p = s:option(Value, "pmtu", translate("PMTU"), translate("有些游戏需要定制一个PMTU。默认设置为0。"))
    p.datatype="uinteger"
    p.default="0"

return m
