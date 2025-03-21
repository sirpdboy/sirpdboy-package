local fs = require "nixio.fs"

m = Map("vhusbd", translate("VirtualHere USB Server"), translatef(
            "可把网络设备上的USB设备映射到本地主机。启用后到 http://www.virtualhere.com/usb_client_software 下载对应构架的客户端到本地主机运行。<br />注册(x86无效)：在客户端的USB共享器上右键-设备信息-输入许可码(xxxxxxxxxxxx为设备信息中的s/n)：xxxxxxxxxxxx,999,MCACDkn0jww6R5WOIjFqU/apAg4Um+mDkU2TBcC7fA1FrA=="))

-- Basic config
m:section(SimpleSection).template = "vhusbd/status"

-- vhusbd
s = m:section(TypedSection, "vhusbd", translate("Settings"))
s.anonymous = true

switch = s:option(Flag, "enabled", translate("Enable"))
switch.rmempty = false

Access = s:option(Flag, "ExtAccess", translate("外网访问"))
Access.rmempty = false

return m

