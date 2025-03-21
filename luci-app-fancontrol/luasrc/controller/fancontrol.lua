module("luci.controller.fancontrol", package.seeall)

function index()
    if nixio.fs.access("/etc/config/fancontrol") then
        local fan_speed = luci.sys.exec("cat /sys/class/hwmon/hwmon0/temp1_input")
        fan_speed = fan_speed or "未知"
        entry({"admin", "system", "fancontrol"}, cbi("fancontrol"), _("风扇控制"), 90).dependent = true
        entry({"admin", "system", "fancontrol", "status"}, call("action_fancontrol_status"), _("风扇控制状态"), 91)
    end
end

function action_fancontrol_status()
    local fan_speed = luci.sys.exec("cat /sys/class/hwmon/hwmon0/temp1_input")
    fan_speed = fan_speed or "未知"
    luci.template.render("fancontrol/fancontrol_status", {fan_speed = fan_speed})
end


