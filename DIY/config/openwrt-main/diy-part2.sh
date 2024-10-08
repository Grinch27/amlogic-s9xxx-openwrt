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
# sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

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

# Modify luci-app-amlogic/luci-app-amlogic/root/usr/sbin/openwrt-install-amlogic
# sed -i 's/ROOT1="960"/ROOT1="512"/g' package/luci-app-amlogic/luci-app-amlogic/root/usr/sbin/openwrt-install-amlogic
# sed -i 's/ROOT2="960"/ROOT2="1"/g' package/luci-app-amlogic/luci-app-amlogic/root/usr/sbin/openwrt-install-amlogic
# cat package/luci-app-amlogic/luci-app-amlogic/root/usr/sbin/openwrt-install-amlogic

#
# Apply patch
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------

# ------------------------------- DIY -------------------------------

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

# ---------- system packages ----------

# 无线Wifi支持
echo "
CONFIG_DRIVER_11AX_SUPPORT=y
CONFIG_WPA_MBO_SUPPORT=y
" >> .config

# wpad
echo "
CONFIG_PACKAGE_wpad=n
CONFIG_PACKAGE_wpad-basic=n
CONFIG_PACKAGE_wpad-basic-mbedtls=n
CONFIG_PACKAGE_wpad-basic-openssl=n
CONFIG_PACKAGE_wpad-basic-wolfssl=n
CONFIG_PACKAGE_wpad-mbedtls=n
CONFIG_PACKAGE_wpad-mesh-mbedtls=n
CONFIG_PACKAGE_wpad-mesh-openssl=n
CONFIG_PACKAGE_wpad-mesh-wolfssl=n
CONFIG_PACKAGE_wpad-mini=n
CONFIG_PACKAGE_wpad-openssl=y
CONFIG_PACKAGE_wpad-wolfssl=n
" >> .config

# iw
echo "
CONFIG_PACKAGE_iw=n
CONFIG_PACKAGE_iw-full=y
" >> .config

# dnsmasq
echo "
CONFIG_PACKAGE_dnsmasq=n
CONFIG_PACKAGE_dnsmasq-full=y
" >> .config

# libustream
echo "
CONFIG_PACKAGE_libustream-mbedtls=n
CONFIG_PACKAGE_libustream-openssl=y
CONFIG_PACKAGE_libustream-wolfssl=n
" >> .config

# swconfig
# echo "
# CONFIG_PACKAGE_swconfig=y
# CONFIG_PACKAGE_kmod-swconfig=y
# " >> .config

# nftables, abort iptables & xtables
echo "
CONFIG_PACKAGE_dnsmasq_full_nftset=y
CONFIG_DEFAULT_nftables=y
CONFIG_PACKAGE_miniupnpd-nftables=y
CONFIG_PACKAGE_nftables-json=y
CONFIG_PACKAGE_nftables-nojson=n

CONFIG_PACKAGE_ip6tables-nft=n
CONFIG_PACKAGE_iptables-mod-extra=n
CONFIG_PACKAGE_iptables-nft=n
CONFIG_PACKAGE_iptables-mod-tproxy=n
CONFIG_PACKAGE_kmod-ip6tables=n

CONFIG_PACKAGE_libip4tc=n
CONFIG_PACKAGE_libip6tc=n
CONFIG_PACKAGE_libiptext=n
CONFIG_PACKAGE_libiptext-nft=n
CONFIG_PACKAGE_libiptext6=n

CONFIG_PACKAGE_libxtables12=n
CONFIG_PACKAGE_libxtables=n
CONFIG_PACKAGE_xtables-nft=n

" >> .config

# ip-full
echo "
CONFIG_PACKAGE_ip-bridge=n
CONFIG_PACKAGE_ip-full=y
CONFIG_PACKAGE_ip-tiny=n
" >> .config

# bridge
echo "
CONFIG_PACKAGE_bridge=y
" >> .config

# openssl
echo "
CONFIG_PACKAGE_openssl-util=y
" >> .config

# ---------- install ----------

# nginx Luci安装选项 删除 uhttpd
echo "
# CONFIG_PACKAGE_luci-ssl-nginx=y
CONFIG_PACKAGE_luci-nginx=y
CONFIG_PACKAGE_luci-app-uhttpd=n
CONFIG_PACKAGE_uhttpd=n
CONFIG_PACKAGE_uhttpd-mod-ubus=n
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
    option access_log 'off'
