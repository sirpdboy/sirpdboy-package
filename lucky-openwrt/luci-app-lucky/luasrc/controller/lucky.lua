-- Copyright (C) 2021-2022  sirpdboy  <herboy2008@gmail.com> https://github.com/sirpdboy/luci-app-lucky 
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.lucky", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/lucky") then
		return
	end

	entry({"admin",  "services", "lucky"}, alias("admin", "services", "lucky", "setting"),_("Lucky"), 57).dependent = true
	entry({"admin",  "services", "lucky", "lucky"}, template("lucky"), _("Lucky"), 10).leaf = true
	entry({"admin", "services", "lucky", "setting"}, cbi("lucky"), _("Setting"), 20).leaf=true
	entry({"admin", "services", "lucky_status"}, call("act_status"))
end

function act_status()
	local sys  = require "luci.sys"
	local e = { }
	e.running = sys.call("pidof lucky >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
