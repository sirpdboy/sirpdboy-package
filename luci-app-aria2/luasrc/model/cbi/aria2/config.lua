local sys  = require "luci.sys"
local util = require "luci.util"

local function checkAria2c()
    if sys.call("command -v aria2c >/dev/null") ~= 0 then
        return nil
    end

    local t = {}
    for e in util.execi("aria2c -v 2>/dev/null | grep -E '^(aria2 version|Enabled Features)'") do
        if e:match("^aria2 version") then
            t.version = e:match("([%d%.]+)$")
        elseif e:match("^Enabled Features") then
            t.gzip = e:find("GZip") ~= nil
            t.https = e:find("HTTPS") ~= nil
            t.bt = e:find("BitTorrent") ~= nil
            t.sftp = e:find("SFTP") ~= nil
            t.adns = e:find("Async DNS") ~= nil
            t.cookie = e:find("Firefox3 Cookie") ~= nil
        end
    end
    return t
end
local aria2cInfo = checkAria2c()

local o = Map("aria2", "Aria2 - %s" % translate("Settings"),
    translate("Aria2 is a lightweight multi-protocol &amp; multi-source,  cross platform download utility."))
if not aria2cInfo then
    o:section(SimpleSection, nil, "<span style='color:red;'>%s</span>" %
        translate("Error: Can't find aria2c in PATH,  please reinstall aria2."))
    o.reset = false
    o.submit = false
    return o
end

o:append(Template("aria2/settings_header"))
t = o:section(NamedSection, "main", "aria2")
t.addremove = false
t.anonymous = true

t:tab("basic", translate("Basic Options"))
e = t:taboption("basic", Flag, "enabled", translate("Enabled"))
e.description = translatef("Current version of aria2: <b style=\"color:green\"> %s", aria2cInfo.version) .. "</b>"
e.rmempty = false

e = t:taboption("basic", ListValue, "user", translate("Run daemon as user"),
    translate("Leave blank to use default user."))
e:value("")
for t in util.execi("cut -d':' -f1 /etc/passwd") do
    e:value(t)
end

e = t:taboption("basic", Value, "dir", translate("Download directory"),
    translate("The files are stored in the download directory automatically created under the selected mounted disk"))
local dev_map = {}
for disk in util.execi("df -h | awk '/dev.*mnt/{print $6,$2,$3,$5,$1}'") do
    local diskInfo = util.split(disk, " ")
    local dev = diskInfo[5]
    if not dev_map[dev] then
        dev_map[dev] = true
        e:value(diskInfo[1] .. "/download",
            translatef(("%s/download (size: %s) (used: %s/%s)"), diskInfo[1], diskInfo[2], diskInfo[3], diskInfo[4]))
    end
end

e = t:taboption("basic", Value, "config_dir", translate("Config file directory"),
    translate("The directory to store the config file,  session file and DHT file."))
e.placeholder = "/var/etc/aria2"

e = t:taboption("basic", Flag, "enable_pro", translate("Enable Aria2 pro"),
    translate("When enabled,  the original system configuration directory will be merged."))
e.rmempty = false

e = t:taboption("basic", Value, "pro", translate("Aria2 pro file"),
    translate("Use the configuration scheme of p3terx to realize the enhancement and expansion of aria2 function."))
e:depends("enable_pro", "1")
e.default = "/usr/share/aria2"

e = t:taboption("basic", Flag, "enable_logging", translate("Enable logging"))
e.rmempty = false

e = t:taboption("basic", Value, "log_dir", translate("Log file"),
    translate("The directory where the log files are saved"))
e:depends("enable_logging", "1")
e.placeholder = "/var/log"

e = t:taboption("basic", ListValue, "log_level", translate("Log level"))
e:depends("enable_logging", "1")
e:value("debug", translate("Debug"))
e:value("info", translate("Info"))
e:value("notice", translate("Notice"))
e:value("warn", translate("Warn"))
e:value("error", translate("Error"))
e.default = "warn"

e = t:taboption("basic", Value, "max_concurrent_downloads", translate("Max concurrent downloads"))
e.placeholder = "5"
t:tab("rpc", translate("RPC Options"))

e = t:taboption("rpc", Flag, "pause", translate("Pause"), translate("Pause download after added."))
e.enabled = "true"
e.disabled = "false"
e.default = "false"

