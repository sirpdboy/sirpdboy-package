[![若部分图片无法正常显示，请挂上机场浏览或点这里到末尾看修复教程](https://visitor-badge.glitch.me/badge?page_id=sirpdboy-visitor-badge)](#解决-github-网页上图片显示失败的问题) [![](https://img.shields.io/badge/TG群-点击加入-FFFFFF.svg)](https://t.me/joinchat/AAAAAEpRF88NfOK5vBXGBQ)
<a href="#readme">
    <img src="https://img.vim-cn.com/a1/8713845a4aa922ac96619b0d2fb3d6919d37fc.png" alt="图飞了😂" title="NetSpeedTest" align="right" height="180" />
</a>

![screenshots](https://raw.githubusercontent.com/sirpdboy/openwrt/master/doc/说明1.jpg)

[luci-app-NetSpeedTest — 网络速度测试2.0](https://github.com/sirpdboy/NetSpeedTest)
======================

[![](https://img.shields.io/badge/-目录:-696969.svg)](#readme) [![](https://img.shields.io/badge/-写在前面-F5F5F5.svg)](#写在前面-) [![](https://img.shields.io/badge/-编译说明-F5F5F5.svg)](#编译说明-) [![](https://img.shields.io/badge/-说明-F5F5F5.svg)](#说明-) [![](https://img.shields.io/badge/-捐助-F5F5F5.svg)](#捐助-) 

请 **认真阅读完毕** 本页面，本页面包含注意事项和如何使用。

a new netspeedtest luci app bese luci-app-netspeedtest
-

## 写在前面：[![](https://img.shields.io/badge/-写在前面-F5F5F5.svg)](#写在前面-)
	@@ -38,8 +40,6 @@ a new netspeedtest luci app bese luci-app-netspeedtest

10.新插件难免有bug 请不要大惊小怪。欢迎提交bug。

11.安装需要依赖： python3  iperf3 。

## 编译说明 [![](https://img.shields.io/badge/-编译说明-F5F5F5.svg)](#编译说明-) 

将NetSpeedTest 主题添加至 LEDE/OpenWRT 源码的方法。
	@@ -49,48 +49,45 @@ a new netspeedtest luci app bese luci-app-netspeedtest

```Brach
    # feeds获取源码：
    src-git netspeedtest  https://github.com/sirpdboy/netspeedtest
 ``` 
  ```Brach
   # 更新feeds，并安装主题：
    scripts/feeds update netspeedtest
	scripts/feeds install luci-app-netspeedtest
 ``` 	

## 下载源码方法二：
 ```Brach
    # 下载源码
    
    git clone https://github.com/sirpdboy/netspeedtest package/netspeedtest
    
    make menuconfig
 ``` 
## 配置菜单
 ```Brach
    make menuconfig
	# 找到 LuCI -> Applications, 选择 luci-app-netspeedtest, 保存后退出。
 ``` 
## 编译
 ```Brach 
    # 编译固件
    make package/netspeedtest/luci-app-netspeedtest/{clean,compile} V=s
```   

## 说明 [![](https://img.shields.io/badge/-说明-F5F5F5.svg)](#说明-)

源码来源：https://github.com/sirpdboy/netspeedtest/luci-app-netspeedtest

![screenshots](https://raw.githubusercontent.com/sirpdboy/openwrt/master/doc/说明2.jpg)

你可以随意使用其中的源码，但请注明出处。
============================


# My other project

网络速度测试 ：https://github.com/sirpdboy/NetSpeedTest

定时设置插件 : https://github.com/sirpdboy/luci-app-autotimeset

关机功能插件 : https://github.com/sirpdboy/luci-app-poweroffdevice

	@@ -102,18 +99,23 @@ btmob 主题: https://github.com/sirpdboy/luci-theme-btmob

系统高级设置 : https://github.com/sirpdboy/luci-app-advanced

ddns-go动态域名: https://github.com/sirpdboy/luci-app-ddns-go


## 捐助

![screenshots](https://raw.githubusercontent.com/sirpdboy/openwrt/master/doc/说明3.jpg)

|     <img src="https://img.shields.io/badge/-支付宝-F5F5F5.svg" href="#赞助支持本项目-" height="25" alt="图飞了😂"/>  |  <img src="https://img.shields.io/badge/-微信-F5F5F5.svg" height="25" alt="图飞了😂" href="#赞助支持本项目-"/>  | 
| :-----------------: | :-------------: |
|![xm1](https://raw.githubusercontent.com/sirpdboy/openwrt/master/doc/支付宝.png) | ![xm1](https://raw.githubusercontent.com/sirpdboy/openwrt/master/doc/微信.png) |

<a href="#readme">
    <img src="https://img.shields.io/badge/-返回顶部-orange.svg" alt="图飞了😂" title="返回顶部" align="right"/>
</a>
