#!/bin/bash
set -e

cp feeds.conf.default feeds.conf
echo "src-git qosmio https://github.com/qosmio/packages-extra" >> feeds.conf
./scripts/feeds update -a
./scripts/feeds install -a


cp nss-setup/config-nss.seed .config
echo 'CONFIG_TARGET_qualcommax_ipq807x_DEVICE_linksys_mx4300=y' >> .config
echo 'CONFIG_PACKAGE_luci-mod-status-nss=y' >> .config
make defconfig V=s
sed -i 's/^CONFIG_FEED_luci_extra=.*/# CONFIG_FEED_luci_extra is not set/' .config
sed -i 's/^CONFIG_FEED_qosmio=.*/# CONFIG_FEED_qosmio is not set/' .config
umask
umask 022
zstd --version
ls -al staging_dir/host/bin/
echo $PATH
#make tools/zstd/compile
#make tools/compile
ls -al staging_dir/host/bin/
#make package/qca-mcs/{clean,prepare,compile} V=s

patch -d feeds/nss_packages -p1 < SKIP_HASH_PATCH

make download -j$(nproc)
#make download -j1 V=s

#make -j1 V=s
make -j$(nproc)
