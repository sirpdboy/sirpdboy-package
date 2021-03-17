module("luci.controller.netspeedtest", package.seeall)
function index()
	page = entry({"admin", "network",  "netspeedtest"}, template("netspeedtest"), "netspeedtest", 89)
        page.dependent=false
	page = entry({"admin", "network",  "test_speedtest0"}, post("test_speedtest0"), nil)
	page.leaf = true
	page = entry({"admin", "network",  "test_speedtest1"}, post("test_speedtest1"), nil)
	page.leaf = true
	page = entry({"admin", "network", "test_iperf0"}, post("test_iperf0"), nil)
	page.leaf = true
	page = entry({"admin", "network",  "test_iperf1"}, post("test_iperf1"), nil)
	page.leaf = true

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


function test_speedtest0(addr)
   testlan("yes | speedtest  | tee -a /tmp/nsreport.txt", addr)
end

function test_iperf0(addr)
	testlan("iperf3 -s ", addr)
end


function test_iperf1(addr)
	luci.sys.call("killall iperf3")
end

function test_speedtest1()
     luci.sys.exec("yes | speedtest  | tee -a /tmp/nsreport.txt")
end
