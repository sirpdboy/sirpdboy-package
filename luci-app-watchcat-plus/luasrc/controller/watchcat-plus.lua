module("luci.controller.watchcat-plus", package.seeall)

function index()
   if not nixio.fs.access("/etc/config/watchcat") then
      return
   end
   local page
   page = entry({"admin", "control", "watchcat-plus"}, alias("admin", "control", "watchcat-plus", "periodic_reboot"),
               _("Watchcat Plus"), 10)  -- 首页
   page.dependent = true
	page.acl_depends = { "luci-app-watchcat-plus" }
   
   entry({"admin", "control", "watchcat-plus", "periodic_reboot"}, cbi("watchcat-plus/periodic_reboot"), translate("Periodic Reboot"), 10).leaf = true -- "定时重启模式页面" 
   entry({"admin", "control", "watchcat-plus", "ping_reboot"}, cbi("watchcat-plus/ping_reboot"), translate("Ping Reboot"), 20).leaf = true -- "Ping重启模式页面" 
   entry({"admin", "control", "watchcat-plus", "restart_iface"}, cbi("watchcat-plus/restart_iface"), translate("Restart Interface"), 30).leaf = true -- "重启接口模式页面" 
   entry({"admin", "control", "watchcat-plus", "run_script"}, cbi("watchcat-plus/run_script"), translate("Run Script"), 40).leaf = true -- "运行脚本模式界面" 
   entry({"admin", "control", "watchcat-plus", "log"}, form("watchcat-plus/log"), _("Log"), 50).leaf = true -- 日志页面
   entry({"admin", "control", "watchcat-plus", "logread"}, call("action_logread"), nil).dependent = false -- 日志采集
end

function action_logread()
   local e = luci.sys.exec("logread | grep watchcat")
      if e == nil then
         e = ""
      end
   luci.http.prepare_content("application/json")
   luci.http.write_json(e);
end