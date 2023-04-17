m = Map("watchcat", 
	"", 
	translate("Here you can set up several checks and actions to take in the event that a host becomes unreachable. \
	Click the <b>Add</b> button at the bottom to set up more than one action."
		 ))
		 m.on_after_commit = function(self)
			luci.sys.exec("service watchcat reload")
		end

s = m:section(TypedSection, "watchcat")
s.anonymous = true
s.addremove = true
function s.filter(self, section)
    return self.map:get(section, "mode") == "periodic_reboot"
end

-- 定时重启模式
mode = s:option(ListValue, "mode",
		translate("Mode"),
		translate("Periodic Reboot: Reboot this device after a specified interval of time."))
mode:value("periodic_reboot", translate("Periodic Reboot"))
mode.default = "periodic_reboot"

-- 周期
period = s:option(Value, "period", 
		  translate("Period"),
		  translate("In Periodic Reboot mode, it defines how often to reboot. <br /> \
				In Ping Reboot mode, it defines the longest period of \
				time without a reply from the Host To Check before a reboot is engaged. <br /> \
				In Network Restart or Run Script mode, it defines the longest period of \
				time without a reply from the Host to Check before the interface is restarted or the script is run. \
				<br /><br />The default unit is seconds, without a suffix, but you can use the \
				suffix <b>m</b> for minutes, <b>h</b> for hours or <b>d</b> \
				for days. <br /><br />Examples:<ul><li>10 seconds would be: <b>10</b> or <b>10s</b></li><li>5 minutes would be: <b>5m</b></li><li> \
				1 hour would be: <b>1h</b></li><li>1 week would be: <b>7d</b></li><ul>"))
period.default = '6h'

-- 强制重启延时
forcedelay = s:option(Value, "forcedelay",
		      translate("Force Reboot Delay"),
		      translate("Applies to Ping Reboot and Periodic Reboot modes</i> <br /> When rebooting the router, the service will trigger a soft reboot. \
			  Entering a non-zero value here will trigger a delayed hard reboot if the soft reboot were to fail. \
			  Enter the number of seconds to wait for the soft reboot to fail or use 0 to disable the forced reboot delay."))
forcedelay.default = "1m"

return m
