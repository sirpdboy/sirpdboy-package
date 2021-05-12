m=Map("rebootschedule",translate("Reboot schedule"),
translate("<font color=\"green\"><b>让计划任务更加易用的插件，可以使用-表示连续的时间范围，使用,表示不连续的多个时间点，使用*/表示循环执行。可以使用“添加”来添加多条计划任务命令。可使用“--自定义--”来自行添加其它参数。</b></font></br>") ..
translate("*所有时间参数都是指该自然单位中的时间点，而非累积计数，比如月份只能是1～12，日期只能是1～31，星期只能是0～6，小时只能是0～23，分钟只能是0～59，不能使用50天、48小时这种累积计数表示法。</br>") ..
translate("* 所有数值可使用 - 连接表示连续范围，比如星期：1-5 表示星期一至星期五；使用,表示不连续的点，比如星期：1,3,5 表示仅仅星期一、三、五。月份、日期、时间用法相同。</br>") ..
translate("<input class=\"cbi-button cbi-button-apply\" type=\"button\" value=\"" ..
translate("查看使用示例") ..
" \" onclick=\"window.open('http://'+window.location.hostname+'/reboothelp.jpg')\"/>") ..
translate("&nbsp;&nbsp;&nbsp;<input class=\"cbi-button cbi-button-apply\" type=\"button\" value=\"" ..
 translate("查看crontab文件") ..
" \" onclick=\"window.open('crontab')\"/>") ..
translate("&nbsp;&nbsp;&nbsp;<input class=\"cbi-button cbi-button-apply\" type=\"button\" value=\"" ..
 translate("查看crontab用法") ..
" \" onclick=\"window.open('https://tool.lu/crontab/')\"/>")
)

s=m:section(TypedSection,"crontab","")
s.anonymous = true
s.addremove = true
s.sortable = false
s.template = "cbi/tblsection"
s.rmempty = false

p=s:option(Flag,"enable",translate("Enable"))
p.rmempty = false
p.default=0

month=s:option(Value,"month",translate("月 <font color=\" red\">(数值范围1～12)</font>"),
translate("<font color=\"gray\">*表示每个月，*/n表示每n个月</br>n1-n5连续，n1,n3,n5不连续</font>"))
month.rmempty = false
month.default = '*'

day=s:option(Value,"day",translate("日 <font color=\" red\">(数值范围1～31)</font>"),
translate("<font color=\"gray\">*表示每天，*/n表示每n天</br>n1-n5连续，n1,n3,n5不连续</font>"))
day.rmempty = false
day.default = '*'

week=s:option(Value,"week",translate("星期 <font color=\" red\">(数值范围0～6)</font>"),
translate("<font color=\"gray\">和日期是逻辑“与”关系</br>n1-n5连续，n1,n3,n5不连续</font>"))
week.rmempty = true
week:value('*',translate("Everyday"))
week:value(0,translate("Sunday"))
week:value(1,translate("Monday"))
week:value(2,translate("Tuesday"))
week:value(3,translate("Wednesday"))
week:value(4,translate("Thursday"))
week:value(5,translate("Friday"))
week:value(6,translate("Saturday"))
week.default='*'

hour=s:option(Value,"hour",translate("时 <font color=\" red\">(数值范围0～23)</font>"),
translate("<font color=\"gray\">*表示每小时，*/n表示每n小时</br>n1-n5连续，n1,n3,n5不连续</font>"))
hour.rmempty = false
hour.default = '5'

minute=s:option(Value,"minute",translate("分 <font color=\" red\">(数值范围0～59)</font>"),
translate("<font color=\"gray\">*表示每分钟，*/n表示每n分钟</br>n1-n5连续，n1,n3,n5不连续</font>"))
minute.rmempty = false
minute.default = '0'

command=s:option(Value,"command",translate("执行命令 <font color=\" red\">(多条用 && 连接)</font>"),
translate("<font color=\"gray\">按“--自定义--”可进行修改</br>(亦可添加后到计划任务中修改)</font>"))
command:value('sleep 5 && touch /etc/banner && reboot',translate("1.重启系统"))
command:value('/etc/init.d/network restart',translate("2.重启网络"))
command:value('ifdown wan && ifup wan',translate("3.重启wan"))
command:value('killall -q pppd && sleep 5 && pppd file /tmp/ppp/options.wan', translate("4.重新拨号"))
command:value('ifdown wan',translate("5.关闭联网"))
command:value('ifup wan',translate("6.打开联网"))
command:value('wifi down',translate("7.关闭WIFI"))
command:value('wifi up',translate("8.打开WIFI"))
command:value('sync && echo 3 > /proc/sys/vm/drop_caches', translate("9.释放内存"))
command:value('poweroff',translate("0.关闭电源"))
command.default='sleep 5 && touch /etc/banner && reboot'

local e=luci.http.formvalue("cbi.apply")
if e then
  io.popen("/etc/init.d/rebootschedule restart")
end

return m
