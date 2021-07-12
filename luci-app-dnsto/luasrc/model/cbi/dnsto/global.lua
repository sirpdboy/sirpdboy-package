local e=require"nixio.fs"
local e=luci.http
local a,t,e

if luci.sys.call("pgrep -f ddnsto >/dev/null") == 0 then
	status = translate("<strong><font color=\"green\">ddnsto 服务端运行中</font></strong>")
else
	status = translate("<strong><font color=\"red\">ddnsto 服务端已停止</font></strong>")
end

a=Map("ddnsto",translate("DDNSTO 内网穿透"))
a.description = translate("DDNSTO是收费的快速远程穿透的工具。") .. 
translate("<br><br><input class=\"cbi-button cbi-button-apply\" type=\"button\" value=\"" .. 
translate("注册与教程") ..
"\" onclick=\"window.open('https://www.ddnsto.com')\"/>") ..
"<br><br><b>" .. translate("运行状态：") .. status .. "</b>"

t=a:section(TypedSection,"global",translate("设置"))
t.anonymous=true
t.addremove=false
e=t:option(Flag,"enable",translate("启用"))
e.default=0
e.rmempty=false
e=t:option(Value,"start_delay",translate("延迟启动"),translate("单位：秒"))
e.datatype="uinteger"
e.default="0"
e.rmempty=true
e=t:option(Value,"token",translate('ddnsto 令牌'))
e.password=true
e.rmempty=false
if nixio.fs.access("/etc/config/ddnsto")then
e=t:option(Button,"Configuration",translate("域名配置管理"))
e.inputtitle=translate("打开网站")
e.inputstyle="reload"
e.write=function()
luci.http.redirect("https://www.ddnsto.com/app/#/weixinlogin")
end
end
return a
