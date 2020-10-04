local e=require"nixio.fs"
local t=require"luci.sys"
m=Map("advanced",translate("高级设置"),translate("各类服务配置文档的直接编辑,除非你知道自己在干什么,否则请不要轻易修改这些配置文档，配置不正确可能会导致不能开机等严重错误。"))
s=m:section(TypedSection,"advanced")
s.anonymous=true
if nixio.fs.access("/etc/dnsmasq.conf")then
s:tab("dnsmasqconf",translate("配置dnsmasq"),translate("本页是配置/etc/dnsmasq.conf的文档内容。应用保存后自动重启生效"))
conf=s:taboption("dnsmasqconf",Value,"dnsmasqeditconf",nil,translate("开头的数字符号（＃）或分号的每一行（;）被视为注释；删除（;）启用指定选项。"))
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile("/etc/dnsmasq.conf")or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
e.writefile("/tmp/dnsmasq.conf",t)
if(luci.sys.call("cmp -s /tmp/dnsmasq.conf /etc/dnsmasq.conf")==1)then
e.writefile("/etc/dnsmasq.conf",t)
luci.sys.call("/etc/init.d/dnsmasq restart >/dev/null")
end
e.remove("/tmp/dnsmasq.conf")
end
end
end
if nixio.fs.access("/etc/config/network")then
s:tab("netwrokconf",translate("配置网络"),translate("本页是配置/etc/config/network的文档内容。应用保存后自动重启生效"))
conf=s:taboption("netwrokconf",Value,"netwrokconf",nil,translate("开头的数字符号（＃）或分号的每一行（;）被视为注释；删除（;）启用指定选项。"))
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile("/etc/config/network")or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
e.writefile("/tmp/network",t)
if(luci.sys.call("cmp -s /tmp/network /etc/config/network")==1)then
e.writefile("/etc/config/network",t)
luci.sys.call("/etc/init.d/network restart >/dev/null")
end
e.remove("/tmp/network")
end
end
end
if nixio.fs.access("/etc/hosts")then
s:tab("hostsconf",translate("配置hosts"),translate("本页是配置/etc/hosts的文档内容。应用保存后自动重启生效"))
conf=s:taboption("hostsconf",Value,"hostsconf",nil,translate("开头的数字符号（＃）或分号的每一行（;）被视为注释；删除（;）启用指定选项。"))
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile("/etc/hosts")or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
e.writefile("/tmp/hosts.tmp",t)
if(luci.sys.call("cmp -s /tmp/hosts.tmp /etc/hosts")==1)then
e.writefile("/etc/hosts",t)
luci.sys.call("/etc/init.d/dnsmasq restart >/dev/null")
end
e.remove("/tmp/hosts.tmp")
end
end
end
if nixio.fs.access("/etc/config/dhcp")then
s:tab("dhcpconf",translate("配置DHCP"),translate("本页是配置/etc/config/DHCP的文档内容。应用保存后自动重启生效"))
conf=s:taboption("dhcpconf",Value,"dhcpconf",nil,translate("开头的数字符号（＃）或分号的每一行（;）被视为注释；删除（;）启用指定选项。"))
conf.template="cbi/tvalue"
conf.rows=30
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile("/etc/config/dhcp")or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
e.writefile("/tmp/dhcp",t)
if(luci.sys.call("cmp -s /tmp/dhcp /etc/config/dhcp")==1)then
e.writefile("/etc/config/dhcp",t)
luci.sys.call("/etc/init.d/network restart >/dev/null")
end
e.remove("/tmp/dhcp")
end
end
end
if nixio.fs.access("/etc/config/firewall")then
s:tab("firewallconf",translate("配置防火墙"),translate("本页是配置/etc/config/firewall的文档内容。应用保存后自动重启生效"))
conf=s:taboption("firewallconf",Value,"firewallconf",nil,translate("开头的数字符号（＃）或分号的每一行（;）被视为注释；删除（;）启用指定选项。"))
conf.template="cbi/tvalue"
conf.rows=30
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile("/etc/config/firewall")or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
e.writefile("/tmp/firewall",t)
if(luci.sys.call("cmp -s /tmp/firewall /etc/config/firewall")==1)then
e.writefile("/etc/config/firewall",t)
luci.sys.call("/etc/init.d/firewall restart >/dev/null")
end
e.remove("/tmp/firewall")
end
end
end
if nixio.fs.access("/etc/config/smartdns")then
s:tab("smartdns",translate("配置smartdns"),translate("本页是配置/etc/config/smartdns的文档内容。应用保存后自动重启生效"))
conf=s:taboption("smartdns",Value,"smartdns",nil,translate("开头的数字符号（＃）或分号的每一行（;）被视为注释；删除（;）启用指定选项。"))
conf.template="cbi/tvalue"
conf.rows=30
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile("/etc/config/smartdns")or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
e.writefile("/tmp/smartdns",t)
if(luci.sys.call("cmp -s /tmp/smartdns /etc/config/smartdns")==1)then
e.writefile("/etc/config/smartdns",t)
luci.sys.call("/etc/init.d/smartdns restart >/dev/null")
end
e.remove("/tmp/smartdns")
end
end
end
if nixio.fs.access("/etc/config/openclash")then
s:tab("openclash",translate("配置openclash"),translate("本页是配置/etc/config/openclash的文档内容。应用保存后自动重启生效"))
conf=s:taboption("openclash",Value,"openclash",nil,translate("开头的数字符号（＃）或分号的每一行（;）被视为注释；删除（;）启用指定选项。"))
conf.template="cbi/tvalue"
conf.rows=30
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile("/etc/config/openclash")or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
e.writefile("/tmp/openclash",t)
if(luci.sys.call("cmp -s /tmp/openclash /etc/config/openclash")==1)then
e.writefile("/etc/config/openclash",t)
luci.sys.call("/etc/init.d/openclash restart >/dev/null")
end
e.remove("/tmp/openclash")
end
end
end
if nixio.fs.access("/etc/config/AdGuardHome")then
s:tab("AdGuardHome",translate("配置AdGuardHome"),translate("本页是配置/etc/config/AdGuardHome的文档内容。应用保存后自动重启生效"))
conf=s:taboption("AdGuardHome",Value,"AdGuardHome",nil,translate("开头的数字符号（＃）或分号的每一行（;）被视为注释；删除（;）启用指定选项。"))
conf.template="cbi/tvalue"
conf.rows=30
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile("/etc/config/AdGuardHome")or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
e.writefile("/tmp/AdGuardHome",t)
if(luci.sys.call("cmp -s /tmp/AdGuardHome /etc/config/AdGuardHome")==1)then
e.writefile("/etc/config/AdGuardHome",t)
luci.sys.call("/etc/init.d/AdGuardHome restart >/dev/null")
end
e.remove("/tmp/AdGuardHome")
end
end
end
if nixio.fs.access("/etc/pcap-dnsproxy/Config.conf")then
s:tab("pcapconf",translate("配置pcap-dnsproxy"),translate("本页是配置/etc/pcap-dnsproxy/Config.conf的文档内容。应用保存后自动重启生效"))
conf=s:taboption("pcapconf",Value,"pcapconf",nil,translate("开头的数字符号（＃）或分号的每一行（;）被视为注释；删除（;）启用指定选项。"))
conf.template="cbi/tvalue"
conf.rows=30
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile("/etc/pcap-dnsproxy/Config.conf")or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
e.writefile("/tmp/Config.conf",t)
if(luci.sys.call("cmp -s /tmp/Config.conf /etc/pcap-dnsproxy/Config.conf")==1)then
e.writefile("/etc/pcap-dnsproxy/Config.conf",t)
luci.sys.call("/etc/init.d/pcap-dnsproxy restart >/dev/null")
end
e.remove("/tmp/Config.conf")
end
end
end
if nixio.fs.access("/etc/wifidog.conf")then
s:tab("wifidogconf",translate("配置wifidog"),translate("本页是配置/etc/wifidog.conf的文档内容。应用保存后自动重启生效"))
conf=s:taboption("wifidogconf",Value,"wifidogconf",nil,translate("开头的数字符号（＃）或分号的每一行（;）被视为注释；删除（;）启用指定选项。"))
conf.template="cbi/tvalue"
conf.rows=30
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile("/etc/wifidog.conf")or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
e.writefile("/tmp/wifidog.conf",t)
if(luci.sys.call("cmp -s /tmp/wifidog.conf /etc/wifidog.conf")==1)then
e.writefile("/etc/wifidog.conf",t)
end
e.remove("/tmp/wifidog.conf")
end
end
end
if nixio.fs.access("/bin/nuc")then
s:tab("mode",translate("模式切换"),translate("<br />可以在这里切换NUC和正常模式，重置你的网络设置。<br /><font color=\"Red\"><strong>点击后会立即重启设备，没有确认过程，请谨慎操作！</strong></font><br/>"))
o=s:taboption("mode",Button,"nucmode",translate("切换为NUC模式"),"<strong><font color=\"green\">本模式适合于单网口主机，如NUC、单网口电脑，需要配合VLAN交换机使用！<br />设置教程：</font><a style=\"color: #ff0000;\" href=\"https://koolshare.cn/thread-166161-1-1.html\">跳转链接到Koolshare论坛教程贴</a></strong>")
o.inputtitle=translate("NUC模式")
o.inputstyle="reload"
o.write=function()
luci.sys.call("/bin/nuc")
end
o=s:taboption("mode",Button,"normalmode",translate("切换成正常模式"),"<strong><font color=\"green\">本模式适合于有两个网口或以上的设备使用，如多网口软路由或者虚拟了两个以上网口的虚拟机使用！</font></strong>")
o.inputtitle=translate("正常模式")
o.inputstyle="reload"
o.write=function()
luci.sys.call("/bin/normalmode")
end
end
return m
