-- Licensed to the public under the Apache License 2.0.

m = Map("samba4", translate("Network Shares Samba4"))

s = m:section(TypedSection, "samba", "Samba4")
s.anonymous = true

s:tab("general",  translate("General Settings"))
s:tab("template", translate("Edit Template"))

--o=s:taboption("general",NetworkSelect,'interface', translate('Interface'),translate('Listen only on the given interface or, if unspecified, on lan'))

o=s:taboption("general", Value, "workgroup", translate("Workgroup"))
o.placeholder = 'WORKGROUP'

o=s:taboption("general", Value, "description", translate("Description"))
o.placeholder = 'Samba4 on OpenWrt'

br = s:taboption("general", Flag, 'disable_async_io', translate('Force synchronous  I/O'),
			translate('On lower-end devices may increase speeds, by forceing synchronous I/O instead of the default asynchronous.'))

br = s:taboption("general", Flag,  'allow_legacy_protocols', translate('Allow legacy (insecure) protocols/authentication.'),
			translate('Allow legacy smb(v1)/Lanman connections, needed for older devices without smb(v2.1/3) support.'))
br.rmempty = false
br.enabled = "yes"
br.disabled = "no"
br.default = "yes"

macos = s:taboption("general", Flag, "macos", translate("Enable macOS compatible shares"),
	translate("Enables Apple's AAPL extension globally and adds macOS compatibility options to all shares."))
macos.rmempty = false

if nixio.fs.access("/usr/sbin/nmbd") then
	s:taboption("general", Flag, "disable_netbios", translate("Disable Netbios"))
end
if nixio.fs.access("/usr/sbin/samba") then
	s:taboption("general", Flag, "disable_ad_dc", translate("Disable Active Directory Domain Controller"))
end
if nixio.fs.access("/usr/sbin/winbindd") then
	s:taboption("general", Flag, "disable_winbind", translate("Disable Winbind"))
end

h = s:taboption("general", Flag,  'enable_extra_tuning', translate('Enable extra Tuning'),
			translate('Enable some community driven tuning parameters, that may improve write speeds and better operation via WiFi.\
			Not recommend if multiple clients write to the same files, at the same time!'))

tmpl = s:taboption("template", Value, "_tmpl",
	translate("Edit the template that is used for generating the samba configuration."), 
	translate("This is the content of the file '/etc/samba/smb.conf.template' from which your samba configuration will be generated. " ..
		"Values enclosed by pipe symbols ('|') should not be changed. They get their values from the 'General Settings' tab."))

tmpl.template = "cbi/tvalue"
tmpl.rows = 20

function tmpl.cfgvalue(self, section)
	return nixio.fs.readfile("/etc/samba/smb.conf.template")
end

function tmpl.write(self, section, value)
	value = value:gsub("\r\n?", "\n")
	nixio.fs.writefile("/etc/samba/smb.conf.template", value)
end

a = s:taboption("general", Flag, "autoshare", translate("Auto Share"),
        translate("Auto share local disk which connected"))
a.rmempty = false
a.default = "yes"

s = m:section(TypedSection, "sambashare", translate("Shared Directories")
  , translate("Please add directories to share. Each directory refers to a folder on a mounted device."))
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"

s:option(Value, "name", translate("Name"))
pth = s:option(Value, "path", translate("Path"))
if nixio.fs.access("/etc/config/fstab") then
	pth.titleref = luci.dispatcher.build_url("admin", "system", "fstab")
end

br = s:option(Flag, "browseable", translate("Browse-able"))
br.rmempty = false
br.enabled = "yes"
br.disabled = "no"
br.default = "yes"

ro = s:option(Flag, "read_only", translate("Read-only"))
ro.rmempty = false
ro.enabled = "yes"
ro.disabled = "no"
ro.default = "no"

br=s:option(Flag, "force_root", translate("Force Root"))
br.rmempty = false
br.enabled = "yes"
br.disabled = "no"
br.default = "yes"

au = s:option(Value, "users", translate("Allowed users"))
au.rmempty = true

go = s:option(Flag, "guest_ok", translate("Allow guests"))
go.rmempty = false
go.enabled = "yes"
go.disabled = "no"
go.default = "yes"


gon = s:option(Flag, "guest_only", translate("Guests only"))

gon.enabled = "yes"
gon.disabled = "no"
gon.default = "yes"

iown = s:option(Flag, "inherit_owner", translate("Inherit owner"))

iown.enabled = "yes"
iown.disabled = "no"
iown.default = "yes"

cm = s:option(Value, "create_mask", translate("Create mask"))
cm.rmempty = false
cm.maxlength = 4
cm.default = "0666"
cm.placeholder = "0666"


dm = s:option(Value, "dir_mask", translate("Directory mask"))
dm.rmempty = false
dm.maxlength = 4
dm.default = "0777"
dm.placeholder = "0777"

vfs = s:option(Value, "vfs_objects", translate("Vfs objects"))
vfs.rmempty = true

s:option(Flag, "timemachine", translate("Apple Time-machine share"))

tms = s:option(Value, "timemachine_maxsize", translate("Time-machine size in GB"))
tms.rmempty = true
tms.maxlength = 5

local e=luci.http.formvalue("cbi.apply")
if e then
  luci.sys.call("/etc/init.d/samba4 restart")
end
return m
