
local fs = require "nixio.fs"
local uci=luci.model.uci.cursor()
local a, t, e
a = Map("advancedplus")
a.title = translate("Advanced Setting")
a.description = translate("The enhanced version of the original advanced settings allows for unified setting and management of background images for kucat, Agron, and Opentopd themes, without the need to upload them separately. Color schemes for kucat and Agron themes can be set.<br>")..
translate("At the same time, important plugin parameters can be compiled. At the same time, some system parameters can also be set, such as display and hide settings.")..
translate("</br>For specific usage, see:")..translate("<a href=\'https://github.com/sirpdboy/luci-app-advancedplus.git' target=\'_blank\'>GitHub @sirpdboy/luci-app-advancedplus </a>")

t = a:section(TypedSection, "basic", translate("Settings"))
t.anonymous = true
e = t:option(Flag, "qos",translate('Qos automatic optimization'), translate('Enable QOS automatic optimization strategy (testing function)'))
e.default = "0"
e.rmempty = false

dl = t:option(Value, "download", translate("Download bandwidth(Mbit/s)"))
dl.default = '200'
dl:depends("qos", true)

ul = t:option(Value, "upload", translate("Upload bandwidth(Mbit/s)"))
ul.default = '30'
ul:depends("qos", true)

e = t:option(Flag, "uhttps",translate('Accessing using HTTPS'), translate('Open the address in the background and use HTTPS for secure access'))

e = t:option(Flag, "usshmenu",translate('No backend menu required'), translate('OPENWRT backend and SSH login do not display shortcut menus'))

e = t:option(Flag, "wizard",translate('Hide Wizard'), translate('Show or hide the setup wizard menu'))
e.default = "0"
e.rmempty = false


return a
