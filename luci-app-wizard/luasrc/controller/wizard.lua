-- Copyright 2019 X-WRT <dev@x-wrt.com>
-- Copyright 2022 sirpdboy

module("luci.controller.wizard", package.seeall)
function index()
	if not nixio.fs.access("/etc/config/wizard") then
		return
	end
		local page 
		page = entry({"admin","wizard"}, cbi("wizard/wizard"), _("Inital Setup"), 81)
		page.i18n = "wizard"
		page.dependent = true

end
