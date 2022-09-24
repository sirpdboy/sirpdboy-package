module("luci.controller.wrtbwmon", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/wrtbwmon") then
		return
	end
	entry({"admin","status","online"},alias("admin","status","online","onlinuser"),_("Online User"), 10)
	entry({"admin","status","online","onlinuser"},template("onlinuser"),_("User online")).leaf=true
	entry({"admin", "nlbw", "usage"},alias("admin", "nlbw", "usage", "details"),_("Usage"), 1)
	entry({"admin", "nlbw", "usage", "details"},template("wrtbwmon"),_("Details"), 10)
	entry({"admin", "nlbw", "usage", "config"},arcombine(cbi("wrtbwmon/config")),_("Configuration"), 20)
	entry({"admin", "nlbw", "usage", "custom"},form("wrtbwmon/custom"),_("User file"), 30)

end

