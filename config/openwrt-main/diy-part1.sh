#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (Before Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: main
#========================================================================================================================

# Add a feed source
# sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

# https://github.com/openwrt/openwrt/blob/main/feeds.conf.default
# https://github.com/coolsnowwolf/lede/blob/master/feeds.conf.default

# echo "
# src-git leanluci https://github.com/coolsnowwolf/luci.git
# src-git packages https://git.openwrt.org/feed/packages.git
# src-git luci https://git.openwrt.org/project/luci.git
# src-git routing https://git.openwrt.org/feed/routing.git
# src-git telephony https://git.openwrt.org/feed/telephony.git
# #src-git video https://github.com/openwrt/video.git
# #src-git targets https://github.com/openwrt/targets.git
# #src-git oldpackages http://git.openwrt.org/packages.git
# #src-link custom /usr/src/openwrt/custom-feed
# " > feeds.conf.default

# other
# rm -rf package/utils/{ucode,fbtest}

# ------------------------------- DIY -------------------------------

# Add luci-app-adguardhome
# rm -rf package/luci-app-adguardhome
# git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome

# # ----- coolsnowwolf/luci 克隆仓库到临时目录 -----
# git clone https://github.com/coolsnowwolf/luci.git package/coolsnowwolf/luci

# cp -rf ../luci/applications/luci-app-vlmcsd ./package/luci-app-vlmcsd

# # 复制需要的子目录到 package/ 目录

# # Add luci-app-vlmcsd
# cp -r package/coolsnowwolf/luci/applications/luci-app-vlmcsd package/luci-app-vlmcsd

# # Add luci-app-diskman
# cp -r package/coolsnowwolf/luci/applications/luci-app-diskman package/luci-app-diskman

# # 删除临时目录 coolsnowwolf/luci
# rm -rf package/coolsnowwolf/luci