" > ./files/etc/config/nginx

# Old Luci
echo "
CONFIG_PACKAGE_luci-compat=y
" >> .config

# haproxy
echo "
CONFIG_PACKAGE_haproxy=y
" >> .config

# dos2unix unix2dos
echo "
CONFIG_BUSYBOX_DEFAULT_DOS2UNIX=y
CONFIG_PACKAGE_dos2unix=y
CONFIG_BUSYBOX_DEFAULT_UNIX2DOS=y
CONFIG_PACKAGE_unix2dos=y
" >> .config

# lrzsz
echo "
CONFIG_PACKAGE_lrzsz=y
" >> .config

# vim-full
# sed -i 's/CONFIG_PACKAGE_vim=y/CONFIG_PACKAGE_vim=n/' .config
echo "
CONFIG_PACKAGE_vim=n
CONFIG_PACKAGE_vim-full=y
" >> .config

# tcpdump
echo "
CONFIG_PACKAGE_tcpdump=y
" >> .config

# fail2ban
# echo "
# CONFIG_PACKAGE_fail2ban=y
# " >> .config

# https-dns-proxy
echo "
CONFIG_PACKAGE_luci-app-https-dns-proxy=y
CONFIG_PACKAGE_https-dns-proxy=y
" >> .config

# udpxy
echo "
CONFIG_PACKAGE_luci-app-udpxy=y
CONFIG_PACKAGE_udpxy=y
" >> .config

# squid
echo "
CONFIG_PACKAGE_luci-app-squid=y
CONFIG_PACKAGE_squid=y
" >> .config

# privoxy
echo "
CONFIG_PACKAGE_luci-app-privoxy=y
CONFIG_PACKAGE_privoxy=y
" >> .config

# iperf3
echo "
CONFIG_PACKAGE_iperf=n
CONFIG_PACKAGE_iperf3=y
CONFIG_PACKAGE_iperf3-ssl=n
" >> .config

# Immortalwrt
echo "
CONFIG_PACKAGE_6in4=y
CONFIG_PACKAGE_block-mount=y
# CONFIG_PACKAGE_kmod-crypto-arc4=n
# CONFIG_PACKAGE_kmod-crypto-ecb=n
CONFIG_PACKAGE_kmod-crypto-user=y
CONFIG_PACKAGE_kmod-cryptodev=y
CONFIG_PACKAGE_kmod-macvlan=y
# CONFIG_PACKAGE_kmod-mppe=n
CONFIG_PACKAGE_kmod-sit=y
" >> .config

# ---------- uninstall ----------

# 删除 transmission
echo "
CONFIG_PACKAGE_luci-app-transmission=n
CONFIG_PACKAGE_luci-i18n-transmission-zh-cn=n
CONFIG_PACKAGE_transmission-daemon=n
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

# 删除openvpn
echo "
CONFIG_PACKAGE_luci-app-openvpn=n
CONFIG_PACKAGE_luci-i18n-openvpn-zh-cn=n
" >> .config

# 删除iptables ip6tables
# ----- opkg whatdepends -----
# kmod-ipt-core
# kmod-ipt-conntrack
# kmod-ipt-nat
# kmod-ipt-nat6
# kmod-ipt-extra
# kmod-ipt-tproxy
# kmod-ipt-physdev
# kmod-nf-ipt
# kmod-nf-ipt6
# kmod-br-netfilter
# kmod-ip6tables
# kmod-ipt-ipset
# ipset
# libipset13
# kmod-nft-compat
echo "
CONFIG_PACKAGE_kmod-ipt-core=n
CONFIG_PACKAGE_kmod-ipt-conntrack=n
CONFIG_PACKAGE_kmod-ipt-nat=n
CONFIG_PACKAGE_kmod-ipt-nat-extra=n
CONFIG_PACKAGE_kmod-ipt-nat6=n
CONFIG_PACKAGE_kmod-ipt-extra=n
CONFIG_PACKAGE_kmod-ipt-tproxy=n
CONFIG_PACKAGE_kmod-ipt-physdev=n
CONFIG_PACKAGE_kmod-nf-ipt=n
CONFIG_PACKAGE_kmod-nf-ipt6=n
CONFIG_PACKAGE_kmod-nf-ipvs=n
CONFIG_PACKAGE_kmod-br-netfilter=n
CONFIG_PACKAGE_kmod-ip6tables=n
CONFIG_PACKAGE_kmod-ip6tables-extra=n
CONFIG_PACKAGE_ipset=n
CONFIG_PACKAGE_kmod-ipt-ipset=n
CONFIG_PACKAGE_libipset=n
CONFIG_PACKAGE_kmod-nft-compat=n
" >> .config


