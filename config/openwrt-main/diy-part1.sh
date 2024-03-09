#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (Before Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: main
#========================================================================================================================

# Add a feed source
# sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default
sed -i '$a src-git packages2 https://git.openwrt.org/feed/packages.git' feeds.conf.default
sed -i '$a src-git luci2 https://git.openwrt.org/project/luci.git' feeds.conf.default
sed -i '$a src-git routing2 https://git.openwrt.org/feed/routing.git' feeds.conf.default

# other
# rm -rf package/utils/{ucode,fbtest}

