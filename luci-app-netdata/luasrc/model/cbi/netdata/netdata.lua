-- Copyright 2018-2022 sirpdboy (herboy2008@gmail.com)
-- https://github.com/sirpdboy/luci-app-netdata
require("luci.util")

local m, s ,o

m = Map("netdata", translate("NetData"), translate("Netdata is high-fidelity infrastructure monitoring and troubleshooting.Open-source, free, preconfigured, opinionated, and always real-time.")..translate("</br>For specific usage, see:")..translate("<a href=\'https://github.com/sirpdboy/luci-app-netdata.git' target=\'_blank\'>GitHub @https://github.com/sirpdboy/luci-app-netdata </a>") )
s = m:section(TypedSection, "netdata", translate("Global Settings"))
s.addremove=false
s.anonymous=true

o=s:option(Flag,"enabled",translate("Enable"))
o.default=0

o=s:option(Value, "port",translate("Set the netdata access port"))
o.datatype="uinteger"
o.default=19999

local e=luci.http.formvalue("cbi.apply")
if e then
  io.popen("/etc/init.d/netdata start")
end

return m
