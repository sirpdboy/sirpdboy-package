module("luci.controller.aria2",package.seeall)
local ucic = luci.model.uci.cursor()
local http = require "luci.http"
local util = require "luci.util"

function index()
	if not nixio.fs.access("/etc/config/aria2")then return end
	entry({"admin","nas","aria2"},firstchild(),_("Aria2")).dependent=false
	entry({"admin","nas","aria2","config"},cbi("aria2/config"),_("Configuration"),1)
	entry({"admin","nas","aria2","file"},form("aria2/files"),_("Files"),2)
	entry({"admin","nas","aria2","log"},firstchild(),_("Log"),3)
	entry({"admin","nas","aria2","log","view"},template("aria2/log_template"))
	entry({"admin","nas","aria2","log","read"},call("action_log_read"))
	entry({"admin", "nas", "aria2", "clear_log"}, call("clear_log")).leaf = true
	entry({"admin","nas","aria2","status"},call("action_status"))
end

function action_status()
local t={
running=(luci.sys.call("pidof aria2c >/dev/null")==0)
}
http.prepare_content("application/json")
http.write_json(t)
end

function clear_log()
	luci.sys.call("cat > /var/log/aria2_1.log")
end

function action_log_read()
	local t={log="",syslog=""}
	local o=ucic:get("aria2","main","log")or"/var/log/aria2.log"
		if nixio.fs.access(o) then
		t.log=util.trim(luci.sys.exec("tail -n 50 %s | sed 'x;1!H;$!d;x'"%o))
		end
	t.syslog=util.trim(luci.sys.exec("[ -f '/var/log/aria2_1.log' ] && cat /var/log/aria2_1.log"))
	http.prepare_content("application/json")
	http.write_json(t)
end
