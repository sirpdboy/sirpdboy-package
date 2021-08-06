module("luci.controller.adblock",package.seeall)
function index()
	if not nixio.fs.access("/etc/config/adblock") then
		return
	end
	local e=entry({"admin","services","adblock"},firstchild(),_("Adblock plus+"),11)
	e.dependent=false
	e.acl_depends={"luci-app-adblock-plus"}
	entry({"admin","services","adblock","base"},cbi("adblock/base"),_("Base Setting"),1).leaf=true
	entry({"admin","services","adblock","white"},form("adblock/white"),_("White Domain List"),2).leaf=true
	entry({"admin","services","adblock","black"},form("adblock/black"),_("Block Domain List"),3).leaf=true
	entry({"admin","services","adblock","ip"},form("adblock/ip"),_("Block IP List"),4).leaf=true
	entry({"admin","services","adblock","log"},form("adblock/log"),_("Update Log"),5).leaf=true
	entry({"admin","services","adblock","run"},call("act_status"))
	entry({"admin","services","adblock","refresh"},call("refresh_data"))
end

function act_status()
	local e={}
	e.running=luci.sys.call("[ -s /tmp/dnsmasq.adblock/adblock.conf ]")==0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

function refresh_data()
local set=luci.http.formvalue("set")
local icount=0

if set=="0" then
	sret=luci.sys.call("curl -Lfso /tmp/adnew.conf https://cdn.jsdelivr.net/gh/small-5/ad-rules/easylistchina+easylist.txt || curl -Lfso /tmp/adnew.conf https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt")
	if sret==0 then
		luci.sys.call("/usr/share/adblock/adblock gen")
		icount=luci.sys.exec("cat /tmp/ad.conf | wc -l")
		if tonumber(icount)>0 then
			oldcount=luci.sys.exec("cat /tmp/adblock/adblock.conf | wc -l")
			if tonumber(icount) ~= tonumber(oldcount) then
				luci.sys.exec("mv -f /tmp/ad.conf /tmp/adblock/adblock.conf")
				luci.sys.exec("/etc/init.d/dnsmasq restart &")
				retstring=tostring(math.ceil(tonumber(icount)))
			else
				retstring=0
			end
			luci.sys.call("echo `date +'%Y-%m-%d %H:%M:%S'` > /tmp/adblock/adblock.updated")
		else
			retstring="-1"
		end
		luci.sys.exec("rm -f /tmp/ad.conf")
	else
		retstring="-1"
	end
else
	luci.sys.exec("/usr/share/adblock/adblock down")
	icount=luci.sys.exec("find /tmp/ad_tmp/3rd -name 3* -exec cat {} \\; 2>/dev/null | wc -l")
	if tonumber(icount)>0 then
		oldcount=luci.sys.exec("find /tmp/adblock/3rd -name 3* -exec cat {} \\; 2>/dev/null | wc -l")
		if tonumber(icount) ~= tonumber(oldcount) then
			luci.sys.exec("[ -h /tmp/adblock/3rd/url ] && (rm -f /etc/adblock/3rd/*;cp -a /tmp/ad_tmp/3rd /etc/adblock) || (rm -f /tmp/adblock/3rd/*;cp -a /tmp/ad_tmp/3rd /tmp/adblock)")
			luci.sys.exec("/etc/init.d/adblock restart &")
			retstring=tostring(math.ceil(tonumber(icount)))
		else
			retstring=0
		end
		luci.sys.call("echo `date +'%Y-%m-%d %H:%M:%S'` > /tmp/adblock/adblock.updated")
	else
		retstring="-1"
	end
	luci.sys.exec("rm -rf /tmp/ad_tmp")
end
	luci.http.prepare_content("application/json")
	luci.http.write_json({ret=retstring,retcount=icount})
end
