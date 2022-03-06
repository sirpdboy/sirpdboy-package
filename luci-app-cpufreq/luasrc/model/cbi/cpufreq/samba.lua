--[[
LuCI - Lua Configuration Interface
Copyright 2021 jjm2473
]]--

local m, s, o

m = Map("samba4", nil, translate("Samba"))

s = m:section(TypedSection, "samba", translate("Samba expert"))
s.addremove=false
s.anonymous=true

o = s:option(Flag, "allow_legacy_protocols", translate("Allow legacy protocols"), translate("Allow old client, don't use this option for secure environments!"))

-- uci set samba.@samba[0].allow_legacy_protocols=1

return m
