
-- Copyright (C) 2020-2021 sirpdboy <herboy2008@gmail.com>
-- The LuCI Network diagnosis and speed test <https://github.com/sirpdboy/NetSpeedTest/luci-app-NetSpeedTest>
-- This is free software, licensed under the GNU General Public License v3.

module("luci.controller.netspeedtest", package.seeall)

function index()
	local uci = require("luci.model.uci").cursor()
	local page
	page = entry({"admin", "network", "NetSpeedTest"}, template("NetSpeedTest/NetSpeedTest"), "NetSpeedTest", 90)
	page.dependent = true
	
	page = entry({"admin", "network", "diag_iperf3"}, call("diag_iperf3"), nil)
	page.leaf = true

	page = entry({"admin", "network", "diag_iperf36"}, call("diag_iperf36"), nil)
	page.leaf = true
	page = entry({"admin", "network","diag_ping"}, call("diag_ping"), nil)
	page.leaf = true	
	page = entry({"admin", "network","diag_ping6"}, call("diag_ping6"), nil)
	page.leaf = true
end

function diag_cmd(cmd, addr)
	if addr and addr:match("^[a-zA-Z0-9%-%.:_]+$") then
		luci.http.prepare_content("text/plain")

		local util = io.popen(cmd % luci.util.shellquote(addr))
		if util then
			while true do
				local ln = util:read("*l")
				if not ln then break end
				luci.http.write(ln)
				luci.http.write("\n")
			end

			util:close()
		end

		return
	end

	luci.http.status(500, "Bad address")
end
function testlan(cmd)
		luci.http.prepare_content("text/plain")

		local util = io.popen(cmd)
		if util then
			while true do
				local ln = util:read("*l")
				if not ln then break end
				luci.http.write(ln)
				luci.http.write("\n")
			end

			util:close()
		end

		return
	end

	luci.http.status(500, "Bad Network")
end
function diag_iperf3(addr)
	testlan("iperf3 -s 2>&1")
end

function diag_iperf36(addr)
	testlan("iperf3 -s -B 0.0.0.0 2>&1")
end

function diag_ping(addr)
	diag_cmd("ping -c 5 -W 1 %s 2>&1", addr)
end

function diag_ping6(addr)
	diag_cmd("ping6 -c 5 %s 2>&1", addr)
end
