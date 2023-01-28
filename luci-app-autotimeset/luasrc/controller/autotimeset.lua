module("luci.controller.autotimeset",package.seeall)
function index()
	if not nixio.fs.access("/etc/config/autotimeset") then
		return
	end
	local page
        entry({"admin", "control"}, firstchild(), "Control", 44).dependent = false
	page = entry({"admin","control","autotimeset"},cbi("autotimeset"),_("Scheduled Setting"),20)
	page.dependent = true
end
