
module("luci.controller.cpulimit", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/cpulimit") then
		return
	end
        entry({"admin", "control"}, firstchild(), "Control", 44).dependent = false
	local page = entry({"admin", "control", "cpulimit"}, cbi("cpulimit"), _("CPU限制"), 65)
	page.dependent = true

end