module("luci.controller.rebootschedule", package.seeall)
function index()
	if not nixio.fs.access("/etc/config/rebootschedule") then
		return
	end
	
	local page
	page = entry({"admin", "control", "rebootschedule"}, cbi("rebootschedule"), "Reboot schedule", 88)
	page.dependent = true
end



