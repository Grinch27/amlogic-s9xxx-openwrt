# 修改记录 (针对 s905d Phicomm-N1)

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