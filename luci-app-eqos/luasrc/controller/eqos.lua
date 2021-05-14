module("luci.controller.eqos", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/eqos") then
		return
	end

    entry({"admin", "control"}, firstchild(), "Control", 44).dependent = false
    entry({"admin", "control", "eqos"}, cbi("eqos"), "网速限制", 90).dependent = true
end
