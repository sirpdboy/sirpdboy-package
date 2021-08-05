# luci-app-adblock-plus
依赖于dnsmasq-full，与默认的dnsmasq冲突，所以编译时请取消勾选base-system -> dnsmasq

另外如果是通过sdk编译好以后给已有的固件安装，需要确保固件的curl或者curl的安装包支持https，测试方法：

进入SSH，输入 curl -V 2>/dev/null | grep -F https ，如果返回的Protocols里面包含https，才可以正常下载规则。


不欢迎Graypang（小鸡过河）（ https://github.com/garypang13 ） 与任何使用他固件代码的人使用我的项目，此人人品恶劣至极， https://www.right.com.cn/forum/thread-4875076-1-1.html ，无法形容！
