module("luci.controller.netdata", package.seeall)

function index()

	entry({"admin", "status", "netdata"}, template("netdata"), _("NetData"), 10).leaf = true
	entry({"admin", "status", "netdata", "reinit"}, call("act_reinit"))
end


function act_reinit()
	luci.sys.exec('/etc/init.d/netdate stop   >/dev/null  && /etc/init.d/netdate start  >/dev/null ') 
end