local o=require"luci.dispatcher"
local e=require("luci.model.ipkg")
local s=require"nixio.fs"
local e=luci.model.uci.cursor()
local m,s,e

m=Map("autopoweroff",translate("Scheduled Setting"),translate("Scheduled reboot poweroff Setting"))

s=m:section(TypedSection,"login","")
s.addremove=false
s.anonymous=true

e=s:option(Flag,"enable",translate("Enable"))
e.rmempty = false
e.default=0

e=s:option(ListValue,"stype",translate("Scheduled Type"))
e:value(1,translate("Scheduled Reboot"))
e:value(2,translate("Scheduled Poweroff"))
e.default=1

e=s:option(ListValue,"week",translate("Week Day"))
e:value(7,translate("Everyday"))
e:value(1,translate("Monday"))
e:value(2,translate("Tuesday"))
e:value(3,translate("Wednesday"))
e:value(4,translate("Thursday"))
e:value(5,translate("Friday"))
e:value(6,translate("Saturday"))
e:value(0,translate("Sunday"))
e.default=7

e=s:option(Value,"hour",translate("Hour"))
e.datatype = "range(0,23)"
e.rmempty = false

e=s:option(Value,"minute",translate("Minute"))
e.datatype = "range(0,59)"
e.rmempty = false

local e=luci.http.formvalue("cbi.apply")
if e then
  io.popen("/etc/init.d/autopoweroff restart")
end

return m
