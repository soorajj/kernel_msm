#!/sbin/sh

/sbin/busybox mkdir -p /data/media/0/Kernel_backup/;

/sbin/busybox dd if=/dev/block/platform/msm_sdcc.1/by-name/boot of=/tmp/pre_sooplus_boot.img;
cd /tmp;

/system/xbin/7za a -tzip /tmp/Pre_sooplus_kernel_restore.zip pre_sooplus_boot.img META-INF/;

rm -f /data/media/0/Kernel_backup/Pre_sooplus_kernel_restore.zip;
mv -f Pre_sooplus_kernel_restore.zip /data/media/0/Kernel_backup/
