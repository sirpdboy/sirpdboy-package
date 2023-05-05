-- Copyright 2019 X-WRT <dev@x-wrt.com>
-- Copyright 2022 sirpdboy

local net = require "luci.model.network".init()
local sys = require "luci.sys"
local ifaces = sys.net:devices()
local nt = require "luci.sys".net
local uci = require("luci.model.uci").cursor()
local lan_gateway = uci:get("netwizard", "default", "lan_gateway")
if lan_gateway ~= "" then
   lan_gateway = sys.exec("ipaddr=`uci -q get network.lan.ipaddr`;echo ${ipaddr%.*}")
end
local network_info = uci:get_all("network", "wan")
local wizard_info = uci:get_all("netwizard", "default")

local validation = require "luci.cbi.datatypes"

local has_wifi = false
uci:foreach("wireless", "wifi-device",
		function(s)
			has_wifi = true
			return false
		end)

local m = Map("netwizard", luci.util.pcdata(translate("Inital Router Setup")), translate("Quick network setup wizard. If you need more settings, please enter network - interface to set.</br>")..translate("The network card is automatically set, and the physical interfaces other than the specified WAN interface are automatically bound as LAN ports, and all side routes are bound as LAN ports.</br>")..translate("For specific usage, see:")..translate("<a href=\'https://github.com/sirpdboy/luci-app-netwizard.git' target=\'_blank\'>GitHub @sirpdboy/netwizard</a>") )

local s = m:section(TypedSection, "netwizard", "")
s.addremove = false
s.anonymous = true

s:tab("wansetup", translate("Wan Settings"))
if has_wifi then
	s:tab("wifisetup", translate("Wireless Settings"), translate("Set the router's wireless name and password. For more advanced settings, please go to the Network-Wireless page."))
end
s:tab("othersetup", translate("Other setting"))

local e = s:taboption("wansetup", Value, "lan_ipaddr", translate("Lan IPv4 address") ,translate("You must specify the IP address of this machine, which is the IP address of the web access route"))
e.default = "" .. uci:get("network", "lan", "ipaddr")
e.datatype = "ip4addr"

e = s:taboption("wansetup", Value, "lan_netmask", translate("Lan IPv4 netmask"))
e.datatype = "ip4addr"
e:value("255.255.255.0")
e:value("255.255.0.0")
e:value("255.0.0.0")
e.default = '255.255.255.0'

e = s:taboption("wansetup", ListValue, "ipv6",translate('Select IPv6 mode'),translate("Caution: If you delete IPV6 related plug-ins completely, you will not be able to recover"))
e:value('0', translate('Disable IPv6'))
e:value('1', translate('IPv6 Server mode'))
e:value('2', translate('IPv6 Relay mode'))
e:value('3', translate('IPv6 Hybird mode'))
e:value('4', translate('Remove IPv6'))
e.default = '3'

wan_proto = s:taboption("wansetup", ListValue, "wan_proto", translate("Network protocol mode selection"), translate("Four different ways to access the Internet, please choose according to your own situation.</br>"))
wan_proto:value("dhcp", translate("DHCP client"))
wan_proto:value("static", translate("Static address"))
wan_proto:value("pppoe", translate("PPPoE dialing"))
wan_proto:value("siderouter", translate("SideRouter"))

e = s:taboption("wansetup",Value, "wan_interface",translate("interface<font color=\"red\">(*)</font>"), translate("Allocate the physical interface of WAN port"))
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

wan_pppoe_user = s:taboption("wansetup", Value, "wan_pppoe_user", translate("PAP/CHAP username"))
wan_pppoe_user:depends({wan_proto="pppoe"})
if wizard_info.wan_pppoe_user == "" and network_info.username ~= "" then
       wan_pppoe_user.default = network_info.username
end


wan_pppoe_pass = s:taboption("wansetup", Value, "wan_pppoe_pass", translate("PAP/CHAP password"))
wan_pppoe_pass:depends({wan_proto="pppoe"})
if wizard_info.wan_pppoe_pass == "" and network_info.password ~= "" then
      wan_pppoe_pass.default = network_info.password
end
e.password = true

wan_ipaddr = s:taboption("wansetup", Value, "wan_ipaddr", translate("Wan IPv4 address"))
wan_ipaddr:depends({wan_proto="static"})
wan_ipaddr.datatype = "ip4addr"
if wizard_info.wan_ipaddr == "" and network_info.ipaddr ~= ""   then
   wan_ipaddr.default = network_info.ipaddr
end

wan_netmask = s:taboption("wansetup", Value, "wan_netmask", translate("Wan IPv4 netmask"))
wan_netmask:depends({wan_proto="static"})
wan_netmask.datatype = "ip4addr"
wan_netmask:value("255.255.255.0")
wan_netmask:value("255.255.0.0")
wan_netmask:value("255.0.0.0")
wan_netmask.default = "255.255.255.0"



wan_gateway = s:taboption("wansetup", Value, "wan_gateway", translate("Wan IPv4 gateway"))
wan_gateway:depends({wan_proto="static"})
wan_gateway.datatype = "ip4addr"
if wizard_info.wan_gateway == "" and network_info.gateway ~= ""  then
   wan_gateway.default = network_info.gateway
end

