-- Copyright 2008 Yanira <forum-2008@email.de>
-- Licensed to the public under the Apache License 2.0.
-- mod by wulishui 20191205
-- mod by 2021-2022  sirpdboy  <herboy2008@gmail.com> https://github.com/sirpdboy/luci-app-cupsd

local m, s, o


m = Map("cupsd", translate("CUPS打印服务器"))
m.description = "<font color=\"green\">CUPS是苹果公司为MacOS和其他类似UNIX的操作系统开发的基于标准的开源打印系统。</font><br><a href=\"/cups.pdf\" target=\"_blank\">点击此处可浏览或下载《添加打印机教程》</a>"
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


return m


