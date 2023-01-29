-- Copyright 2019 X-WRT <dev@x-wrt.com>
-- Copyright 2022 sirpdboy

local o = require "luci.sys"
local net = require "luci.model.network".init()
local sys = require "luci.sys"
local ifaces = sys.net:devices()
local nt = require "luci.sys".net
local uci = require("luci.model.uci").cursor()

local has_wifi = false
uci:foreach("wireless", "wifi-device",
		function(s)
			has_wifi = true
			return false
		end)

local m = Map("wizard", luci.util.pcdata(translate("Inital Router Setup")), translate("Quick network setup wizard. If you need more settings, please enter network - interface to set.</br>")..translate("The network card is automatically set, and the physical interfaces other than the specified WAN interface are automatically bound as LAN ports, and all side routes are bound as LAN ports.</br>")..translate("For specific usage, see:")..translate("<a href=\'https://github.com/sirpdboy/luci-app-wizard.git' target=\'_blank\'>GitHub @sirpdboy/luci-app-wizard</a>") )

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
e:value("pppoe", translate("PPPoE dialing"))
e:value("siderouter", translate("SideRouter"))

e = s:taboption("wansetup",Value, "wan_interface",translate("interface<font color=\"red\">(*)</font>"), translate("Allocate the physical interface of WAN port, and the side route can not be selected"))
e:depends({wan_proto="pppoe"})
e:depends({wan_proto="dhcp"})
e:depends({wan_proto="static"})
for _, iface in ipairs(ifaces) do
if not (iface:match("_ifb$") or iface:match("^ifb*")) then
	if ( iface:match("^eth*") or iface:match("^wlan*") or iface:match("^usb*")) then
		local nets = net:get_interface(iface)
		nets = nets and nets:get_networks() or {}
		for k, v in pairs(nets) do
			nets[k] = nets[k].sid
		end
		nets = table.concat(nets, ",")
		e:value(iface, ((#nets > 0) and "%s (%s)" % {iface, nets} or iface))
	end
end
end

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
e:depends({wan_proto="pppoe"})
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

e = s:taboption("wansetup", Flag, "lan_snat", translate("Enable snat forward"), translate("Select to enable dynamic camouflage forwarding,It is enabled when Xiaomi Huawei's primary route cannot be used normally"))
e:depends({wan_proto="siderouter"})

e = s:taboption("wansetup", Flag, "lan_dhcp", translate("Enable DHCP Server"), translate("If not selected, DHCP is disabled by default. If DHCP is used, the main route DHCP needs to be turned off. To disable DHCP, you need to manually change all Internet device gateways and DNS to this routing IP"))
e:depends({wan_proto="siderouter"})

if has_wifi then
	e = s:taboption("wifisetup", Value, "wifi_ssid", translate("<abbr title=\"Extended Service Set Identifier\">ESSID</abbr>"))
	e.datatype = "maxlength(32)"

	e = s:taboption("wifisetup", Value, "wifi_key", translate("Key"))
	e.datatype = "wpakey"
	e.password = true
end

e = s:taboption("othersetup", Flag, "display",translate('Enable Wizard'), translate('Enable/disable the wizard (next login to enter the setup wizard)'))


return m
