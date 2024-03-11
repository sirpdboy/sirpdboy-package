-- Copyright 2019 X-WRT <dev@x-wrt.com>
-- Copyright 2022-2023 sirpdboy

module("luci.controller.netwizard", package.seeall)
function index()
	
	entry({"admin", "system", "netwizard"}).dependent = true
	if not nixio.fs.access("/etc/config/netwizard") then return end
	if not nixio.fs.access("/etc/config/netwizard_hide") then
	        e = entry({"admin","system", "netwizard"}, alias("admin","system", "netwizard","settings"), _("Inital Setup"), -1)
		e.dependent = true
                e.acl_depends = { "luci-app-netwizard" }
	end
	entry({"admin","system", "netwizard","settings"}, cbi("netwizard/netwizard"), _("Inital Setup"), 1).dependent = true

end
