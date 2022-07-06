-- Copyright 2019 X-WRT <dev@x-wrt.com>
-- Copyright 2022 sirpdboy

local nt = require "luci.sys".net
local uci = require("luci.model.uci").cursor()

local has_wifi = false
uci:foreach("wireless", "wifi-device",
		function(s)
			has_wifi = true
			return false
		end)

local m = Map("wizard", luci.util.pcdata(translate("Inital Router Setup")), translate("Quick network setup wizard. If you need more settings, please enter network - interface to set.</br>")..translate("Automatically set the network card. By default, the last network port is wan, and the others are LAN ports. All network cards of the side route are bound to LAN</br>")..translate("For specific usage, see:")..translate("<a href=\'https://github.com/sirpdboy/luci-app-wizard.git' target=\'_blank\'>GitHub @sirpdboy/luci-app-wizard</a>") )

local s = m:section(TypedSection, "wizard", "")
s.addremove = false
s.anonymous = true

s:tab("wansetup", translate("Wan Settings"))
if has_wifi then
	s:tab("wifisetup", translate("Wireless Settings"), translate("Set the router's wireless name and password. For more advanced settings, please go to the Network-Wireless page."))
end
s:tab("othersetup", translate("Other Settings"))

local e = s:taboption("wansetup", Value, "lan_ipaddr", translate("Lan IPv4 address"))
e.datatype = "ip4addr"

e = s:taboption("wansetup", Value, "lan_netmask", translate("Lan IPv4 netmask"))
e.datatype = "ip4addr"
e:value("255.255.255.0")
e:value("255.255.0.0")
e:value("255.0.0.0")

e = s:taboption("wansetup", Flag, "ipv6",translate('Disable IPv6'), translate('If it is not selected, IPv6 will be enabled, if it is selected, IPv6 will be disabled'))

e = s:taboption("wansetup", ListValue, "wan_proto", translate("Network protocol mode selection"), translate("Four different ways to access the Internet, please choose according to your own situation.</br>"))
e:value("dhcp", translate("DHCP client"))
e:value("static", translate("Static address"))
e:value("pppoe", translate("PPPoE"))
e:value("siderouter", translate("SideRouter"))

e = s:taboption("wansetup", Value, "wan_pppoe_user", translate("PAP/CHAP username"))
e:depends({wan_proto="pppoe"})

e = s:taboption("wansetup", Value, "wan_pppoe_pass", translate("PAP/CHAP password"))
e:depends({wan_proto="pppoe"})
e.password = true

e = s:taboption("wansetup", Value, "wan_ipaddr", translate("Wan IPv4 address"))
e:depends({wan_proto="static"})
e.datatype = "ip4addr"

e = s:taboption("wansetup", Value, "wan_netmask", translate("Wan IPv4 netmask"))
e:depends({wan_proto="static"})
e.datatype = "ip4addr"
e:value("255.255.255.0")
e:value("255.255.0.0")
e:value("255.0.0.0")

e = s:taboption("wansetup", Value, "wan_gateway", translate("Wan IPv4 gateway"))
e:depends({wan_proto="static"})
e.datatype = "ip4addr"

e = s:taboption("wansetup", DynamicList, "wan_dns", translate("Use custom Wan DNS"))
e:depends({wan_proto="dhcp"})
e:depends({wan_proto="static"})
e.datatype = "ip4addr"
e.cast = "string"

e = s:taboption("wansetup", Value, "lan_gateway", translate("Lan IPv4 gateway"), translate( "Please enter the primary routing IP address. The next routing gateway and the next routing IP must be a network segment"))
e:depends({wan_proto="siderouter"})
e.datatype = "ip4addr"

e = s:taboption("wansetup", DynamicList, "lan_dns", translate("Use custom Siderouter DNS"))
e:depends({wan_proto="siderouter"})
e.placeholder = "223.5.5.5"
e.datatype = "ip4addr"
e.cast = "string"

e = s:taboption("wansetup", Flag, "lan_dhcp", translate("Enable DHCP Server"), translate("If not selected, DHCP is disabled by default. If DHCP is used, the main route DHCP needs to be turned off. To disable DHCP, you need to manually change all Internet device gateways and DNS to this routing IP"))
e:depends({wan_proto="siderouter"})

if has_wifi then
	e = s:taboption("wifisetup", Value, "wifi_ssid", translate("<abbr title=\"Extended Service Set Identifier\">ESSID</abbr>"))
	e.datatype = "maxlength(32)"

	e = s:taboption("wifisetup", Value, "wifi_key", translate("Key"))
	e.datatype = "wpakey"
	e.password = true
end --has_wifi

e = s:taboption("othersetup", Flag, "display",translate('Disable Wizard'), translate('Enable/Disable boot entry Wizard'))


return m
