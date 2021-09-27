--[[
	QQ:183130227
	http://bbs.scjxsw.com
]]--

local sys = require "luci.sys"
local fs = require "nixio.fs"
local uci = require "luci.model.uci".cursor()
local wan_ifname = luci.util.exec("uci get network.wan.ifname")
local lan_ifname = luci.util.exec("uci get network.lan.ifname")
m = Map("wifidog", "认证设置",
	translate("KOS认证参数配置，服务器后台登陆<a href=\"http://wifi.scjxsw.com\" target=\"_blank\">  点击进入>></a>"))

if fs.access("/usr/bin/wifidog") then
	s = m:section(TypedSection, "wifidog", "web认证配置")
	s.anonymous = true
	s.addremove = false
	s:tab("jbsz", translate("基本设置"))
	s:tab("bmd", translate("白名单"))
	s:tab("qos", translate("速度限制"))
	s:tab("wpa2", translate("无线密码同步"))
	s:tab("gjsz", translate("高级设置"))
	
	wifidog_enable = s:taboption("jbsz",Flag, "wifidog_enable", 
	translate("启用认证"),
	translate("打开或关闭认证"))
	--wifi_enable.default = wifi_enable.enable
	--wifi_enable.optional = true
	wifidog_enable.rmempty=false
	deamo_enable = s:taboption("jbsz",Flag, "deamo_enable", translate("守护进程"),"开启监护认证进程，保证认证进程时时在线")
	deamo_enable:depends("wifidog_enable","1")	
	ssl_enable = s:taboption("gjsz",Flag, "ssl_enable", translate("加密传输"),"启用安全套接层协议传输，提高网络传输安全")
	sslport = s:taboption("gjsz",Value,"sslport","SSL传输端口号","默认443")
	sslport:depends("ssl_enable","1")
	gatewayID = s:taboption("jbsz",Value,"gateway_id","AP编码","此处填写认证服务器端生成的AP编码")
	gateway_interface = s:taboption("gjsz",Value,"gateway_interface","内网接口","设置内网接口，默认'br-lan'。")
	gateway_interface.default = "br-lan"
	gateway_interface:value(wan_ifname,wan_ifname .."" )
	gateway_interface:value(lan_ifname,lan_ifname .. "")
	
	gateway_eninterface = s:taboption("gjsz",Value,"gateway_eninterface","外网接口","此处设置认证服务器的外网接口一般默认即可")
	gateway_eninterface.default = wan_ifname
	gateway_eninterface:value(wan_ifname,wan_ifname .."")
	gateway_eninterface:value(lan_ifname,lan_ifname .. "")

for _, e in ipairs(sys.net.devices()) do
	if e ~= "lo" then gateway_interface:value(e) end
	if e ~= "lo" then gateway_eninterface:value(e) end
end
	
	gateway_hostname = s:taboption("jbsz",Value,"gateway_hostname","认证服务器地址","域名或者IP地址")
	gatewayport = s:taboption("gjsz",Value,"gatewayport","认证网关端口号","默认端口号2060")
	gateway_httpport = s:taboption("gjsz",Value,"gateway_httpport","HTTP端口号","默认80端口")
	gateway_path = s:taboption("gjsz",Value,"gateway_path","认证服务器路径","最后要加/，例如：'/'，'/wifidog/'")
	gateway_connmax = s:taboption("gjsz",Value,"gateway_connmax","最大用户接入数量","以路由器性能而定，默认50")
	gateway_connmax.default = "50"
	check_interval = s:taboption("gjsz",Value,"check_interval","检查间隔","接入客户端在线检测间隔，默认60秒")
	check_interval.default = "60"
	client_timeout = s:taboption("gjsz",Value,"client_timeout","客户端超时","接入客户端认证超时，默认5分")
	client_timeout.default = "5"
							--[白名单]--
    bmd_url=s:taboption("bmd",Value,"bmd_url","网站URL白名单","编辑框内的url网址不认证也能打开，不能带”http://“多个URL请用”,“号隔开。如：“www.baidu.com,www.qq.com”")
	bmd_url.placeholder = "www.baidu.com,www.qq.com,www.163.com"
	myz_mac=s:taboption("bmd",Value,"myz_mac","免认证设备","填入设备的MAC地址，多个设备请用“,”号隔开。如：“11:22:33:44:55:66,aa:bb:cc:dd:ff:00”")
	myz_mac.placeholder = "00:11:22:33:44:55,AA:BB:CC:DD:EE:FF"
	--[智能QOS]--
	qos_enable = s:taboption("qos",Flag,"qos_enable","启用智能限速")
	sxsd = s:taboption("qos",Value,"sxsd","上行带宽","总的上行带宽，单位Mbit")
	sxsd.default = "1"
	xxsd = s:taboption("qos",Value,"xxsd","下行带宽","总的下行带宽，单位Mbit")
	xxsd.default = "2"
				--[无线密码上传]--
--	wpa2_enable = s:taboption("wpa2",Flag, "wpa2_enable", translate("启用随机密码更新"),"***web认证用户，请勿勾选***")
--	wpa2_time = s:taboption("wpa2",ListValue,"wpa2_time","整点更新","每天指定时间更新wpa2密码")
--	wpa2_time:value("00","0点")
--	wpa2_time:value("01","1点")
--	wpa2_time:value("02","2点")
--	wpa2_time:value("03","3点")
--	wpa2_time:value("04","4点")
--	wpa2_time:value("05","5点")
--	wpa2_time:value("06","6点")
--	wpa2_time:value("07","7点")
--	wpa2_time:value("08","8点")
--	wpa2_time:value("09","9点")
--	wpa2_time:value("10","10点")
--	wpa2_time:value("11","11点")
--	wpa2_time:value("12","12点")
--	wpa2_time:value("13","13点")
--	wpa2_time:value("14","14点")
--	wpa2_time:value("15","15点")
--	wpa2_time:value("16","16点")
--	wpa2_time:value("17","17点")
--	wpa2_time:value("18","18点")
--	wpa2_time:value("19","19点")
--	wpa2_time:value("20","20点")
--	wpa2_time:value("21","21点")
--	wpa2_time:value("22","22点")
--	wpa2_time:value("23","23点")
--	ssid_w = s:taboption("wpa2",Value,"ssid_w","无线SSID修改","SSID支持中文")
--	ssid_w.placeholder = "KOS"
--	ssid_w.default = "KOS"
--	fwqdz = s:taboption("wpa2", Value, "fwqdz", translate("服务器路径"),"数据接收服务器路径！如/wpa/date")
--	fwqdz.placeholder = "/update"
--	fwqdz.default = "/update"
--	wpa_jm = s:taboption("wpa2", ListValue, "wpa_jm", translate("加密方式"))
--	wpa_jm:value("none","不加密")
--	wpa_jm:value("psk","wap加密")
--	wpa_jm:value("psk2","wpa2加密")
--	wpa_mm = s:taboption("wpa2",Value,"wpa_mm","无线密码前缀","最少三个字符，最多5个字符")
--	wpa_mm.default = "kos"
--	wpa_mm:depends({wpa_jm="psk"}) 
--	wpa_mm:depends({wpa_jm="psk2"}) 
	
else
	m.pageaction = false
end


return m



