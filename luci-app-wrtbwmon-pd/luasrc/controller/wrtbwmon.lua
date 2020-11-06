module("luci.controller.wrtbwmon", package.seeall)

function index()
    entry({"admin", "status", "usage"}, alias("admin", "status", "usage", "details"), _("Usage"), 60)
    entry({"admin", "status", "usage", "details"}, template("wrtbwmon"), _("Details"), 10).leaf=true
    entry({"admin", "status", "usage", "config"}, cbi("wrtbwmon/config"), _("Configuration"), 20).leaf=true
    entry({"admin", "status", "usage", "custom"}, form("wrtbwmon/custom"), _("User file"), 30).leaf=true
    entry({"admin", "status", "usage", "check_dependency"}, call("check_dependency")).dependent=true
    entry({"admin", "status", "usage", "usage_data"}, call("usage_data")).dependent=true
    entry({"admin", "status", "usage", "usage_reset"}, call("usage_reset")).dependent=true
end

function usage_database_path()
    local cursor = luci.model.uci.cursor()
    if cursor:get("wrtbwmon", "general", "persist") == "1" then
        return "/etc/config/usage.db"
    else
        return "/tmp/usage.db"
    end
end

function check_dependency()
    local ret = "0"
    local status, ipkg = pcall(require, "luci.model.ipkg")
    if not status or ipkg.installed('wrtbwmon') then
        ret = "1"
    end
    luci.http.prepare_content("text/plain")
    luci.http.write(ret)
end

function usage_data()
    local db = usage_database_path()
    local publish_cmd = "wrtbwmon publish " .. db .. " /tmp/usage.htm /etc/wrtbwmon.user"
    local cmd = "wrtbwmon update " .. db .. " && " .. publish_cmd .. " && cat /tmp/usage.htm"
    luci.http.prepare_content("text/html")
    luci.http.write(luci.sys.exec(cmd))
end

function usage_reset()
    local db = usage_database_path()
    local ret = luci.sys.call("wrtbwmon update " .. db .. " && rm " .. db)
    luci.http.status(204)
end
