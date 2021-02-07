module("luci.controller.autotimeset",package.seeall)
function index()
entry({"admin","system","autotimeset"},cbi("autotimeset"),_("Scheduled Setting"),88)
end
