module("luci.controller.vhusbd", package.seeall)

function index()
	
	if not nixio.fs.access("/etc/config/vhusbd") then
		return
	end
	
	entry({"admin", "services", "vhusbd", "status"}, call("vhusbd_status")).leaf = true
	entry({"admin", "services", "vhusbd"}, cbi("vhusbd"), _("VirtualHere"), 46).dependent = true
end

function vhusbd_status()
	local status = {}
	status.running = luci.sys.call("pgrep vhusbd >/dev/null")==0
	luci.http.prepare_content("application/json")
	luci.http.write_json(status)
end

