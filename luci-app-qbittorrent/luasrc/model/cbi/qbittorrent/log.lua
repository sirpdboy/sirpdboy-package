-- Copyright 2017-2019 Xingwang Liao <kuoruan@gmail.com>
-- Licensed to the public under the MIT License.

local m, s, o

local fs   = require "nixio.fs"
local util = require "luci.util"
local uci  = require "luci.model.uci".cursor()

local config_dir = uci:get("qbittorrent", "main", "profile") or "/tmp"
local config_file = "%s/qBittorrent/data/logs/qbittorrent.log" % config_dir

m = SimpleForm("qbittorrent", "%s - %s" % { translate("qBittorrent"), translate("日志文件") },
	translate("本页是qBittorrent的运行日志内容。"))
m.reset = false
m.submit = false

s = m:section(SimpleSection, nil, translatef("这是<code>%s</code>下的运行日志内容：", config_file))

o = s:option(TextValue, "_config")
o.rows = 25
o.readonly = true
o.cfgvalue = function()
	local v = fs.readfile(config_file) or translate("File does not exist.")
	return util.trim(v) ~= "" and v or translate("Empty file.")
end

return m