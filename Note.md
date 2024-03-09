# 修改记录 (针对 s905d Phicomm-N1)

## 添加软件源 git.openwrt.org

<!-- src-git packages https://github.com/coolsnowwolf/packages
src-git luci https://github.com/coolsnowwolf/luci
src-git routing https://github.com/coolsnowwolf/routing
src-git telephony https://git.openwrt.org/feed/telephony.git
#src-git helloworld https://github.com/fw876/helloworld.git
#src-git oui https://github.com/zhaojh329/oui.git
#src-git video https://github.com/openwrt/video.git
#src-git targets https://github.com/openwrt/targets.git
#src-git oldpackages http://git.openwrt.org/packages.git
#src-link custom /usr/src/openwrt/custom-feed -->

- ### amlogic-s9xxx-openwrt\config\lede-master\diy-part1.sh 文件设置

sed -i '$a src-git packages2 https://git.openwrt.org/feed/packages.git' feeds.conf.default
sed -i '$a src-git luci2 https://git.openwrt.org/project/luci.git' feeds.conf.default
sed -i '$a src-git routing2 https://git.openwrt.org/feed/routing.git' feeds.conf.default

## 使用adguardhome替换adbyby

- ### amlogic-s9xxx-openwrt\config\lede-master\config 文件设置

修改删除adbyby
CONFIG_PACKAGE_luci-app-adbyby-plus=y -> # CONFIG_PACKAGE_luci-app-adbyby-plus is not set
CONFIG_PACKAGE_luci-i18n-adbyby-plus-zh-cn=y -> # CONFIG_PACKAGE_luci-i18n-adbyby-plus-zh-cn is not set
CONFIG_PACKAGE_adbyby=y -> # CONFIG_PACKAGE_adbyby is not set

添加adguardhome
CONFIG_PACKAGE_luci-app-adguardhome=y

- ### amlogic-s9xxx-openwrt\config\lede-master\diy-part2.sh 文件设置

引入软件包仓库
\# Add luci-app-adguardhome
rm -rf package/luci-app-adguardhome
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome
\#

## 剔除 syncdial多线多拨 mwan3负载均衡

- ### amlogic-s9xxx-openwrt\config\lede-master\config 文件设置

修改删除syncdial多线多拨
CONFIG_PACKAGE_luci-app-syncdial=y -> # CONFIG_PACKAGE_luci-app-syncdial is not set

修改删除mwan3负载均衡
CONFIG_PACKAGE_mwan3=y -> # CONFIG_PACKAGE_mwan3 is not set
CONFIG_PACKAGE_luci-app-mwan3=y -> # CONFIG_PACKAGE_luci-app-mwan3 is not set
CONFIG_PACKAGE_luci-i18n-mwan3-zh-cn=y -> # CONFIG_PACKAGE_luci-i18n-mwan3-zh-cn is not set

## 剔除 autoreboot

- ### amlogic-s9xxx-openwrt\config\lede-master\config 文件设置

CONFIG_DEFAULT_luci-app-autoreboot=y -> # CONFIG_DEFAULT_luci-app-autoreboot is not set
CONFIG_PACKAGE_luci-app-autoreboot=y -> # CONFIG_PACKAGE_luci-app-autoreboot is not set
CONFIG_PACKAGE_luci-i18n-autoreboot-zh-cn=y -> # CONFIG_PACKAGE_luci-i18n-autoreboot-zh-cn is not set

## 添加 dos2unix unix2dos

- ### amlogic-s9xxx-openwrt\config\lede-master\config 文件设置

添加dos2unix
\# CONFIG_BUSYBOX_DEFAULT_DOS2UNIX is not set -> CONFIG_BUSYBOX_DEFAULT_DOS2UNIX=y
\# CONFIG_PACKAGE_dos2unix is not set -> CONFIG_PACKAGE_dos2unix=y

添加unix2dos
\# CONFIG_BUSYBOX_DEFAULT_UNIX2DOS is not set -> CONFIG_BUSYBOX_DEFAULT_UNIX2DOS=y
\# CONFIG_PACKAGE_unix2dos is not set -> CONFIG_PACKAGE_unix2dos=y

## 添加 ipv6helper

- ### amlogic-s9xxx-openwrt\config\lede-master\config 文件设置

\# CONFIG_PACKAGE_ipv6helper is not set -> CONFIG_PACKAGE_ipv6helper=y

## 使用 nginx 替换 uhttpd

- ### amlogic-s9xxx-openwrt\config\lede-master\config 文件设置

删除uhttpd
\# CONFIG_PACKAGE_uhttpd is not set
\# CONFIG_PACKAGE_uhttpd-mod-ubus is not set

Luci安装选项
\# CONFIG_PACKAGE_luci-nginx is not set
CONFIG_PACKAGE_luci-ssl-nginx=y

添加nginx支持
CONFIG_PACKAGE_nginx=y
CONFIG_PACKAGE_nginx-util=y
CONFIG_PACKAGE_nginx-all-module=y
CONFIG_PACKAGE_nginx-mod-luci=y
CONFIG_PACKAGE_nginx-mod-luci-ssl=y
CONFIG_PACKAGE_nginx-ssl=y
CONFIG_PACKAGE_nginx-ssl-util=y

CONFIG_PACKAGE_uwsgi=y
CONFIG_PACKAGE_uwsgi-cgi-plugin=y
CONFIG_PACKAGE_uwsgi-luci-support=y
CONFIG_PACKAGE_uwsgi-syslog-plugin=y

CONFIG_PACKAGE_php8=y
CONFIG_PACKAGE_libopenssl-conf=y
CONFIG_PACKAGE_openssl-util=y