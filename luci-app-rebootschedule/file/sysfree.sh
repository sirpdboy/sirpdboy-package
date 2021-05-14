#!/bin/sh
 
cd /overlay
rm -rf `ls | egrep -v '(upper|.fs_state)'`
cd /overlay/upper
rm -rf `ls | egrep -v '(etc|usr)'`
cd /overlay/upper/usr
rm -rf `ls | egrep -v '(share)'`
cd /overlay/upper/usr/share
rm -rf `ls | egrep -v '(unblockneteasemusic|passwall)'`
cd /overlay/upper/etc
rm -rf `ls | egrep -v '(config|smartdns|ssrplus|bench.log|shadow|openclash|fucked)'`
cd /overlay/upper/etc/config
rm -rf `ls | egrep -v '(arpbind|ksmbd|access_control|netspeedtest|autoreboot|ddns|firewall|jd-dailybonus|network|oled|openclash|passwall|serverchan|shadowsocksr|sqm|unblockneteasemusic|weburl|zerotier|vssr|zero|dhcp)'`
rm -f /tmp/luci*
sync && echo 3 > /proc/sys/vm/drop_caches

 