local fs    = require "nixio.fs"
local util  = require "luci.util"
local uci   = require "luci.model.uci".cursor()

local conf  = uci:get("aria2", "main", "pro") or uci:get("aria2", "main", "config_dir")
local files = {
    a = conf .. "/aria2.main.conf",
    b = conf .. "/aria2.session",
    c = "/etc/config/aria2"
}

local t = SimpleForm("aria2", "Aria2 - %s" % translate("Files"),
    translate("Here shows the files used by aria2."))
for i, conffiles in pairs(files) do
    if fs.access(conffiles) then
        local s = t:section(SimpleSection, nil,
            translatef("This is the content of the configuration file under <code>%s</code>:", conffiles))
        local o = s:option(TextValue, 'files' .. i)
        local fileContent = fs.readfile(conffiles)
        o.rows = util.trim(fileContent) ~= "" and 20 or 2
        o.readonly = i ~= 'a'

        o.cfgvalue = function(self, section)
            return util.trim(fileContent) ~= "" and fileContent or translate("Empty file.")
        end

        o.write = function(self, section, value)
            if value and value ~= fileContent then
                fs.writefile(conffiles, value:gsub("\r\n?", "\n"))
            end
        end
    end
end

return t
