local m, s
local uci = luci.model.uci.cursor()
local sys = require 'luci.sys'

m = Map("homeassistant", translate("HomeAssistant"), translate("Open source home automation that puts local control and privacy first. Powered by a worldwide community of tinkerers and DIY enthusiasts.")
.. translatef("For further information "
.. "<a href=\"%s\" target=\"_blank\">"
.. "访问官网</a>", "https://www.home-assistant.io/"))

-- s = m:section(TypedSection, 'MySection', translate('基本设置'))
-- s.anonymous = true
-- o = s:option(DummyValue, '', '')
-- o.rawhtml = true
-- o.version = sys.exec('uci get jd-dailybonus.@global[0].version')
-- o.template = 'jellyfin/service'

m:section(SimpleSection).template  = "homeassistant/homeassistant"

-- s=m:section(TypedSection, "linkease", translate("Global settings"))
-- s.anonymous=true

-- s:option(Flag, "enabled", translate("Enable")).rmempty=false

-- s:option(Value, "port", translate("Port")).rmempty=false
return m
