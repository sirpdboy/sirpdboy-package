
local fs   = require "nixio.fs"
local sys  = require "luci.sys"
local http = require "luci.http"
local util = require "luci.util"
local uci  = require "luci.model.uci".cursor()

module("luci.controller.qbittorrent",package.seeall)

function index()
  if not nixio.fs.access("/etc/config/qbittorrent")then
    return
  end
  
 	entry({"admin", "nas", "qbittorrent"},
		firstchild(), _("qBittorrent")).dependent = false
		
	entry({"admin", "nas", "qbittorrent", "config"},
		cbi("qbittorrent/config"), _("Global settings"), 1)

	entry({"admin", "nas", "qbittorrent", "file"},
		form("qbittorrent/files"), _("configuration file"), 2)

	entry({"admin", "nas", "qbittorrent", "log"},
--		form("qbittorrent/log"), _("Operation log"), 3)
		firstchild(), _("Operation log"), 3)

	entry({"admin", "nas", "qbittorrent", "log", "view"},
		template("qbittorrent/log"))

	entry({"admin", "nas", "qbittorrent", "log", "read"},
		call("action_log_read"))

	entry({"admin","nas","qbittorrent","status"},
		call("act_status"))
end

function act_status()
  local e={}
  e.running=luci.sys.call("pgrep qbittorrent-nox >/dev/null")==0
  http.prepare_content("application/json")
  http.write_json(e)
end

function action_log_read()
	local data = { log = "", syslog = "" }
	if uci:get("qbittorrent", "main", "Path") then
		path = uci:get("qbittorrent", "main", "Path") .. "/qbittorrent.log"
	else
		path = uci:get("qbittorrent", "main", "profile") .. "/qBittorrent/data/logs/qbittorrent.log"
	end
	path = string.gsub(path, '/+', '/')
	data.log = util.trim(sys.exec("tail -n 30 " .. path .. " | cut -d'-' -f2- | sed 's/T/-/'"))
	
	data.syslog = util.trim(sys.exec("logread | grep qbittorrent | tail -n 30 | cut -d' ' -f3-"))
	http.prepare_content("application/json")
	http.write_json(data)
end