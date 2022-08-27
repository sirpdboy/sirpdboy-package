module("luci.controller.wrtbwmon", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/wrtbwmon") then
		return
	end
	entry({"admin","status","online"},alias("admin","status","online","onlinuser"),_("Online User"), 10)
	entry({"admin","status","online","onlinuser"},template("wrtbwmon/onliner"),_("User online")).leaf=true
	entry({"admin", "nlbw", "onlinespeed"},alias("admin", "nlbw", "onlinespeed", "speed"), _("Speed monitor"), 1)
	entry({"admin", "nlbw", "onlinespeed","speed"},template("wrtbwmon/display"),_("Real time speed"))
	entry({"admin", "nlbw", "usage"},alias("admin", "nlbw", "usage", "details"),_("Usage"), 1)
	entry({"admin", "nlbw", "usage", "details"},template("wrtbwmon"),_("Details"), 10)
	entry({"admin", "nlbw", "usage", "config"},arcombine(cbi("wrtbwmon/config")),_("Configuration"), 20)
	entry({"admin", "nlbw", "usage", "custom"},form("wrtbwmon/custom"),_("User file"), 30)
	entry({"admin","nlbw","onlinespeed","setnlbw"}, call("set_nlbw"))

end

function set_nlbw()
	if nixio.fs.access("/var/run/onsetnlbw") then
		nixio.fs.writefile("/var/run/onsetnlbw","1");
	else
		io.popen("/usr/share/onliner/setnlbw &")
	end
	luci.http.prepare_content("application/json")
	luci.http.write('')
end
