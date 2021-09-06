a=Map("zerotier",translate("ZeroTier"),translate("ZeroTier is an open source,cross-platform and easy to use virtual LAN"))
a:section(SimpleSection).template="zerotier/zerotier_status"

t=a:section(NamedSection,"sample_config","zerotier")
t.anonymous=true
t.addremove=false

e=t:option(Flag,"enable",translate("Enable"))

e=t:option(DynamicList,"join",translate('ZeroTier Network ID'))

e=t:option(Flag,"nat",translate("Auto NAT Clients"))
e.description=translate("Allow ZeroTier clients access your LAN network")

e=t:option(DummyValue,"opennewwindow",translate("<input type=\"button\" class=\"cbi-button cbi-button-apply\" value=\"Zerotier.com\" onclick=\"window.open('https://my.zerotier.com/network')\" />"))
e.description=translate("Create or manage your ZeroTier network, and auth clients who could access")

return a