e = t:taboption("rpc", Flag, "pause_metadata", translate("Pause metadata"),
    translate("Pause downloads created as a result of metadata download."))
e.enabled = "true"
e.disabled = "false"
e.default = "false"

e = t:taboption("rpc", Value, "rpc_listen_port", translate("RPC port"),
    translate("The webui port defaults to 6800."))
e.datatype = "range(1024, 65535)"
e.placeholder = "6800"

e = t:taboption("rpc", ListValue, "rpc_auth_method",
    translate("RPC authentication method"))
e:value("none", translate("No Authentication"))
e:value("token", translate("Token"))

e = t:taboption("rpc", Value, "rpc_secret", translate("RPC token"))
e:depends("rpc_auth_method", "token")
e.template = "aria2/value_with_btn"
e.btntext = translate("generate randomly")
e.btnclick = "randomToken();"

if aria2cInfo.https then
    e = t:taboption("rpc", Flag, "rpc_secure", translate("RPC secure"),
        translate("RPC transport will be encrypted by SSL/TLS. The RPC clients must use https"
            .. " scheme to access the server. For WebSocket client,  use wss scheme."))
    e.enabled = "true"
    e.disabled = "false"
    e.rmempty = false

    e = t:taboption("rpc", Value, "rpc_certificate", translate("RPC certificate"),
        translate("Use the certificate in FILE for RPC server. The certificate must be either"
            .. " in PKCS12 (.p12,  .pfx) or in PEM format.<br/>PKCS12 files must contain the"
            .. " certificate,  a key and optionally a chain of additional certificates. Only PKCS12"
            .. " files with a blank import password can be opened!<br/>When using PEM,  you have to"
            .. " specify the \"RPC private key\" as well."))
    e:depends("rpc_secure", "true")
    e.datatype = "file"

    e = t:taboption("rpc", Value, "rpc_private_key", translate("RPC private key"),
        translate("Use the private key in FILE for RPC server. The private key must be"
            .. " decrypted and in PEM format."))
    e:depends("rpc_secure", "true")
    e.datatype = "file"
end

e = t:taboption("rpc", Flag, "_use_ws", translate("Use WebSocket"))
e = t:taboption("rpc", Value, "_rpc_url", translate("Json-RPC URL"))
e.template = "aria2/value_with_btn"
e.onmouseover = "this.focus();this.select();"
e.btntext = translate("Show URL")
e.btnclick = "showRPCURL();"
t:tab("http", translate("HTTP/FTP/SFTP Options"))

e = t:taboption("http", Flag, "enable_proxy", translate("Enable proxy"))
e.rmempty = false

e = t:taboption("http", Value, "all_proxy", translate("All proxy"),
    translate("Use a proxy server for all protocols."))
e:depends("enable_proxy", "1")
e.placeholder = "[http://][USER:PASSWORD@]HOST[:PORT]"

e = t:taboption("http", Value, "all_proxy_user",
    translate("Proxy user"))
e:depends("enable_proxy", "1")

e = t:taboption("http", Value, "all_proxy_passwd",
    translate("Proxy password"))
e:depends("enable_proxy", "1")
e.password = true

if aria2cInfo.https then
    e = t:taboption("http", Flag, "check_certificate", translate("Check certificate"),
        translate("Verify the peer using certificates specified in \"CA certificate\" option."))
    e.enabled = "true"
    e.disabled = "false"
    e.default = "true"
    e.rmempty = false

    e = t:taboption("http", Value, "ca_certificate", translate("CA certificate"),
        translate("Use the certificate authorities in FILE to verify the peers. The certificate"
            .. " file must be in PEM format and can contain multiple CA certificates."))
    e:depends("check_certificate", "true")
    e.datatype = "file"

    e = t:taboption("http", Value, "certificate", translate("Certificate"),
        translate("Use the client certificate in FILE. The certificate must be either in PKCS12"
            .. " (.p12,  .pfx) or in PEM format.<br/>PKCS12 files must contain the certificate,  a"
            .. " key and optionally a chain of additional certificates. Only PKCS12 files with a"
            .. " blank import password can be opened!<br/>When using PEM,  you have to specify the"
            .. " \"Private key\" as well."))
    e.datatype = "file"

    e = t:taboption("http", Value, "private_key", translate("Private key"),
        translate("Use the private key in FILE. The private key must be decrypted and in PEM"
            .. " format. The behavior when encrypted one is given is undefined."))
    e.datatype = "file"
