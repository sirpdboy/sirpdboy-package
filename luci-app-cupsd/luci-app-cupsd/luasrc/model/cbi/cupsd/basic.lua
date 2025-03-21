-- Copyright
-- Licensed to the public under the Apache License 2.0.
-- mod by wulishui

local m, s, o

m = Map("cupsd", translate("CUPS打印服务器"))
m.description = translate("<font color=\"green\">CUPS是苹果公司为MacOS和其他类似UNIX的操作系统开发的基于标准的开源打印系统。</font>")
m:section(SimpleSection).template  = "cupsd_status"

s = m:section(TypedSection, "cupsd", translate("Global Settings"))
s.addremove=false
s.anonymous = true

o=s:option(Flag, "enabled", translate("Enable"))
o.default=0

o=s:option(Value, "port", translate("WEB管理端口"),translate("可随意设定为无冲突的端口，对程序运行无影响。"))
o.datatype="uinteger"
o.default=631
o:depends("enabled",1)


local e=luci.http.formvalue("cbi.apply")
if e then
  io.popen("/etc/init.d/cupsd start")
end
return m
