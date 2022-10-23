-- Copyright 2018 sirpdboy (herboy2008@gmail.com)
require("luci.util")
local o,t,e
 
o = Map("netspeedtest", "<font color='green'>" .. translate("Netspeedtest") .."</font>" ))
o.template = "netspeedtest/index"

t = o:section(TypedSection, "netspeedtest", translate('iperf3 lanspeedtest'))
t.anonymous = true

e = t:option(DummyValue, "iperf3_status", translate("Status"))
e.template = "netspeedtest/iperf3_status"
e.value = translate("Collecting data...")

e = t:option(DummyValue, '', '')
e.rawhtml = true
e.template ='netspeedtest/netspeedtest'


t=o:section(TypedSection,"netspeedtest",translate("wanspeedtest"))
t.anonymous=true
e = t:option(DummyValue, '', '')
e.rawhtml = true
e.template ='netspeedtest/speedtest'

e =t:option(DummyValue, '', '')
e.rawhtml = true
e.template = 'netspeedtest/log'

return o