end

if aria2cInfo.gzip then
    e = t:taboption("http", Flag, "http_accept_gzip", translate("HTTP accept gzip"),
        translate("Send <code>Accept: deflate,  gzip</code> request header and inflate response"
            .. " if remote server responds with <code>Content-Encoding: gzip</code> or"
            .. " <code>Content-Encoding: deflate</code>."))
    e.enabled = "true"
    e.disabled = "false"
    e.default = "false"
end

e = t:taboption("http", Flag, "http_no_cache", translate("HTTP no cache"),
    translate("Send <code>Cache-Control: no-cache</code> and <code>Pragma: no-cache</code>"
        .. " header to avoid cached content. If disabled,  these headers are not sent and you"
        .. " can add Cache-Control header with a directive you like using \"Header\" option."))
e.enabled = "true"
e.disabled = "false"
e.default = "false"

e = t:taboption("http", DynamicList, "header", translate("Header"),
    translate("Append HEADERs to HTTP request header."))

e = t:taboption("http", Value, "connect_timeout", translate("Connect timeout"),
    translate("Set the connect timeout in seconds to establish connection to HTTP/FTP/proxy server." ..
        " After the connection is established,  this option makes no effect and \"Timeout\" option is used instead."))
e.datatype = "uinteger"
e.placeholder = "60"

e = t:taboption("http", Value, "timeout", translate("Timeout"))
e.datatype = "uinteger"
e.placeholder = "60"

e = t:taboption("http", Value, "lowest_speed_limit", translate("Lowest speed limit"),
    translate("Close connection if download speed is lower than or equal to this value(bytes per sec). " ..
        "0 means has no lowest speed limit."),
    translate("You can append K or M.")
)
e.placeholder = "0"

e = t:taboption("http", Value, "max_connection_per_server", translate("Max connection per server"),
    translate("The maximum number of connections to one server for each download."))
e.datatype = "uinteger"
e.placeholder = "1"

e = t:taboption("http", Value, "split", translate("Max number of split"),
    translate("Download a file using N connections."))
e.datatype = "uinteger"
e.placeholder = "5"

e = t:taboption("http", Value, "min_split_size", translate("Min split size"),
    translate("Don't split less than 2*SIZE byte range. Possible values: 1M-1024M."))
e.placeholder = "20M"

e = t:taboption("http", Value, "max_tries", translate("Max tries"))
e.datatype = "uinteger"
e.placeholder = "5"

e = t:taboption("http", Value, "retry_wait", translate("Retry wait"),
    translate("Set the seconds to wait between retries."))
e.datatype = "uinteger"
e.placeholder = "0"

e = t:taboption("http", Value, "user_agent", translate("User agent"),
    translate("Set user agent for HTTP(S) downloads."))
e.placeholder = "aria2/%s" % { aria2cInfo.version and aria2cInfo.version or "$VERSION" }

