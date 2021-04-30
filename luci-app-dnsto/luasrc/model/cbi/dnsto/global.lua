local e=require"nixio.fs"
local e=luci.http
local a,t,e

if luci.sys.call("pgrep -f ddnsto >/dev/null") == 0 then
	status = translate("<strong><font color=\"green\">ddnsto 服务端运行中</font></strong>")
else
	status = translate("<strong><font color=\"red\">ddnsto 服务端已停止</font></strong>")
end

a=Map("ddnsto",translate("ddnsto内网穿透"))
a.description=translate("ddnsto是支持http2的快速远程路由工具。</br>你需要先到 https://www.ddnsto.com/app/#/weixinlogin注册，然后在本插件内填入Token，再登录 https://www.ddnsto.com/app/#/weixinlogin设置穿透。")

t = a:section(TypedSection, "global", translate(''))
t.anonymous = true
t.description = translate(string.format("%s<br />", status))

t=a:section(TypedSection,"global",translate("全局设置"),translate("设置教程:</font><a style=\"color: #ff0000;\" onclick=\"window.open('https://www.ddnsto.com/zh/guide/koolshare_merlin.html')\">点击跳转官网教程</a>"))
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
