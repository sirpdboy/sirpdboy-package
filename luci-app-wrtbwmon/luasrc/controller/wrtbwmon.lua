module("luci.controller.wrtbwmon", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/wrtbwmon") then
		return
	end

	entry({"admin", "network", "usage"},
		alias("admin", "network", "usage", "details"),
		 _("Traffic Status"), 60).acl_depends={ "luci-app-wrtbwmon" }
	entry({"admin", "network", "usage", "details"},
		view("wrtbwmon/details"),
		_("Details"), 10)
	entry({"admin", "network", "usage", "config"},
		view("wrtbwmon/config"),
		_("Configuration"), 20)
	entry({"admin", "network", "usage", "custom"},
		view("wrtbwmon/custom"),
		_("User file"), 30)
end
