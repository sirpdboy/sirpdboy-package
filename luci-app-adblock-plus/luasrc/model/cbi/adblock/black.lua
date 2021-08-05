local fs=require "nixio.fs"
local conffile="/etc/adblock/black.list"

f=SimpleForm("custom")
t=f:field(TextValue,"conf")
t.rmempty=true
t.rows=13
t.description=translate("Will Always block these Domain")
function t.cfgvalue()
	return fs.readfile(conffile) or ""
end

function f.handle(self,state,data)
	if state == FORM_VALID then
		if data.conf then
			fs.writefile(conffile,data.conf:gsub("\r\n","\n"))
		else
			luci.sys.call("> /etc/adblock/black.list")
		end
		luci.sys.exec("[ \"$(uci -q get adblock.@adblock[0].enable)\" = 1 ] && /etc/init.d/adblock restart")
	end
	return true
end

return f
