--[[
LuCI - Lua Configuration Interface
Copyright 2021 jjm2473
]]--

local m, s, o
require "luci.util"

local governor_path = "/sys/devices/system/cpu/cpufreq/policy0/scaling_governor"
local temp0_path = "/sys/devices/virtual/thermal/thermal_zone0/trip_point_0_temp"

local fs = require "nixio.fs"

m = Map("cpufreq", nil, translate("Manage CPU performance and temperature over LuCI."))
m:section(SimpleSection).template  = "cpufreq/cpuinfo"

s = m:section(TypedSection, "cpufreq")
s.addremove=false
s.anonymous=true

local cur_governor = luci.util.trim(fs.readfile(governor_path))

o = s:option(ListValue, "governor", translate("CPUFreq governor"))
for i,v in pairs(luci.util.split(luci.util.trim(fs.readfile("/sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors")), " ")) do
  o:value(v, translate(v))
end
o.rmempty = false
o.default = cur_governor

if math.floor(fs.stat(temp0_path, "modedec")/200) % 2 == 1 then
  local cur_trip_temp = luci.util.trim(fs.readfile(temp0_path))
  o = s:option(Value, "fan_temp", translate("Fan trigger temperature") .. " (&#8451;)")
  o.rmempty = false
  o.default = cur_trip_temp
end

return m
