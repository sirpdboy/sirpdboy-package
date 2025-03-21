m = Map("fancontrol", translate("风扇控制"))

-- Common settings section
s = m:section(TypedSection, "common", translate("通用设置"))
s.addremove = false
s.anonymous = true

interval = s:option(Value, "interval", translate("间隔 (秒)"))
interval.datatype = "uinteger"
interval.default = 10

disabled = s:option(Flag, "disabled", translate("禁用"))
disabled.default = 0
disabled.rmempty = false

-- Device section template
d = m:section(TypedSection, "device", translate("设备"))
d.addremove = true
d.anonymous = true
d.template = "cbi/tblsection"

name = d:option(Value, "name", translate("名称"))
name.datatype = "string"

path = d:option(Value, "path", translate("路径"))
path.datatype = "string"

-- Control section template
c = m:section(TypedSection, "control", translate("控制设置"))
c.addremove = true
c.anonymous = true
c.template = "cbi/tblsection"

pwm = c:option(Value, "pwm", translate("PWM 输出"))
pwm.datatype = "string"

temp = c:option(Value, "temp", translate("温度输入"))
temp.datatype = "string"

min_temp = c:option(Value, "min_temp", translate("最小温度"))
min_temp.datatype = "uinteger"
min_temp.default = 50

max_temp = c:option(Value, "max_temp", translate("最大温度"))
max_temp.datatype = "uinteger"
max_temp.default = 60

min_start = c:option(Value, "min_start", translate("最小启动 PWM"))
min_start.datatype = "uinteger"
min_start.default = 150

min_stop = c:option(Value, "min_stop", translate("最小停止 PWM"))
min_stop.datatype = "uinteger"
min_stop.default = 100

fan = c:option(Value, "fan", translate("风扇速度输入 (可选)"))
fan.datatype = "string"
fan.optional = true

min_pwm = c:option(Value, "min_pwm", translate("最小 PWM (可选)"))
min_pwm.datatype = "uinteger"
min_pwm.default = 0
min_pwm.optional = true

max_pwm = c:option(Value, "max_pwm", translate("最大 PWM (可选)"))
max_pwm.datatype = "uinteger"
max_pwm.default = 255
max_pwm.optional = true

average = c:option(Value, "average", translate("温度平均 (可选)"))
average.datatype = "uinteger"
average.default = 1
average.optional = true

control_disabled = c:option(Flag, "disabled", translate("禁用 (可选)"))
control_disabled.default = 0
control_disabled.rmempty = false

return m

