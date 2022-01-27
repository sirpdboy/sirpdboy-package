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

s=a:section(TypedSection, "ddnsto", translate("设置"))
s.addremove=false
s.anonymous=true

s:option(Flag, "enable", translate("Enable")).rmempty=false

s:option(Value, "token", translate("Token")).rmempty=false
return a
