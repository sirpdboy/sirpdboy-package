local a,t,e
local s=luci.util.trim(luci.sys.exec("HOME=/tmp qbittorrent-nox -v | awk '{print $2}'"))
function titlesplit(e)
return"<p style=\"font-size:15px;font-weight:bold;color: DodgerBlue\">"..translate(e).."</p>"
end
local e=require"luci.model.uci".cursor()
local i=require"nixio.fs"
local n=(luci.sys.call("pidof qbittorrent-nox > /dev/null")==0)
local e=luci.sys.exec("uci get qbittorrent.main.Port | xargs echo -n")or 8080
local o=""
if n then
o="<br /><br /><input class=\"cbi-button cbi-button-apply\" type=\"button\" value=\" "..translate("Open Web Interface").." \" onclick=\"window.open('http://'+window.location.hostname+':"..e.."')\"/>"
end
a=Map("qbittorrent",translate("qBittorrent 下载器"),translate("一个基于QT的跨平台的开源BitTorrent客户端。")..o)
a:section(SimpleSection).template="qbittorrent/qbittorrent_status"
t=a:section(NamedSection,"main","qbittorrent")
t:tab("basic",translate("Basic Settings"))
e=t:taboption("basic",Flag,"enabled",translate("Enabled"),"%s  %s"%{translate(""),"<b style=\"color:green\">"..translatef("当前qBitTorrent的版本: %s",s).."</b>"})
e.default="1"
e=t:taboption("basic",ListValue,"user",translate("Run daemon as user"),translate("留空以使用默认用户。"))
local o
for t in luci.util.execi("cat /etc/passwd | cut -d ':' -f1")do
e:value(t)
end
e=t:taboption("basic",Value,"profile",translate("Parent Path for Profile Folder"),translate("The path for storing profile folder using by command: <b>--profile [PATH]</b>."))
e.default='/tmp'
e=t:taboption("basic",Value,"SavePath",translate("Save Path"),translate("The path to save the download file. For example:<code>/mnt/sda1/download</code>"))
e.placeholder="/tmp/download"
e=t:taboption("basic",Value,"Locale",translate("Locale Language"))
e:value("zh",translate("Chinese"))
e:value("en",translate("English"))
e.default="zh"
e=t:taboption("basic",Value,"Username",translate("Username"),translate("The login name for WebUI."))
e.placeholder="admin"
e=t:taboption("basic",Value,"Password",translate("Password"),translate("The login password for WebUI."))
e.password=true
e=t:taboption("basic",Value,"Port",translate("Listen Port"),translate("The listening port for WebUI."))
e.datatype="port"
e.default="8080"
--e=t:taboption("basic",Value,"configuration",translate("Profile Folder Suffix"),translate("Suffix for profile folder, for example, <b>qBittorrent_[NAME]</b>."))
t:tab("connection",translate("Connection Settings"))
e=t:taboption("connection",Flag,"UPnP",translate("Use UPnP for Connections"),translate("Use UPnP/ NAT-PMP port forwarding from my router."))
e.enabled="true"
e.disabled="false"
e.default=e.enabled
e=t:taboption("connection",Flag,"UseRandomPort",translate("Use Random Port"),translate("Use different port on each startup voids the first"))
e.enabled="true"
e.disabled="false"
e.default=e.disabled
e=t:taboption("connection",Value,"PortRangeMin",translate("Connection Port"),translate("Generate Randomly"))
e:depends("UseRandomPort",false)
e.datatype="range(1024,65535)"
e:value("",translate("default"))
e=t:taboption("connection",Value,"GlobalDLLimit",translate("Global Download Speed"),translate("Global Download Speed Limit(KiB/s)."))
e.datatype="float"
e.placeholder="0"
e=t:taboption("connection",Value,"GlobalUPLimit",translate("Global Upload Speed"),translate("Global Upload Speed Limit(KiB/s)."))
e.datatype="float"
e.placeholder="0"
e=t:taboption("connection",Value,"GlobalDLLimitAlt",translate("Alternative Download Speed"),translate("Alternative Download Speed Limit(KiB/s)."))
e.datatype="float"
e.placeholder="10"
e=t:taboption("connection",Value,"GlobalUPLimitAlt",translate("Alternative Upload Speed"),translate("Alternative Upload Speed Limit(KiB/s)."))
e.datatype="float"
e.placeholder="10"
e=t:taboption("connection",ListValue,"BTProtocol",translate("Enabled protocol"),translate("The protocol that was enabled."))
e:value("Both",translate("TCP and UTP"))
e:value("TCP",translate("TCP"))
e:value("UTP",translate("UTP"))
e.default="Both"
e=t:taboption("connection",Value,"InetAddress",translate("Inet Address"),translate("The address that respond to the trackers."))
t:tab("downloads",translate("Downloads Settings"))
e=t:taboption("downloads",DummyValue,"Saving Management",titlesplit("When adding seeds"))
e=t:taboption("downloads",Flag,"CreateTorrentSubfolder",translate("Create Subfolder"),translate("Create subfolder for torrents with multiple files."))
e.enabled="true"
e.disabled="false"
e.default=e.enabled
e=t:taboption("downloads",Flag,"StartInPause",translate("Start In Pause"),translate("Do not start the download automatically."))
e.enabled="true"
e.disabled="false"
e.default=e.disabled
e=t:taboption("downloads",Flag,"AutoDeleteAddedTorrentFile",translate("Auto Delete Torrent File"),translate("The .torrent files will be deleted afterwards."))
e.enabled="IfAdded"
e.disabled="Never"
e.default=e.disabled
e=t:taboption("downloads",Flag,"PreAllocation",translate("Pre Allocation"),translate("Pre-allocate disk space for all files."))
e.enabled="true"
e.disabled="false"
e.default=e.disabled
e=t:taboption("downloads",Flag,"UseIncompleteExtension",translate("Use Incomplete Extension"),translate("The incomplete task will be added the extension of !qB."))
e.enabled="true"
e.disabled="false"
e.default=e.enabled
e=t:taboption("downloads",Flag,"TempPathEnabled",translate("Temp Path Enabled"))
e.enabled="true"
e.disabled="false"
e.default=e.disabled
e=t:taboption("downloads",Value,"TempPath",translate("Temp Path"),translate("The absolute and relative path can be set."))
e:depends("TempPathEnabled","true")
e.placeholder="temp/"
e=t:taboption("downloads",Value,"DiskWriteCacheSize",translate("Disk Cache Size (MiB)"),translate("The value -1  is auto and 0 is disable. In default, it is set to 64MiB."))
e.datatype="integer"
e.placeholder="64"
e=t:taboption("downloads",Value,"DiskWriteCacheTTL",translate("Disk Cache TTL (s)"),translate("In default, it is set to 60s."))
e.datatype="integer"
e.placeholder="60"
e=t:taboption("downloads",DummyValue,"Saving Management",titlesplit("Saving Management"))
e=t:taboption("downloads",ListValue,"DisableAutoTMMByDefault",translate("Default Torrent Management Mode"))
e:value("true",translate("Manual"))
e:value("false",translate("Automaic"))
e.default="true"
e=t:taboption("downloads",ListValue,"CategoryChanged",translate("Torrent Category Changed"),translate("Choose the action when torrent category changed."))
e:value("true",translate("Switch torrent to Manual Mode"))
e:value("false",translate("Relocate torrent"))
e.default="false"
e=t:taboption("downloads",ListValue,"DefaultSavePathChanged",translate("Default Save Path Changed"),translate("Choose the action when default save path changed."))
e:value("true",translate("Switch affected torrent to Manual Mode"))
e:value("false",translate("Relocate affected torrent"))
e.default="true"
e=t:taboption("downloads",ListValue,"CategorySavePathChanged",translate("Category Save Path Changed"),translate("Choose the action when category save path changed."))
e:value("true",translate("Switch affected torrent to Manual Mode"))
e:value("false",translate("Relocate affected torrent"))
e.default="true"
e=t:taboption("downloads",Value,"TorrentExportDir",translate("Torrent Export Dir"),translate("The .torrent files will be copied to the target directory."))
e=t:taboption("downloads",Value,"FinishedTorrentExportDir",translate("Finished Torrent Export Dir"),translate("The .torrent files for finished downloads will be copied to the target directory."))
t:tab("bittorrent",translate("Bittorrent Settings"))
e=t:taboption("bittorrent",Flag,"DHT",translate("Enable DHT"),translate("Enable DHT (decentralized network) to find more peers"))
e.enabled="true"
e.disabled="false"
e.default=e.disabled
e=t:taboption("bittorrent",Flag,"PeX",translate("Enable PeX"),translate("Enable Peer Exchange (PeX) to find more peers"))
e.enabled="true"
e.disabled="false"
e.default=e.disabled
e=t:taboption("bittorrent",Flag,"LSD",translate("Enable LSD"),translate("Enable Local Peer Discovery to find more peers"))
e.enabled="true"
e.disabled="false"
e.default=e.disabled
e=t:taboption("bittorrent",Flag,"uTP_rate_limited",translate("uTP Rate Limit"),translate("Apply rate limit to µTP protocol."))
e.enabled="true"
e.disabled="false"
e.default=e.enabled
e=t:taboption("bittorrent",ListValue,"Encryption",translate("Encryption Mode"),translate("Enable DHT (decentralized network) to find more peers"))
e:value("0",translate("Prefer Encryption"))
e:value("1",translate("Require Encryption"))
e:value("2",translate("Disable Encryption"))
e.default="0"
e=t:taboption("bittorrent",Value,"MaxConnecs",translate("Max Connections"),translate("The max number of connections."))
e.datatype="integer"
e.placeholder="500"
e=t:taboption("bittorrent",Value,"MaxConnecsPerTorrent",translate("Max Connections Per Torrent"),translate("The max number of connections per torrent."))
e.datatype="integer"
e.placeholder="100"
e=t:taboption("bittorrent",Value,"MaxUploads",translate("Max Uploads"),translate("The max number of connected peers."))
e.datatype="integer"
e.placeholder="8"
e=t:taboption("bittorrent",Value,"MaxUploadsPerTorrent",translate("Max Uploads Per Torrent"),translate("The max number of connected peers per torrent."))
e.datatype="integer"
e.placeholder="4"
e=t:taboption("bittorrent",Value,"MaxRatio",translate("Max Ratio"),translate("The max ratio for seeding. -1 is to disable the seeding."))
e.datatype="float"
e.placeholder="-1"
e=t:taboption("bittorrent",ListValue,"MaxRatioAction",translate("Max Ratio Action"),translate("The action when reach the max seeding ratio."))
e:value("0",translate("Pause them"))
e:value("1",translate("Remove them"))
e.defaule="0"
e=t:taboption("bittorrent",Value,"GlobalMaxSeedingMinutes",translate("Max Seeding Minutes"),translate("Units: minutes"))
e.datatype="integer"
e=t:taboption("bittorrent",DummyValue,"Queueing Setting",titlesplit("Queueing Setting"))
e=t:taboption("bittorrent",Flag,"QueueingEnabled",translate("Enable Torrent Queueing"))
e.enabled="true"
e.disabled="false"
e.default=e.enabled
e=t:taboption("bittorrent",Value,"MaxActiveDownloads",translate("Maximum Active Downloads"))
e.datatype="integer"
e.placeholder="3"
e=t:taboption("bittorrent",Value,"MaxActiveUploads",translate("Max Active Uploads"))
e.datatype="integer"
e.placeholder="3"
e=t:taboption("bittorrent",Value,"MaxActiveTorrents",translate("Max Active Torrents"))
e.datatype="integer"
e.placeholder="5"
e=t:taboption("bittorrent",Flag,"IgnoreSlowTorrents",translate("Ignore Slow Torrents"),translate("Do not count slow torrents in these limits."))
e.enabled="true"
e.disabled="false"
e.default=e.disabled
e=t:taboption("bittorrent",Value,"SlowTorrentsDownloadRate",translate("Download rate threshold"),translate("Units: KiB/s"))
e.datatype="integer"
e.placeholder="2"
e=t:taboption("bittorrent",Value,"SlowTorrentsUploadRate",translate("Upload rate threshold"),translate("Units: KiB/s"))
e.datatype="integer"
e.placeholder="2"
e=t:taboption("bittorrent",Value,"SlowTorrentsInactivityTimer",translate("Torrent inactivity timer"),translate("Units: seconds"))
e.datatype="integer"
e.placeholder="60"
t:tab("webgui",translate("WebUI Settings"))
e=t:taboption("webgui",Flag,"UseUPnP",translate("Use UPnP for WebUI"),translate("Using the UPnP / NAT-PMP port of the router for connecting to WebUI."))
e.enabled="true"
e.disabled="false"
e.default=e.disabled
e=t:taboption("webgui",Flag,"CSRFProtection",translate("CSRF Protection"),translate("Enable Cross-Site Request Forgery (CSRF) protection."))
e.enabled="true"
e.disabled="false"
e.default=e.disabled
e=t:taboption("webgui",Flag,"ClickjackingProtection",translate("Clickjacking Protection"),translate("Enable clickjacking protection."))
e.enabled="true"
e.disabled="false"
e.default=e.enabled
e=t:taboption("webgui",Flag,"HostHeaderValidation",translate("Host Header Validation"),translate("Validate the host header."))
e.enabled="true"
e.disabled="false"
e.default=e.disabled
e=t:taboption("webgui",Flag,"LocalHostAuth",translate("Local Host Authentication"),translate("Force authentication for clients on localhost."))
e.enabled="true"
e.disabled="false"
e.default=e.disabled
e=t:taboption("webgui",Flag,"AuthSubnetWhitelistEnabled",translate("Enable Subnet Whitelist"))
e.enabled="true"
e.disabled="false"
e.default=e.disabled
e=t:taboption("webgui",DynamicList,"AuthSubnetWhitelist",translate("Subnet Whitelist"))
e:depends("AuthSubnetWhitelistEnabled","true")
t:tab("advanced",translate("Advance Settings"))
e=t:taboption("advanced",Flag,"AnonymousMode",translate("Anonymous Mode"),translate("When enabled, qBittorrent will take certain measures to try"))
e.enabled="true"
e.disabled="false"
e.default=e.enabled
e=t:taboption("advanced",Flag,"SuperSeeding",translate("Super Seeding"),translate("The super seeding mode."))
e.enabled="true"
e.disabled="false"
e.default=e.disabled
e=t:taboption("advanced",Flag,"IncludeOverhead",translate("Limit Overhead Usage"),translate("The overhead usage is been limitted."))
e.enabled="true"
e.disabled="false"
e.default=e.disabled
e=t:taboption("advanced",Flag,"IgnoreLimitsLAN",translate("Ignore LAN Limit"),translate("Ignore the speed limit to LAN."))
e.enabled="true"
e.disabled="false"
e.default=e.enabled
e=t:taboption("advanced",Flag,"osCache",translate("Use os Cache"))
e.enabled="true"
e.disabled="false"
e.default=e.enabled
e=t:taboption("advanced",Value,"OutgoingPortsMax",translate("Max Outgoing Port"),translate("The max outgoing port."))
e.datatype="port"
e=t:taboption("advanced",Value,"OutgoingPortsMin",translate("Min Outgoing Port"),translate("The min outgoing port."))
e.datatype="port"
e=t:taboption("advanced",ListValue,"SeedChokingAlgorithm",translate("Choking Algorithm"),translate("The strategy of choking algorithm."))
e:value("RoundRobin",translate("Round Robin"))
e:value("FastestUpload",translate("Fastest Upload"))
e:value("AntiLeech",translate("Anti-Leech"))
e.default="FastestUpload"
e=t:taboption("advanced",Flag,"AnnounceToAllTrackers",translate("Announce To All Trackers"))
e.enabled="true"
e.disabled="false"
e.default=e.disabled
e=t:taboption("advanced",Flag,"AnnounceToAllTiers",translate("Announce To All Tiers"))
e.enabled="true"
e.disabled="false"
e.default=e.enabled
e=t:taboption("advanced",Flag,"Enabled",translate("Enable Log"),translate("Enable logger to log file."))
e.enabled="true"
e.disabled="false"
e.default=e.enabled
e=t:taboption("advanced",Value,"Path",translate("Log Path"),translate("The path for qbittorrent log."))
e:depends("Enabled","true")
e=t:taboption("advanced",Flag,"Backup",translate("Enable Backup"),translate("Backup log file when oversize the given size."))
e:depends("Enabled","true")
e.enabled="true"
e.disabled="false"
e.default=e.enabled
e=t:taboption("advanced",Flag,"DeleteOld",translate("Delete Old Backup"),translate("Delete the old log file."))
e:depends("Enabled","true")
e.enabled="true"
e.disabled="false"
e.default=e.enabled
e=t:taboption("advanced",Value,"MaxSizeBytes",translate("Log Max Size"),translate("The max size for qbittorrent log (Unit: Bytes)."))
e:depends("Enabled","true")
e.placeholder="66560"
e=t:taboption("advanced",Value,"SaveTime",translate("Log Saving Period"),translate("The log file will be deteted after given time. 1d -- 1 day, 1m -- 1 month, 1y -- 1 year"))
e:depends("Enabled","true")
e.datatype="string"
return a
