-- Copyright (C) 2018 dz <dingzhong110@gmail.com>
-- mod by 2021-2022  sirpdboy  <herboy2008@gmail.com> https://github.com/sirpdboy/luci-app-cupsd

module("luci.controller.cupsd", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/cupsd") then
		return
	end

	entry({"admin", "services", "cupsd"},alias("admin", "services", "cupsd","basic"),_("CUPS打印服务器"),60).dependent = true
	entry({"admin", "services", "cupsd","basic"}, cbi("cupsd/basic"),_("设置"),10).leaf = true
	entry({"admin", "services", "cupsd","advanced"}, cbi("cupsd/advanced"),_("高级"),20).leaf = true
	entry({"admin", "services", "cupsd_status"}, call("act_status"))
end

function act_status()
	local sys  = require "luci.sys"
	local uci  = require "luci.model.uci".cursor()
	local port = tonumber(uci:get_first("cupsd", "cupsd", "port") )
	local e = { }
	e.running = sys.call("pidof cupsd > /dev/null") == 0
	e.port = port or 631
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