if aria2cInfo.bt then
    t:tab("bt", translate("BitTorrent Options"))
    e = t:taboption("bt", Flag, "enable_dht",
        translatef("IPv4 <abbr title = '%s'>DHT</abbr> enabled", translate("Distributed Hash Table")),
        translate("Enable IPv4 DHT functionality. It also enables UDP tracker support."),
        translate("This option will be ignored if a private flag is set in a torrent.")
    )
    e.enabled = "true"
    e.disabled = "false"
    e.default = "true"
    e.rmempty = false

    e = t:taboption("bt", Flag, "enable_dht6",
        translatef("IPv6 <abbr title = '%s'>DHT</abbr> enabled", translate("Distributed Hash Table")),
        translate("Enable IPv6 DHT functionality."),
        translate("This option will be ignored if a private flag is set in a torrent.")
    )
    e.enabled = "true"
    e.disabled = "false"

    e = t:taboption("bt", Flag, "bt_enable_lpd",
        translatef("<abbr title = '%s'>LPD</abbr> enabled", translate("Local Peer Discovery")),
        translate("Enable Local Peer Discovery."),
        translate("This option will be ignored if a private flag is set in a torrent.")
    )
    e.enabled = "true"
    e.disabled = "false"
    e.default = "false"

    e = t:taboption("bt", Flag, "enable_peer_exchange", translate("Enable peer exchange"),
        translate("Enable Peer Exchange extension."),
        translate("This option will be ignored if a private flag is set in a torrent.")
    )
    e.enabled = "true"
    e.disabled = "false"
    e.default = "true"
    e.rmempty = false

    e = t:taboption("bt", Flag, "bt_save_metadata", translate("Sava metadata"),
        translate("Save meta data as \".torrent\" file. This option has effect only when BitTorrent"
            .. " Magnet URI is used. The file name is hex encoded info hash with suffix \".torrent\"."))
    e.enabled = "true"
    e.disabled = "false"
    e.default = "false"

    e = t:taboption("bt", Flag, "bt_remove_unselected_file", translate("Remove unselected file"),
        translate("Removes the unselected files when download is completed in BitTorrent. Please"
            .. " use this option with care because it will actually remove files from your disk."))
    e.enabled = "true"
    e.disabled = "false"
    e.default = "false"

    e = t:taboption("bt", Flag, "bt_seed_unverified", translate("Seed unverified"),
        translate("Seed previously downloaded files without verifying piece hashes."))
    e.enabled = "true"
    e.disabled = "false"
    e.default = "false"

    e = t:taboption("bt", Value, "listen_port", translate("BitTorrent listen port"),
        translate("Set TCP port number for BitTorrent downloads. Accept format: \"6881,6885\", "
            .. "\"6881-6999\" and \"6881-6889,6999\". Make sure that the specified ports are "
            .. "open for incoming TCP traffic."))
    e.placeholder = "6881-6999"

    e = t:taboption("bt", Value, "dht_listen_port", translate("DHT Listen port"),
        translate("Set UDP listening port used by DHT(IPv4,  IPv6) and UDP tracker. Make sure that the "
            .. "specified ports are open for incoming UDP traffic."))
    e:depends("enable_dht", "true")
    e:depends("enable_dht6", "true")
    e.placeholder = "6881-6999"

    e = t:taboption("bt", ListValue, "follow_torrent", translate("Follow torrent"))
    e:value("true", translate("True"))
    e:value("false", translate("False"))
    e:value("mem", translate("Keep in memory"))

    e = t:taboption("bt", Value, "max_overall_upload_limit", translate("Max overall upload limit"),
        translate("Set max overall upload speed in bytes/sec. 0 means unrestricted."),
        translate("You can append K or M.")
    )
    e.placeholder = "0"

    e = t:taboption("bt", Value, "max_upload_limit", translate("Max upload limit"),
        translate("Set max upload speed per each torrent in bytes/sec. 0 means unrestricted."),
        translate("You can append K or M.")
    )
    e.placeholder = "0"
    e = t:taboption("bt", Value, "bt_max_open_files", translate("Max open files"),
        translate("Specify maximum number of files to open in multi-file BitTorrent download globally."))
    e.datatype = "uinteger"
    e.placeholder = "100"

    e = t:taboption("bt", Value, "bt_max_peers", translate("Max peers"),
        translate("Specify the maximum number of peers per torrent,  0 means unlimited."))
    e.datatype = "uinteger"
    e.placeholder = "55"

    e = t:taboption("bt", Value, "bt_request_peer_speed_limit", translate("Request peer speed limit"),
        translate("If the whole download speed of every torrent is lower than SPEED,  aria2"
            .. " temporarily increases the number of peers to try for more download speed."
            .. " Configuring this option with your preferred download speed can increase your"
            .. " download speed in some cases."),
        translate("You can append K or M.")
    )
    e.placeholder = "50K"

    e = t:taboption("bt", Value, "bt_stop_timeout", translate("Stop timeout"),
        translate("Stop BitTorrent download if download speed is 0 in consecutive N seconds. If 0 is"
            .. " given,  this feature is disabled."))
    e.datatype = "uinteger"
    e.placeholder = "0"

    e = t:taboption("bt", Value, "peer_agent", translate("Peer-agent"))
    e.placeholder = "Deluge 1.3.15"

    e = t:taboption("bt", Value, "peer_id_prefix", translate("Prefix of peer ID"),
        translate("Specify the prefix of peer ID. The peer ID in BitTorrent is 20 byte length."
            .. " If more than 20 bytes are specified,  only first 20 bytes are used. If less than 20"
            .. " bytes are specified,  random byte data are added to make its length 20 bytes."))
    e.placeholder = "DE13F0-"

    e = t:taboption("bt", Value, "seed_ratio", translate("Seed ratio"),
        translate("Specify share ratio. Seed completed torrents until share ratio reaches RATIO."
            .. " You are strongly encouraged to specify equals or more than 1.0 here. Specify 0.0 if"
            .. " you intend to do seeding regardless of share ratio."))
    e.datatype = "ufloat"
    e.placeholder = "1.0"

    e = t:taboption("bt", Value, "seed_time", translate("Seed time"),
        translate("Specify seeding time in minutes. If \"Seed ratio\" option is"
            .. " specified along with this option,  seeding ends when at least one of the conditions"
            .. " is satisfied. Specifying 0 disables seeding after download completed."))
    e.datatype = "ufloat"

    e = t:taboption("bt", DynamicList, "bt_tracker", translate("Additional BT tracker"),
        translate("List of additional BitTorrent tracker's announce URI."))
    e.placeholder = "http://tracker.example.com/announce"
