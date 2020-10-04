module("luci.controller.advanced",package.seeall)
function index()
local e
e=entry({"admin","system","advanced"},cbi("advanced"),_("高级设置"),60)
e.dependent=true
end
