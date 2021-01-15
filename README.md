#sirpdboy-package
 

软件不定期同步大神库更新，适合一键下载到package目录下，用于openwrt编译

食用方法一、

在feeds.conf.default加入：

src-git sirpdboy-package https://github.com/siropboy/sirpdboy-package

食用方法二、

git clone https://github.com/siropboy/sirpdboy-package package/sirpdboy-package

openwrt 固件编译说明

luci-app-autopoweroff ------------------定时自动重启和自动关机

luci-app-advanced ------------------系统高级设置

luci-app-control-mia ------------------时间控制

luci-app-control-timewol ------------------定时唤醒

luci-app-control-webrestriction ------------------访问控制

luci-app-control-weburl -----------------网址过滤

luci-app-cpulimit ------------------CPU限制

luci-app-eqos ------------------EQS网速控制

luci-app-koolddns ------------------KOOL域名DNS解析工具

luci-app-koolproxyR ------------------经典去广告

luci-theme-opentomcat ------------------仿LEDE主题（适配18.06）

luci-theme-btmod ------------------btmod（适配18.06）

luci-theme-opentopd ------------------opentopd（适配18.06）

感谢LEAN大，感谢LEO大 等大神分享源码，你可以随意使用其中的源码，但请注明出处。
