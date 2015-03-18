#!/bin/bash

KER_NAME="Sooplus"
DAY=$(date +"%d")
MONTH=$(date +"%m")
BASE_KER_VER=$MONTH.$DAY
CODENAME="hammerhead"
AUTHOR="soorajj"
OUT_DIR=./kernel_flashable
IMG_OUT_DIR=./kernel_flashable/kernel
MODULE_DIR=./kernel_flashable/system/lib/modules
TOOLCHAIN_DIR=~/android/toolchain/arm-cortex_a15-linux-gnueabihf-linaro_4.9.3-2015.01/bin/arm-cortex_a15-linux-gnueabihf-
#TOOLCHAIN_DIR=~/android/toolchain/sm-arm-cortex_a15-eabi-4.9-master/bin/arm-eabi-
INITRAMFS_TMP=./initramfs
INITRAMFS_SOURCE=~/android/ramdisk1/
export LOCALVERSION="-"`echo $KER_NAME~$BASE_KER_VER`
export CROSS_COMPILE=$TOOLCHAIN_DIR
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER="soorajj"
export KBUILD_BUILD_HOST="me.com"
echo 
echo "Making defconfig"
DATE=$(date +"%d-%m-%Y-%H.%M.%S")
COMPILER="LINARO-4.9"
ARCHIVE_FILE="$KER_NAME~$BASE_KER_VER-$CODENAME-$COMPILER-$DATE"

#make "cyanogenmod_hammerhead_defconfig"
make "sooplus_defconfig"

echo "LOCALVERSION="$LOCALVERSION
echo "CROSS_COMPILE="$CROSS_COMPILE
echo "ARCH="$ARCH

echo "Start of build: $DATE...";
sleep 3
echo "kernel version: $KER_NAME~$BASE_KER_VER...";
script -q ~/android/logs/$ARCHIVE_FILE.txt -c "
make -j16 "

echo "Build completed."
echo "Copying zImage to root folder"
cp arch/arm/boot/zImage-dtb $IMG_OUT_DIR/zImage	
mkdir -p $MODULE_DIR
find . -name '*.ko' -exec cp '{}' $MODULE_DIR \;
echo "[BUILD]: Changing aroma version/data/device to: $ARCHIVE_FILE...";
sed -i "/ini_set(\"rom_name\",/c\ini_set(\"rom_name\", \""$KER_NAME"\");" $OUT_DIR/META-INF/com/google/android/aroma-config
sed -i "/ini_set(\"rom_version\",/c\ini_set(\"rom_version\", \""$BASE_KER_VER"\");" $OUT_DIR/META-INF/com/google/android/aroma-config
sed -i "/ini_set(\"rom_date\",/c\ini_set(\"rom_date\", \""$DATE"\");" $OUT_DIR/META-INF/com/google/android/aroma-config
sed -i "/ini_set(\"rom_device\",/c\ini_set(\"rom_device\", \""$CODENAME"\");" $OUT_DIR/META-INF/com/google/android/aroma-config
sed -i "/ini_set(\"rom_author\",/c\ini_set(\"rom_author\", \""$AUTHOR"\");" $OUT_DIR/META-INF/com/google/android/aroma-config

cd $OUT_DIR
find . -name '*zip' -exec cp '{}' ~/my-works/ \;
find . -name '*zip' -exec rm '{}' \;
zip -r `echo $ARCHIVE_FILE`.zip *
find . -name '*zip' -exec cp '{}' ~/my-works/ \;
find . -name '*zip' -exec rm '{}' \;
echo "Flashable zip made."
echo "cleaning."
find . -name '*ko' -exec rm '{}' \;
find . -name 'zImage' -exec rm '{}' \;
cd ../
make "clean"
make "mrproper"
echo "Remove previous files which should regenerate every time"
rm -f arch/arm/boot/*.dtb >> /dev/null;
rm -f arch/arm/boot/*.cmd >> /dev/null;
rm -f arch/arm/boot/zImage >> /dev/null;
rm -f arch/arm/boot/zImage-dtb >> /dev/null;
rm -f arch/arm/boot/Image >> /dev/null;
rm -f zImage >> /dev/null;
rm -f zImage-dtb >> /dev/null;
rm -f boot.img >> /dev/null;
rm -f ramdisk.gz >> /dev/null;
rm -f $IMG_OUT_DIR/zImage >> /dev/null;
git clean -f -d
git reset --hard
echo "everything completed."
echo "End of build: $DATE...";
exit
