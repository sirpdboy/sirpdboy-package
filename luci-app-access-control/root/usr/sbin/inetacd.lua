#!/usr/bin/lua

--[[
LuCI - Lua Configuration Interface - Internet access control

Copyright 2015,2016 Krzysztof Szuster.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

$Id$

This daemon restores internet blocking rules to normal operation after their temporary suspension.
]]--

require "uci"


function check ()
    local x = uci.cursor()
    local tnow = os.time()
    local nexttime 
    local changed = false
     
    x:foreach ("firewall", "rule", 
        function(s) 
            if s.ac_enabled=='1' and s.ac_suspend then
                local tend = math.ceil (tonumber (s.ac_suspend) / 60) * 60 
                local jeszcze = tend - tnow
                if jeszcze <= 0 then
                    x:set ("firewall", s[".name"], "enabled", '1')
                    x:delete ("firewall", s[".name"], "ac_suspend")
                    changed = true
                else
                    if not nexttime or nexttime > jeszcze then
                        nexttime = jeszcze
                    end
                end
            end
        end)
    if changed then
        x:commit("firewall")
        os.execute ("/etc/init.d/firewall restart")
    end
    return nexttime    
end

while true do
    local nexttime = check()
    if nexttime==nil then
        break
    end
    os.execute ("exec sleep "..nexttime)
end    
