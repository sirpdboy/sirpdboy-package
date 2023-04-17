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
    return self.map:get(section, "mode") == "run_script"
end

-- 运行脚本模式
mode = s:option(ListValue, "mode",
		translate("Mode"),
		translate("Run Script: Run a script if a ping to a specified host fails for a specified duration of time."))
mode:value("run_script", translate("Run Script"))
mode.default = "run_script"

-- 运行脚本
script = s:option(Value, "script", translate("Script to run"))
script.datatype = "file"
script.default = "/etc/watchcat.user.sh"
script.description = translate("Script to run when the host has not responded for the specified duration of " ..
"time. The script is passed the interface name as $1")

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

-- ping 主机
pinghosts = s:option(Value, "pinghosts", 
translate("Host To Check"),
translate("IP address or hostname to ping."))
pinghosts.datatype = "host(1)"
pinghosts.default = "8.8.8.8"

-- ping 地址簇
addressfamily = s:option(ListValue, 'addressfamily',
				 translate('Address family for pinging the host'))
addressfamily:value("any", "any");
addressfamily:value("ipv4", "ipv4");
addressfamily:value("ipv6", "ipv6");
addressfamily.default = "any";

-- ping周期
pingperiod = s:option(Value, "pingperiod", 
		      translate("Check Interval"),
		      translate("How often to ping the host specified above. \
			  <br /><br />The default unit is seconds, without a suffix, but you can use the suffix <b>m</b> for minutes, <b>h</b> for hours or <b>d</b> for days. <br /><br /> \
			  Examples:<ul><li>10 seconds would be: <b>10</b> or <b>10s</b></li><li>5 minutes would be: <b>5m</b></li><li>1 hour would be: <b>1h</b></li><li>1 week would be: <b>7d</b></li><ul>"))
pingperiod.default = "30s"

-- ping 包大小
pingsize = s:option(ListValue, 'pingsize', translate('Ping Packet Size'));
pingsize:value('small', translate('Small: 1 byte'));
pingsize:value('windows', translate('Windows: 32 bytes'));
pingsize:value('standard', translate('Standard: 56 bytes'));
pingsize:value('big', translate('Big: 248 bytes'));
pingsize:value('huge', translate('Huge: 1492 bytes'));
pingsize:value('jumbo', translate('Jumbo: 9000 bytes'));
pingsize.default = 'standard';

-- 接口
interface = s:option(Value, "interface",
				translate('Restart Interface'),
				translate("Interface to monitor and/or restart.<br/><br/><i>Applies to Ping Reboot, Restart Interface, and Run Script modes</i> <br /> Specify the interface to monitor and react if a ping over it fails.")
			);
device_table = luci.sys.net.devices();
if device_table ~= nil then
	for k, v in ipairs(device_table) do
		if v ~= "lo" then
			interface:value(v, v)
		end
	end 
end

return m
