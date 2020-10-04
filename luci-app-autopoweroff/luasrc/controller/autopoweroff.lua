module("luci.controller.autopoweroff",package.seeall)
function index()
entry({"admin","system","autopoweroff"},cbi("autopoweroff"),_("Scheduled poweroff"),88)
end
