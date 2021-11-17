local m, s, Status

local ver = luci.sys.exec("vlmcsd -V | awk '/built/{print $2}' | sed -n 's/,//p'")

local running=(luci.sys.call("pidof vlmcsd > /dev/null") == 0)

if running then
	Status = "<b><font color=\"green\">" .. translate("KMS Server is running.") .. "</font></b>"
else
	Status = "<b><font color=\"red\">" .. translate("KMS Server is stopped.") .. "</font></b>"
end

m = Map("vlmcsd", translate("KMS Server config"), translate("Current Version") .. ": " .. ver .. "<br /> " .. Status )

s = m:section(TypedSection, "vlmcsd", "")
s.addremove = false
s.anonymous = true

enable = s:option(Flag, "enabled", translate("Enable"))
enable.rmempty = false

-- function enable.cfgvalue(self, section)
--	return luci.sys.init.enabled("vlmcsd") and self.enabled or self.disabled
-- end

local hostname = luci.model.uci.cursor():get_first("system", "system", "hostname")

autoactivate = s:option(Flag, "autoactivate", translate("Auto activate"))
autoactivate.rmempty = false

config = s:option(Value, "config", translate("configfile"), translate("This file is /etc/vlmcsd.ini."), "")
config.template = "cbi/tvalue"
config.rows = 20
config.wrap = "off"

function config.cfgvalue(self, section)
	return nixio.fs.readfile("/etc/vlmcsd.ini")
end

function config.write(self, section, value)
	value = value:gsub("\r\n?", "\n")
	nixio.fs.writefile("/etc/vlmcsd.ini", value)
end

-- Apply & Save 
local apply = luci.http.formvalue("cbi.apply")
--if false then
if apply then
	luci.sys.call("/etc/init.d/kms reload >/dev/null")
end

return m
