#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (Before Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: main
#========================================================================================================================

# Add a feed source
# sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

# other
# rm -rf package/utils/{ucode,fbtest}

# ------------------------------- DIY -------------------------------

# Add luci-app-adguardhome
# rm -rf package/luci-app-adguardhome
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome

# # ----- coolsnowwolf/luci 克隆仓库到临时目录 -----
# git clone https://github.com/coolsnowwolf/luci.git package/coolsnowwolf/luci

# cp -rf ../luci/applications/luci-app-vlmcsd ./package/luci-app-vlmcsd

# # 复制需要的子目录到 package/ 目录

# # Add luci-app-vlmcsd
# cp -r package/coolsnowwolf/luci/applications/luci-app-vlmcsd package/luci-app-vlmcsd

git clone https://github.com/mchome/luci-app-vlmcsd.git package/luci-app-vlmcsd

# # Add luci-app-diskman
# cp -r package/coolsnowwolf/luci/applications/luci-app-diskman package/luci-app-diskman

git clone https://github.com/lisaac/luci-app-diskman.git package/luci-app-diskman

# # 删除临时目录 coolsnowwolf/luci
# rm -rf package/coolsnowwolf/luci