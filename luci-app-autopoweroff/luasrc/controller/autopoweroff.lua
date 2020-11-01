module("luci.controller.autopoweroff",package.seeall)
function index()
entry({"admin","system","autopoweroff"},cbi("autopoweroff"),_("Scheduled Setting"),88)
end
