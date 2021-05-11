module("luci.controller.eqos", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/eqos") then
		return
	end
	
	local page

	page = entry({"admin", "control", "eqos"}, cbi("eqos"), "IP限速", 90)
	page.dependent = true
end
