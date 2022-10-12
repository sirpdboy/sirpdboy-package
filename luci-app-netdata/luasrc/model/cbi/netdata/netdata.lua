-- Copyright 2018 sirpdboy (herboy2008@gmail.com)
require("luci.util")

local m, s ,o

local m = Map("netdata", translate("NetData"))

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
