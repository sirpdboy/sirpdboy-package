local fs=require "nixio.fs"
local conffile="/etc/adblock/white.list"

f=SimpleForm("custom")
t=f:field(TextValue,"conf")
t.rmempty=true
t.rows=13
t.description=translate("Will Never filter these Domain")
function t.cfgvalue()
	return fs.readfile(conffile) or ""
end

function f.handle(self,state,data)
	if state == FORM_VALID then
		if data.conf then
			fs.writefile(conffile,data.conf:gsub("\r\n","\n"))
		else
			luci.sys.call("> /etc/adblock/white.list")
		end
		luci.sys.exec("for i in $(cat /etc/adblock/white.list);do sed -i -e \"/\\/$i\\//d\" -e \"/\\.$i\\//d\" /tmp/adblock/3rd/3rd.conf 2>/dev/null;\\\
		[ -s /etc/adblock/3rd/3rd.conf ] && sed -i -e \"/\\/$i\\//d\" -e \"/\\.$i\\//d\" /etc/adblock/3rd/3rd.conf;done;\\\
		[ -s /tmp/adblock/adblock.conf ] && rm -f /tmp/adblock/adblock.conf /tmp/dnsmasq.adblock/adblock.conf && /etc/init.d/adblock start")
	end
	return true
end

return f
