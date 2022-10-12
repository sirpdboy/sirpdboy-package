module("luci.controller.netdata", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/netdata") then
		return
	end

	
	local page
	entry({"admin", "status", "netdata"}, alias("admin", "status", "netdata", "netdata"),_("NetData"), 10).dependent = true

	entry({"admin", "status", "netdata", "netdata"}, template("netdata/netdata"), _("NetData"), 10).leaf = true
	entry({"admin", "status", "netdata", "setting"}, cbi("netdata/netdata"), _("Setting"), 20).leaf=true
	
end

