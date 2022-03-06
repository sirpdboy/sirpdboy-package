--[[
LuCI - Lua Configuration Interface
Copyright 2021 jjm2473
]]--

local fs   = require "nixio.fs"

local block = io.popen("block info", "r")
local ln, dev, devices = nil, nil, {}

repeat
	ln = block:read("*l")
	dev = ln and ln:match("^/dev/(.-):")

	if dev then
		local e, s, key, val = { }

		for key, val in ln:gmatch([[(%w+)="(.-)"]]) do
			e[key:lower()] = val
		end

		s = tonumber((fs.readfile("/sys/class/block/%s/size" % dev)))

		e.dev  = "/dev/%s" % dev
		e.size = s and math.floor(s / 2048)

		devices[#devices+1] = e
	end
until not ln

block:close()


local m, s, o

m = Map("tuning_boot", nil, translate("Boot"))

s = m:section(TypedSection, "fstab_delay", translate("Delay before mounting"))
s.addremove=false
s.anonymous=true

o = s:option(Flag, "enabled", translate("Enable"))

o = s:option(Value, "timeout", translate("Timeout (seconds)"))
o:value("5", "5")
o:value("10", "10")
o:value("30", "30")
o:value("60", "60")
o:depends("enabled", 1)
o.default = "5"

o = s:option(DynamicList, "device", translate("Or until these device(s) ready (UUID):"))
o:depends("enabled", 1)
for i, d in ipairs(devices) do
	if d.uuid and d.size then
		o:value(d.uuid, "%s (%s, %d MB)" %{ d.uuid, d.dev, d.size })
	elseif d.uuid then
		o:value(d.uuid, "%s (%s)" %{ d.uuid, d.dev })
	end
end

return m
