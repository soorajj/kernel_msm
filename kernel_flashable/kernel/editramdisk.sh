#!/sbin/sh

mkdir /tmp/ramdisk
cp /tmp/boot.img-ramdisk.gz /tmp/ramdisk/
cd /tmp/ramdisk/
gunzip -c /tmp/ramdisk/boot.img-ramdisk.gz | cpio -i
rm /tmp/ramdisk/boot.img-ramdisk.gz
rm /tmp/boot.img-ramdisk.gz

#Start sooplus script
if [ $(grep -c "import /init.sooplus.rc" /tmp/ramdisk/init.rc) == 0 ]; then
   sed -i "/import \/init\.trace\.rc/aimport /init.sooplus.rc" /tmp/ramdisk/init.rc
fi

#copy sooplus scripts
cp /tmp/sooplus.sh /tmp/ramdisk/sbin/sooplus.sh
chmod 755 /tmp/ramdisk/sbin/sooplus.sh
cp /tmp/init.sooplus.rc /tmp/ramdisk/init.sooplus.rc

if [ $(grep -c "seclabel u:r:install_recovery:s0" /tmp/ramdisk/init.rc) == 0 ]; then
   sed -i "s/seclabel u:r:install_recovery:s0/#seclabel u:r:install_recovery:s0/" /tmp/ramdisk/init.rc
fi

echo "xprivacy453 u:object_r:system_server_service:s0\n" >> /tmp/service_contexts

sed -i '/\/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_governor/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/\/sys\/devices\/system\/cpu\/cpu1\/cpufreq\/scaling_governor/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/\/sys\/devices\/system\/cpu\/cpu2\/cpufreq\/scaling_governor/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/\/sys\/devices\/system\/cpu\/cpu3\/cpufreq\/scaling_governor/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/\/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_min_freq/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/\/sys\/devices\/system\/cpu\/cpu1\/cpufreq\/scaling_min_freq/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/\/sys\/devices\/system\/cpu\/cpu2\/cpufreq\/scaling_min_freq/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/\/sys\/devices\/system\/cpu\/cpu3\/cpufreq\/scaling_min_freq/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/# cpu-boost/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/\/sys\/module\/cpu_boost\/parameters\/boost_ms/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/\/sys\/module\/cpu_boost\/parameters\/sync_threshold/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/\/sys\/module\/cpu_boost\/parameters\/input_boost_freq/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/\/sys\/module\/cpu_boost\/parameters\/plug_boost_freq/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/\/sys\/module\/cpu_boost\/parameters\/input_boost_ms/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/\/sys\/module\/cpu_boost\/parameters\/load_based_syncs/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/\/sys\/devices\/system\/cpu\/cpufreq\/ondemand/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/\/sys\/devices\/system\/cpu\/cpufreq\/interactive/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/# ondemand/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/# interactive/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/# sooplus extras/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/write /sys/module/dsi_panel/kgamma_bn "0 12 19 30 39 48 56 72 82 104 118 127 119 116 115 106 84 78 66 60 44 35 20"/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/write /sys/module/dsi_panel/kgamma_bp "0 12 19 30 39 48 56 72 82 104 118 131 120 116 114 107 100 78 66 60 44 35 20"/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/write /sys/module/dsi_panel/kgamma_gn "0 12 20 31 40 55 62 76 89 109 123 132 115 113 111 103 78 75 67 58 49 39 21"/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/write /sys/module/dsi_panel/kgamma_gp "0 12 20 31 40 55 62 79 84 109 123 134 116 112 112 104 101 76 67 58 49 39 21"/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/write /sys/module/dsi_panel/kgamma_rn "0 12 19 30 39 48 56 72 83 105 119 130 119 115 116 106 88 80 71 62 52 42 25"/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/write /sys/module/dsi_panel/kgamma_rp "0 12 19 30 39 48 56 72 83 105 121 130 118 115 114 108 100 80 66 60 48 38 22"/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/write /sys/module/dsi_panel/kgamma_w "32"/d' /tmp/ramdisk/init.hammerhead.rc
sed -i '/^$/N;/^\n$/D' /tmp/ramdisk/init.hammerhead.rc
cp /tmp/fstab /tmp/ramdisk/fstab.hammerhead

find . | cpio -o -H newc | gzip > /tmp/boot.img-ramdisk.gz
rm -r /tmp/ramdisk

