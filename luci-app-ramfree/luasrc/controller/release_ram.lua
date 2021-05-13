module("luci.controller.release_ram",package.seeall)

function index()
	entry({"admin","status","release_ram"}, call("release_ram"), _("刷新清理"), 9999)
end

function release_ram()
	luci.sys.call("/etc/ramfree.sh")
	luci.http.redirect(luci.dispatcher.build_url("admin/status"))
end
