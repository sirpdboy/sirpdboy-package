module("luci.controller.eqos", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/eqos") then
		return
	end
	
	local page

	entry({"admin","Control"}, firstchild(), "Control", 87).dependent = false
	page = entry({"admin", "control", "eqos"}, cbi("eqos"),  _("EQoS"), 90)
	page.dependent = true
end
