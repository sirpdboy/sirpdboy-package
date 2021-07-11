module("luci.controller.speedlimit", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/speedlimit") then return end
	entry({"admin", "network", "speedlimit"}, cbi("speedlimit"), _("速度限制"), 67).dependent = true
 end
