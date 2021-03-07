module("luci.controller.ddnsto",package.seeall)
function index()
if not nixio.fs.access("/etc/config/ddnsto")then
return
end
entry({"admin","services","ddnsto"},cbi("ddnsto/global"),_("ddnsto"),58).dependent=true
entry({"admin","services","ddnsto","status"},call("act_status")).leaf=true
end
function act_status()
local e={}
e.ddnsto=luci.sys.call("pgrep /usr/bin/ddnsto >/dev/null")==0
luci.http.prepare_content("application/json")
luci.http.write_json(e)
end
