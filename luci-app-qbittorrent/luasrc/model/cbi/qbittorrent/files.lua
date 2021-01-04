-- Copyright 2017-2019 Xingwang Liao <kuoruan@gmail.com>
-- Licensed to the public under the MIT License.

local m, s, o

local fs   = require "nixio.fs"
local util = require "luci.util"
local uci  = require "luci.model.uci".cursor()

local a = uci:get("qbittorrent", "main", "profile") or "/tmp"
local b = "/etc/config/qbittorrent"
local c = "%s/qBittorrent/config/qBittorrent.conf" % a

m = SimpleForm("qbittorrent", "%s - %s" % { translate("qBittorrent"), translate("配置文件") },
	translate("本页是qBittorrent的配置文件内容。"))
m.reset = false
m.submit = false

s = m:section(SimpleSection, nil, translatef("这是<code>%s</code>下的配置文件内容：", b))

o = s:option(TextValue, "_config")
o.rows = 20
o.readonly = true
o.cfgvalue = function()
	local v = fs.readfile(b) or translate("File does not exist.")
	return util.trim(v) ~= "" and v or translate("Empty file.")
end

s = m:section(SimpleSection, nil, translatef("这是<code>%s</code>下的配置文件内容：", c))

o = s:option(TextValue, "_session")
o.rows = 20
o.readonly = true
o.cfgvalue = function()
	local v = fs.readfile(c) or translate("File does not exist.")
	return util.trim(v) ~= "" and v or translate("Empty file.")
end

return m
