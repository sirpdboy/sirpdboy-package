module("luci.controller.ddnsto",package.seeall)
function index()
if not nixio.fs.access("/etc/config/ddnsto")then
return
end
entry({"admin","services","ddnsto"},cbi("ddnsto/global"),_("DDNS.to内网穿透"), 60).dependent = true
entry({"admin","services","ddnsto_status"},call("act_status")).leaf=true
end
function act_status()
	local sys  = require "luci.sys"

	local status = {
		running = (sys.call("pidof ddnsto >/dev/null") == 0)
	}

	luci.http.prepare_content("application/json")
	luci.http.write_json(status)
end
