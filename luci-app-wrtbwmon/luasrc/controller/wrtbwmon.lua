module("luci.controller.wrtbwmon", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/wrtbwmon") then
		return
	end
	entry({"admin", "nlbw", "usage"},
		alias("admin", "nlbw", "usage", "details"),
		 _("Usage"), 1)
	entry({"admin", "nlbw", "usage", "details"},
		template("wrtbwmon"),
		_("Details"), 10).leaf=true
	entry({"admin", "nlbw", "usage", "config"},
		arcombine(cbi("wrtbwmon/config")),
		_("Configuration"), 20).leaf=true
	entry({"admin", "nlbw", "usage", "custom"},
		form("wrtbwmon/custom"),
		_("User file"), 30).leaf=true
end

