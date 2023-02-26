module("luci.controller.speedlimit", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/speedlimit") then return end
	local page
        entry({"admin", "control"}, firstchild(), "Control", 44).dependent = false
	page = entry({"admin","control","speedlimit"},cbi("speedlimit"),_("网速限制"),67)
	page.dependent = true
 end
