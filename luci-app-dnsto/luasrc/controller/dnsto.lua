module("luci.controller.dnsto",package.seeall)
function index()
if not nixio.fs.access("/etc/config/dnsto")then
return
end
entry({"admin","services","dnsto"},cbi("dnsto/global"),_("DDNSTO内网穿透"), 61).dependent = true
entry({"admin","services","dnsto_status"},call("act_status")).leaf=true
end
function act_status()
	local sys  = require "luci.sys"

	local status = {
		running = (sys.call("pidof ddnsto >/dev/null") == 0)
	}

	luci.http.prepare_content("application/json")
	luci.http.write_json(status)
end
