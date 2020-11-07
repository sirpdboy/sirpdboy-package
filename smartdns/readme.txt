https://github.com/pymumu/luci-app-smartdns


./scripts/feeds update -a && ./scripts/feeds install -a
LUCIBRANCH="lede"
make package/feeds/luci/applications/luci-app-smartdns/compile
