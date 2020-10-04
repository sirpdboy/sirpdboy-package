module("luci.controller.netdata", package.seeall)

function index()
	local fs = require "nixio.fs"

	entry({"admin","status","netdata"},template("netdata"),_("NetData"),10).leaf=true
	entry({"admin", "status", "netdata", "call"}, post("action_netdata"))	


end

function action_netdata()
	luci.sys.call("/usr/share/netdatacn/netdatacn.sh 2>&1 >/dev/null")
	luci.http.redirect(luci.dispatcher.build_url("admin","status","netdata"))
end