# ----- dockerd remove iptables -----

# ----- dockerd remove iptables -----
apply_dockerd_patch_sed() {
    # 定义目标文件的路径
    local patch_target="feeds/packages/utils/dockerd/Makefile"
    patch_target="$(realpath "$patch_target")"

    # 打印当前目标文件内容
    echo "Original file content:"
    cat "$patch_target"

    # 使用 sed 删除指定行
    echo "Applying sed commands to remove iptables dependencies..."
    sed -i '/+iptables \\/d' "$patch_target"
    sed -i '/+iptables-mod-extra \\/d' "$patch_target"
    sed -i '/+IPV6:ip6tables \\/d' "$patch_target"
    sed -i '/+IPV6:kmod-ipt-nat6 \\/d' "$patch_target"
    sed -i '/+kmod-ipt-nat \\/d' "$patch_target"
    sed -i '/+kmod-ipt-physdev \\/d' "$patch_target"
    sed -i '/+kmod-nf-ipvs \\/d' "$patch_target"

    # 打印修改后的目标文件内容
    echo "Modified file content:"
    cat "$patch_target"
}
apply_dockerd_patch_sed


# ---------- sync config ----------
make oldconfig
cat ./.config

# ---------- /pattern/s/old/new/' file ----------
# remove iptables & xtables
# sed -i '/CONFIG_PACKAGE_ip6tables-nft=/s/^.*$/CONFIG_PACKAGE_ip6tables-nft=n/' .config
# sed -i '/CONFIG_PACKAGE_iptables-mod-extra=/s/^.*$/CONFIG_PACKAGE_iptables-mod-extra=n/' .config
# sed -i '/CONFIG_PACKAGE_iptables-nft=/s/^.*$/CONFIG_PACKAGE_iptables-nft=n/' .config
# sed -i '/CONFIG_PACKAGE_iptables-mod-tproxy=/s/^.*$/CONFIG_PACKAGE_iptables-mod-tproxy=n/' .config
# sed -i '/CONFIG_PACKAGE_kmod-ip6tables=/s/^.*$/CONFIG_PACKAGE_kmod-ip6tables=n/' .config

# sed -i '/CONFIG_PACKAGE_libip4tc=/s/^.*$/CONFIG_PACKAGE_libip4tc=n/' .config
# sed -i '/CONFIG_PACKAGE_libip6tc=/s/^.*$/CONFIG_PACKAGE_libip6tc=n/' .config
# sed -i '/CONFIG_PACKAGE_libiptext=/s/^.*$/CONFIG_PACKAGE_libiptext=n/' .config
# sed -i '/CONFIG_PACKAGE_libiptext-nft=/s/^.*$/CONFIG_PACKAGE_libiptext-nft=n/' .config
# sed -i '/CONFIG_PACKAGE_libiptext6=/s/^.*$/CONFIG_PACKAGE_libiptext6=n/' .config

# sed -i '/CONFIG_PACKAGE_libxtables12=/s/^.*$/CONFIG_PACKAGE_libxtables12=n/' .config
# sed -i '/CONFIG_PACKAGE_libxtables=/s/^.*$/CONFIG_PACKAGE_libxtables=n/' .config
# sed -i '/CONFIG_PACKAGE_xtables-nft=/s/^.*$/CONFIG_PACKAGE_xtables-nft=n/' .config

# # remove uhttpd
# sed -i '/CONFIG_PACKAGE_uhttpd=/s/^.*$/CONFIG_PACKAGE_uhttpd=n/' .config
# sed -i '/CONFIG_PACKAGE_uhttpd-mod-ubus=/s/^.*$/CONFIG_PACKAGE_uhttpd-mod-ubus=n/' .config
