module("luci.controller.rebootschedule", package.seeall)
function index()
	if not nixio.fs.access("/etc/config/rebootschedule") then
		return
	end
	
	local page
	page = entry({"admin", "control", "rebootschedule"}, cbi("rebootschedule"), "定时设置", 20)
	page.dependent = true
end



