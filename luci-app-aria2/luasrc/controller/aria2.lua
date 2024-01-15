local sys = require "luci.sys"
local uci = require "luci.model.uci".cursor()

module("luci.controller.aria2", package.seeall)
function index()
    if not nixio.fs.access("/etc/config/aria2") then return end

    entry({ "admin", "nas", "aria2" }, firstchild(), _("Aria2")).dependent = false
    entry({ "admin", "nas", "aria2", "config" }, cbi("aria2/config"), _("Configuration"), 1)
    entry({ "admin", "nas", "aria2", "file" }, form("aria2/files"), _("Files"), 2)
    entry({ "admin", "nas", "aria2", "log" }, form("aria2/log"), _("Log"), 3).leaf = true
    entry({ "admin", "nas", "aria2", "action_log_read" }, call("action_log_read"))
    entry({ "admin", "nas", "aria2", "clear_log" }, call("clear_log")).leaf = true
    entry({ "admin", "nas", "aria2", "status" }, call("action_status"))
end

function action_status()
    luci.http.prepare_content("application/json")
    luci.http.write_json({
        running = sys.call("ps 2>/dev/null | grep aria2c 2>/dev/null | grep /usr/bin >/dev/null") == 0
    })
end

local log_dir = uci:get("aria2", "main", "log_dir") or "/var/log"
local log = log_dir .. '/aria2.log'
local syslog = log_dir .. '/aria2_syslog.log'

function action_log_read()
    luci.http.prepare_content("application/json")
    luci.http.write_json({
        log = nixio.fs.access(log) and sys.exec("tail -n 60 %s" % log) or "",
        syslog = nixio.fs.access(syslog) and sys.exec("tail -n 60 %s" % syslog) or ""
    })
end

function clear_log()
    if nixio.fs.access(log) then
        sys.call(":> " .. log)
    end
    if nixio.fs.access(syslog) then
        sys.call(":> " .. syslog)
    end
end
