local t,a,e
local n=require"nixio.fs"
local o=require"luci.util"
local i=require"luci.model.uci".cursor()
if i:get("aria2","main","Pro")then
config_dir=i:get("aria2","main","Pro")or""
else
config_dir=i:get("aria2","main","config_dir")or""
end
local s="%s/aria2.conf.main"%config_dir
local h="%s/aria2.session"%config_dir
local i="/etc/config/aria2"%config_dir
t=SimpleForm("aria2","%s - %s"%{translate("Aria2"),translate("Files")},
translate("Here shows the files used by aria2."))
t.reset=false
t.submit=false
a=t:section(SimpleSection,nil,translatef("在<code>%s</code>下的config文件内容",i))
e=a:option(TextValue,"_session")
e.rows=20
e.readonly=true
e.cfgvalue=function()
local e=n.readfile(i)or translate("File does not exist.")
return o.trim(e)~=""and e or translate("Empty file.")
end
a=t:section(SimpleSection,nil,translatef("在<code>%s</code>下的config文件内容",s))
e=a:option(TextValue,"_config")
e.rows=20
e.readonly=true
e.cfgvalue=function()
local e=n.readfile(s)or translate("File does not exist.")
return o.trim(e)~=""and e or translate("Empty file.")
end
a=t:section(SimpleSection,nil,translatef("在<code>%s</code>下的session文件内容",h))
e=a:option(TextValue,"_session")
e.rows=20
e.readonly=true
e.cfgvalue=function()
local e=n.readfile(h)or translate("File does not exist.")
return o.trim(e)~=""and e or translate("Empty file.")
end
return t