end

t:tab("advance", translate("Advanced Options"))
e = t:taboption("advance", Flag, "disable_ipv6", translate("IPv6 disabled"),
    translate("Disable IPv6. This is useful if you have to use broken DNS and want to avoid terribly"
        .. " slow AAAA record lookup."))
e.enabled = "true"
e.disabled = "false"
e.default = "false"

e = t:taboption("advance", Value, "auto_save_interval", translate("Auto save interval"),
    translate("Save a control file(*.aria2) every N seconds. If 0 is given,  a control file is not"
        .. " saved during download."))
e.datatype = "range(0,  600)"
e.placeholder = "60"

e = t:taboption("advance", Value, "save_session_interval", translate("Save session interval"),
    translate("Save error/unfinished downloads to session file every N seconds. If 0 is given,  file"
        .. " will be saved only when aria2 exits."))
e.datatype = "uinteger"
e.placeholder = "0"

e = t:taboption("advance", Value, "disk_cache", translate("Disk cache"),
    translate("Enable disk cache (in bytes),  set 0 to disabled."),
    translate("You can append K or M.")
)
e.placeholder = "64M"

e = t:taboption("advance", ListValue, "file_allocation", translate("File allocation"),
    translate("Specify file allocation method. If you are using newer file systems such as ext4"
        .. " (with extents support),  btrfs,  xfs or NTFS(MinGW build only),  \"falloc\" is your best choice."
        .. " It allocates large(few GiB) files almost instantly,  but it may not be available if your system"
        .. " doesn't have posix_fallocate(3) function. Don't use \"falloc\" with legacy file systems such as"
        .. " ext3 and FAT32 because it takes almost same time as \"prealloc\" and it blocks aria2 entirely"
        .. " until allocation finishes."))
e:value("none", translate("None"))
e:value("prealloc", translate("prealloc"))
e:value("trunc", translate("trunc"))
e:value("falloc", translate("falloc"))
e.default = "none"

e = t:taboption("advance", Flag, "force_save", translate("Force save"),
    translate("Save download to session file even if the download is completed or removed."
        .. " This option also saves control file in that situations. This may be useful to save"
        .. " BitTorrent seeding which is recognized as completed state."))
e.enabled = "true"
e.disabled = "false"
e.default = "false"

e = t:taboption("advance", Value, "max_overall_download_limit", translate("Max overall download limit"),
    translate("Set max overall download speed in bytes/sec. 0 means unrestricted."),
    translate("You can append K or M.")
)
e.placeholder = "0"

e = t:taboption("advance", Value, "max_download_limit", translate("Max download limit"),
    translate("Set max download speed per each download in bytes/sec. 0 means unrestricted."),
    translate("You can append K or M.")
)
e.placeholder = "0"

t = o:section(NamedSection, "main", "aria2", translate("Extra Settings"),
    translate("Settings in this section will be added to config file."))
t.addremove = false
t.anonymous = true

e = t:option(DynamicList, "extra_settings", translate("Settings list"),
    translate("List of extra settings. Format: option=value, eg. <code>netrc-path=/tmp/.netrc</code>."))
e.placeholder = "option = value"

return o