wan_dns = s:taboption("wansetup", DynamicList, "wan_dns", translate("Use custom Wan DNS"))
wan_dns:value("223.5.5.5", translate("Ali DNS:223.5.5.5"))
wan_dns:value("180.76.76.76", translate("Baidu dns:180.76.76.76"))
wan_dns:value("114.114.114.114", translate("114 DNS:114.114.114.114"))
wan_dns:value("8.8.8.8", translate("Google DNS:8.8.8.8"))
wan_dns:value("1.1.1.1", translate("Cloudflare DNS:1.1.1.1"))
wan_dns.default = "223.5.5.5"
wan_dns:depends({wan_proto="static"})
wan_dns:depends({wan_proto="pppoe"})
wan_dns.datatype = "ip4addr"
wan_dns.cast = "string"

e = s:taboption("wansetup", Value, "lan_gateway", translate("Lan IPv4 gateway"), translate( "Please enter the main routing IP address. The bypass gateway is not the same as the login IP of this bypass WEB and is in the same network segment"))
e.default = lan_gateway
e:depends({wan_proto = "siderouter"})
e.datatype = "ip4addr"

e = s:taboption("wansetup", DynamicList, "lan_dns", translate("Use custom Siderouter DNS"))
e:value("223.5.5.5", translate("Ali DNS:223.5.5.5"))
e:value("180.76.76.76", translate("Baidu dns:180.76.76.76"))
e:value("114.114.114.114", translate("114 DNS:114.114.114.114"))
e:value("8.8.8.8", translate("Google DNS:8.8.8.8"))
e:value("1.1.1.1", translate("Cloudflare DNS:1.1.1.1"))
e.default = "223.5.5.5"
e:depends({wan_proto="siderouter"})
e.datatype = "ip4addr"
e.cast = "string"

lan_dhcp = s:taboption("wansetup", Flag, "lan_dhcp", translate("Enable DHCP Server"), translate("The default selection is to enable the DHCP server. In a network, only one DHCP server is needed to allocate and manage client IP. If it is a side route, it is recommended to turn off the main routing DHCP server."))
lan_dhcp.default = 1
lan_dhcp.anonymous = false


e = s:taboption("wansetup", Flag, "dnsset", translate("Enable DNS notifications (ipv4/ipv6)"),translate("Force the DNS server in the DHCP server to be specified as the IP for this route"))
e:depends("lan_dhcp", true)

e = s:taboption("wansetup", Value, "dns_tables", translate(" "))
e:value("1", translate("Use local IP for DNS (default)"))
e:value("223.5.5.5", translate("Ali DNS:223.5.5.5"))
e:value("180.76.76.76", translate("Baidu dns:180.76.76.76"))
e:value("114.114.114.114", translate("114 DNS:114.114.114.114"))
e:value("8.8.8.8", translate("Google DNS:8.8.8.8"))
e:value("1.1.1.1", translate("Cloudflare DNS:1.1.1.1"))
e.anonymous = false
e:depends("dnsset", true)
e.default = "1"

lan_snat = s:taboption("wansetup", Flag, "lan_snat", translate("Custom firewall"),translate("Bypass firewall settings, when Xiaomi or Huawei are used as the main router, the WIFI signal cannot be used normally"))
lan_snat:depends({wan_proto="siderouter"})
lan_snat.default = 1
lan_snat.anonymous = false

e = s:taboption("wansetup", Value, "snat_tables", translate(" "))
e:value("iptables -t nat -I POSTROUTING -o br-lan -j MASQUERADE")
e:value("iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE")
e:value("iptables -t nat -I POSTROUTING -o eth1 -j MASQUERADE")
e.default = "iptables -t nat -I POSTROUTING -o br-lan -j MASQUERADE"
e.anonymous = false
e:depends("lan_snat", true)

redirectdns = s:taboption("wansetup", Flag, "redirectdns", translate("Custom firewall"),translate("Use iptables to force all TCP/UDP DNS 53ports in IPV4/IPV6 to be forwarded from this route[Suggest opening]"))
redirectdns:depends({wan_proto="dhcp"})
redirectdns:depends({wan_proto="static"})
redirectdns:depends({wan_proto="pppoe"})
redirectdns.default = 1
redirectdns.anonymous = false

masq = s:taboption("wansetup", Flag, "masq", translate("Enable IP dynamic camouflage"),translate("Enable IP dynamic camouflage when the side routing network is not ideal"))
masq:depends({wan_proto="siderouter"})
masq.default = 1
masq.anonymous = false

if has_wifi then
	e = s:taboption("wifisetup", Value, "wifi_ssid", translate("<abbr title=\"Extended Service Set Identifier\">ESSID</abbr>"))
	e.datatype = "maxlength(32)"
	e = s:taboption("wifisetup", Value, "wifi_key", translate("Key"))
	e.datatype = "wpakey"
	e.password = true
end

synflood = s:taboption("othersetup", Flag, "synflood", translate("Enable SYN-flood defense"),translate("Enable Firewall SYN-flood defense [Suggest opening]"))
synflood.default = 1
synflood.anonymous = false

e = s:taboption("othersetup", Flag, "showhide",translate('Hide Wizard'), translate('Show or hide the setup wizard menu. After hiding, you can open the display wizard menu in [Advanced Settings] [Advanced] or use the 3rd function in the background to restore the wizard and default theme.'))

return m
