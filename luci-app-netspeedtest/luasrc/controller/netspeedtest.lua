
module("luci.controller.netspeedtest", package.seeall)

function index()

	page = entry({"admin", "network",  "netspeedtest"}, template("netspeedtest"), "netspeedtest", 90)
	page = entry({"admin", "network", "diag_iperf0"}, post("diag_iperf0"), nil)
	page.leaf = true
	page = entry({"admin", "network",  "diag_iperf1"}, post("diag_iperf1"), nil)
	page.leaf = true
	page = entry({"admin", "network", "diag_speedtest0"}, post("diag_speedtest0"), nil)
	page.leaf = true
	page = entry({"admin", "network", "diag_speedtest1"}, post("diag_speedtest1"), nil)
	page.leaf = true
	page = entry({"admin", "network", "diag_speedtest2"}, post("diag_speedtest2"), nil)
	page.leaf = true
	page = entry({"admin", "network", "diag_speedtest3"}, post("diag_speedtest3"), nil)
	page.leaf = true
	page = entry({"admin", "network", "diag_speedtest4"}, post("diag_speedtest4"), nil)
	page.leaf = true
	page = entry({"admin", "network", "diag_speedtest5"}, post("diag_speedtest5"), nil)
	page.leaf = true
	page = entry({"admin", "network", "diag_speedtest6"}, post("diag_speedtest6"), nil)
	page.leaf = true
	page = entry({"admin", "network", "diag_speedtest7"}, post("diag_speedtest7"), nil)
	page.leaf = true
	page = entry({"admin", "network", "diag_speedtest8"}, post("diag_speedtest8"), nil)
	page.leaf = true
end

function diag_cmd(cmd, addr)
	if addr and addr:match("^[0-9]+$") then
		luci.http.prepare_content("text/plain")

		local util = io.popen(cmd % addr)
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

function testlan(cmd, addr)
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

end


function diag_iperf0(addr)
	testlan("iperf3 -s ", addr)
end

function diag_iperf1(addr)
	testlan("iperf3 -s -B 0.0.0.0 ", addr)
end

function diag_speedtest0(addr)
	diag_cmd("ping -c 5 -W 1 %s 2>&1", addr)
end

function diag_speedtest1(addr)
	diag_cmd("ping -c 5 -W 1 %s 2>&1", addr)
end

function diag_speedtest2(addr)
	diag_cmd("ping -c 5 -W 1 %s 2>&1", addr)
end

function diag_speedtest3(addr)
	diag_cmd("ping -c 5 -W 1 %s 2>&1", addr)
end

function diag_speedtest4(addr)
	diag_cmd("ping -c 5 -W 1 %s 2>&1", addr)
end

function diag_speedtest5(addr)
	diag_cmd("ping -c 5 -W 1 %s 2>&1", addr)
end

function diag_speedtest6(addr)
	diag_cmd("ping -c 5 -W 1 %s 2>&1", addr)
end

function diag_speedtest7(addr)
	diag_cmd("ping -c 5 -W 1 %s 2>&1", addr)
end

function diag_speedtest8(addr)
	diag_cmd("ping -c 5 -W 1 %s 2>&1", addr)
end

