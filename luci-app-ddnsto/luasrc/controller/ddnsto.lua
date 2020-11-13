module("luci.controller.ddnsto",package.seeall)
function index()
if not nixio.fs.access("/etc/config/ddnsto")then
return
end
local page
page = entry({"admin","services","ddnsto"},cbi("ddnsto/global"),_("ddnsto"),57)
page.dependent=true
page.entry({"admin","services","ddnsto","status"},call("act_status"))
page.leaf=true

end
function act_status()
local e={}
e.ddnsto=luci.sys.call("pidof ddnsto >/dev/null")==0
luci.http.prepare_content("application/json")
luci.http.write_json(e)
end
