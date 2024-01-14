-- Copyright 2016-2019 Xingwang Liao <kuoruan@gmail.com>
-- Licensed to the public under the MIT License.

local fs   = require "nixio.fs"
local sys  = require "luci.sys"
local http = require "luci.http"
local util = require "luci.util"
local uci  = require "luci.model.uci".cursor()

module("luci.controller.aria2", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/aria2") then
		return
	end

	local e = entry({"admin", "nas", "aria2"}, firstchild(), _("Aria2"))
	e.dependent = false
	e.acl_depends = { "luci-app-aria2" }

	entry({"admin", "nas", "aria2", "config"},
		cbi("aria2/config"), _("Configuration"), 1)

	entry({"admin", "nas", "aria2", "file"},
		form("aria2/files"), _("Files"), 2)

	entry({"admin", "nas", "aria2", "log"},
		cbi("aria2/log"), _("Log"), 3)

	entry({"admin", "nas", "aria2", "status"},
		call("action_status"))

	entry({"admin", "nas", "aria2", "get_log"},
	    call("get_log")).leaf = true
	entry({"admin", "nas", "aria2", "clear_log"},
	    call("clear_log")).leaf = true

end

function action_status()
	local status = {
		running = (sys.call("pidof aria2c >/dev/null") == 0)
	}

	http.prepare_content("application/json")
	http.write_json(status)
end

function get_log()
    local log_file = uci:get("aria2", "main", "log") or "/var/log/aria2.log"
	luci.http.write(luci.sys.exec('cat ' .. log_file))
end

function clear_log()
    local log_file = uci:get("aria2", "main", "log") or "/var/log/aria2.log"
	luci.sys.call('cat /dev/null > ' .. log_file)
end
