

module("luci.controller.access_control", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/firewall") then
		return
	end
--	if not nixio.fs.access("/etc/config/access_control") then
--		return
--	end
	
    entry({"admin", "control"}, firstchild(), "Control", 44).dependent = false
	entry({"admin", "control", "access_control"}, cbi("access_control"), _("时间控制"), 10).dependent = true
end
