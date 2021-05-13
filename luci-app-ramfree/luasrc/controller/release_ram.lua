module("luci.controller.release_ram",package.seeall)

function index()
	entry({"admin","status","release_ram"}, call("release_ram"), _("释放内存"), 9999)
end

function release_ram()
	luci.sys.call("/usr/share/ramfree/ramfree freeclear")
	luci.http.redirect(luci.dispatcher.build_url("admin/status"))
end
