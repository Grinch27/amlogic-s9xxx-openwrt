#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: main
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='official'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
rm -rf package/luci-app-amlogic
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
#
# Apply patch
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------

# ------------------------------- DIY -------------------------------

# luci-app-amlogic/root/usr/sbin/openwrt-install-amlogic

# Add luci-app-adguardhome
rm -rf package/luci-app-adguardhome
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome
echo "
CONFIG_PACKAGE_luci-app-adguardhome=y
" >> .config

# https://github.com/coolsnowwolf/luci.git
# git clone https://github.com/coolsnowwolf/luci.git
# cp -r ~/lede/package/lean ~/openwrt/package/lean

# Add luci-app-vlmcsd
# git clone https://github.com/mchome/luci-app-vlmcsd.git package/luci-app-vlmcsd
# echo "
# CONFIG_PACKAGE_luci-app-vlmcsd=y
# " >> .config

# Add luci-app-diskman
# git clone https://github.com/lisaac/luci-app-diskman.git package/luci-app-diskman
# echo "
# CONFIG_PACKAGE_luci-app-diskman=y
# " >> .config

# 无线Wifi支持
echo "
CONFIG_DRIVER_11AX_SUPPORT=y

CONFIG_WPA_MBO_SUPPORT=y

CONFIG_PACKAGE_wpad=n
CONFIG_PACKAGE_wpad-basic=n
CONFIG_PACKAGE_wpad-basic-mbedtls=n
CONFIG_PACKAGE_wpad-basic-openssl=n
CONFIG_PACKAGE_wpad-basic-wolfssl=n
CONFIG_PACKAGE_wpad-mbedtls=n
CONFIG_PACKAGE_wpad-mesh-mbedtls=n
CONFIG_PACKAGE_wpad-mesh-openssl=n
CONFIG_PACKAGE_wpad-mesh-wolfssl=y
CONFIG_PACKAGE_wpad-mini=n
CONFIG_PACKAGE_wpad-openssl=n
CONFIG_PACKAGE_wpad-wolfssl=n
" >> .config

# 删除 uhttpd
# sed -i 's/CONFIG_PACKAGE_uhttpd=y/CONFIG_PACKAGE_uhttpd=n/' .config
# sed -i 's/CONFIG_PACKAGE_uhttpd-mod-ubus=y/CONFIG_PACKAGE_uhttpd-mod-ubus=n/' .config
echo "
CONFIG_PACKAGE_uhttpd=n
CONFIG_PACKAGE_uhttpd-mod-ubus=n
" >> .config

# nginx Luci安装选项
echo "
CONFIG_PACKAGE_luci-ssl-nginx=y
" >> .config

mkdir -p ./files/etc/config
echo "
config main global
	option uci_enable 'true'

config server '_lan'
    list listen '80 default_server'
    list listen '[::]:80 default_server'
    option server_name '_lan'
    list include 'restrict_locally'
    list include 'conf.d/*.locations'
    option access_log 'off; # logd openwrt'

# config server '_redirect2ssl'
# 	#list listen '80'
# 	#list listen '[::]:80'
# 	#option server_name '_redirect2ssl'
# 	#option return '302 https://$host$request_uri'
	
# config server '_ssl'
# 	list listen '443 ssl'
# 	list listen '[::]:443 ssl'
# 	option server_name '_ssl'
# 	list include 'conf.d/*.locations'
# 	option ssl_certificate '/etc/nginx/conf.d/_lan.crt'
# 	option ssl_certificate_key '/etc/nginx/conf.d/_lan.key'
# 	option ssl_session_cache 'shared:SSL:32k'
# 	option ssl_session_timeout '64m'
# 	option access_log 'off; # logd openwrt'
" > ./files/etc/config/nginx

# 添加 haproxy
echo "
CONFIG_PACKAGE_haproxy=y
" >> .config

# 删除 transmission
# sed -i 's/CONFIG_PACKAGE_luci-app-transmission=y/CONFIG_PACKAGE_luci-app-transmission=n/' .config
# sed -i 's/CONFIG_PACKAGE_luci-i18n-transmission-zh-cn=y/CONFIG_PACKAGE_luci-i18n-transmission-zh-cn=n/' .config
# sed -i 's/CONFIG_PACKAGE_transmission-daemon=y/CONFIG_PACKAGE_transmission-daemon=n/' .config
echo "
CONFIG_PACKAGE_luci-app-transmission=n
CONFIG_PACKAGE_luci-i18n-transmission-zh-cn=n
CONFIG_PACKAGE_transmission-daemon=n
" >> .config

# 添加 dos2unix unix2dos
echo "
CONFIG_BUSYBOX_DEFAULT_DOS2UNIX=y
CONFIG_PACKAGE_dos2unix=y

CONFIG_BUSYBOX_DEFAULT_UNIX2DOS=y
CONFIG_PACKAGE_unix2dos=y
" >> .config

# 添加 lrzsz
echo "
CONFIG_PACKAGE_lrzsz=y
" >> .config

# 使用 vim-full 替换 vim
# sed -i 's/CONFIG_PACKAGE_vim=y/CONFIG_PACKAGE_vim=n/' .config
echo "
CONFIG_PACKAGE_vim=n
CONFIG_PACKAGE_vim-full=y
" >> .config

# 添加 tcpdump
echo "
CONFIG_PACKAGE_tcpdump=y
" >> .config

# 添加 fail2ban
echo "
CONFIG_PACKAGE_fail2ban=y
" >> .config

# 添加 udpxy
echo "
CONFIG_PACKAGE_luci-app-udpxy=y
CONFIG_PACKAGE_udpxy=y
" >> .config

# 删除 frpc frps
echo "
CONFIG_PACKAGE_frpc=n
CONFIG_PACKAGE_frps=n
CONFIG_PACKAGE_luci-app-frpc=n
CONFIG_PACKAGE_luci-app-frps=n
CONFIG_PACKAGE_luci-i18n-frpc-zh-cn=n
CONFIG_PACKAGE_luci-i18n-frps-zh-cn=n
" >> .config

# 删除 ddns
echo "
CONFIG_PACKAGE_luci-app-ddns=n
CONFIG_PACKAGE_luci-i18n-ddns-zh-cn=n
CONFIG_PACKAGE_ddns-scripts=n
CONFIG_PACKAGE_ddns-scripts-services=n
" >> .config
