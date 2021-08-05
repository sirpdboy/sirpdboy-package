local SYS=require "luci.sys"

m=Map("adblock")
m.title=translate("Adblock Plus+")
m.description=translate("Support AdGuardHome/Host/DNSMASQ Rules")
m:section(SimpleSection).template="adblock/adblock_status"

s=m:section(TypedSection,"adblock")
s.anonymous=true

o=s:option(Flag,"enable")
o.title=translate("Enable")
o.rmempty=false

o=s:option(Flag,"block_ios")
o.title=translate("Block Apple iOS OTA update")

o=s:option(Flag,"block_cnshort")
o.title=translate("Block CNshort APP and Website")

o=s:option(Flag,"cron_mode")
o.title=translate("Enable automatic update rules")

o=s:option(ListValue,"time_update")
o.title=translate("Update time")
for s=0,23 do
o:value(s)
end
o.default=6
o:depends("cron_mode",1)

if nixio.fs.access("/tmp/adblock/adblock.conf") then
UD=SYS.exec("cat /tmp/adblock/adblock.updated 2>/dev/null")
ad_count=tonumber(SYS.exec("cat /tmp/adblock/adblock.conf | wc -l"))
o=s:option(DummyValue,"0",translate("Adblock Plus Data"))
o.rawhtml=true
o.template="adblock/refresh"
o.value=ad_count.." "..translate("Records")
o.description=string.format("<strong>"..translate("Last Update Checked")..":</strong> %s<br/>",UD)
end

tmp_rule=0
if nixio.fs.access("/tmp/adblock/3rd/3rd.conf") then
tmp_rule=1
rule_count=tonumber(SYS.exec("find /tmp/adblock/3rd -name 3* -exec cat {} \\; 2>/dev/null | wc -l"))
o=s:option(DummyValue,"1",translate("Subscribe 3rd Rules Data"))
o.rawhtml=true
o.template="adblock/refresh"
o.value=rule_count.." "..translate("Records")
o.description=translate("AdGuardHome / Host / DNSMASQ rules auto-convert<br/>Automatically remove duplicate rules(including Adblock Plus Rules)")
end

o=s:option(Flag,"flash")
o.title=translate("Save 3rd rules to flash")
o.description=translate("Should be enabled when 3rd rules addresses are slow to download")
o.rmempty=false

if tmp_rule==1 then
o=s:option(Button,"delete",translate("Delete All Subscribe Rules"))
o.inputstyle="reset"
o.description=translate("Delete 3rd rules files and delete the subscription link<br/>There is no need to click for modify the subscription link,The script will automatically replace the old rule file")
o.write=function()
	SYS.exec("[ -d /etc/adblock/3rd ] && rm -rf /etc/adblock/3rd")
	SYS.exec("grep -wq 'list url' /etc/config/adblock && sed -i '/list url/d' /etc/config/adblock && /etc/init.d/adblock restart 2>&1 &")
	luci.http.redirect(luci.dispatcher.build_url("admin","services","adblock","base"))
end
end

if luci.sys.call("[ -h /tmp/adblock/3rd/url ] || exit 9")==9 then
	if nixio.fs.access("/etc/adblock/3rd") then
		o=s:option(Button,"delete_1",translate("Delete Subscribe Rules On The Flash"))
		o.inputstyle="reset"
		o.write=function()
			SYS.exec("rm -rf /etc/adblock/3rd")
			luci.http.redirect(luci.dispatcher.build_url("admin","services","adblock","base"))
		end
	end
end

o=s:option(DynamicList,"url",translate("Anti-AD Rules Subscribe"))
o:value("https://cdn.jsdelivr.net/gh/privacy-protection-tools/anti-AD@master/adblock-for-dnsmasq.conf","anti-AD")
o:value("https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt","AdGuard")
o:value("https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt","Easylistchina+Easylist")
o:value("https://block.energized.pro/extensions/porn-lite/formats/domains.txt","Anti-Porn")

return m
