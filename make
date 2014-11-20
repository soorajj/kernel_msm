#!/bin/bash

BASE_KER_VER="Sooplus~1.0.2"
export LOCALVERSION="-"`echo $BASE_KER_VER`
export CROSS_COMPILE=~/work/toolchain/arm-cortex_a15-linux-gnueabihf-linaro_4.9.2-2014.09/bin/arm-cortex_a15-linux-gnueabihf-
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=soorajj
export KBUILD_BUILD_HOST="me.com"
echo 
echo "Making defconfig"
DATE_START=$(date +"%s")
DATE=$(date +"%d-%m-%Y")
COMPILER="LINARO"
ARCHIVE_FILE="$BASE_KER_VER-$COMPILER-$DATE"

make "sooplus_defconfig"

echo "LOCALVERSION="$LOCALVERSION
echo "CROSS_COMPILE="$CROSS_COMPILE
echo "ARCH="$ARCH

make -j16 > /dev/null

echo "Build completed."
echo "Copying zImage to flashable zip."
cp arch/arm/boot/zImage-dtb kernel_flashable/kernel/zImage
find . -name '*ko' -exec cp '{}' kernel_flashable/system/lib/modules/ \;
cd kernel_flashable
find . -name '*zip' -exec cp '{}' ~/my-works/ \;
find . -name '*zip' -exec rm '{}' \;
zip -r `echo $ARCHIVE_FILE`.zip *
echo "Flashable zip made."
echo "cleaning."
find . -name '*ko' -exec rm '{}' \;
find . -name 'zImage' -exec rm '{}' \;
cd
cd ~/work/kernel_source/kernel_msm
make "clean"
make "mrproper"
echo "everything completed."
