#!/system/bin/sh

SOOPLUS_CONF=/system/etc/sooplus.conf
SOOPLUS_LOGFILE=/sdcard/sooplus.log
SLP="`grep SLEEP $SOOPLUS_CONF | cut -d '=' -f2`"

# Mount root as RW to apply tweaks and settings
mount -t rootfs -o remount,rw rootfs;
mount -o remount,rw /;
mount -o rw,remount /system

if [ -e /sdcard/sooplus.log ] ; then
	mv /sdcard/sooplus.log /sdcard/.sooplus.log
fi

echo $(date) >> $SOOPLUS_LOGFILE

#Find PVS bin
PVS="`cat /sys/module/acpuclock_krait/parameters/pvs_number`"
echo "PVS: $PVS" | tee -a $SOOPLUS_LOGFILE;

if [ -e /system/bin/thermal-engine-hh_bck ] ; then
	mv /system/bin/thermal-engine-hh_bck /system/bin/thermal-engine-hh
	echo "/system/bin/thermal-engine-hh_bck moved to /system/bin/thermal-engine-hh" | tee -a $SOOPLUS_LOGFILE;
fi

if [ -e /system/bin/mpdecision_bck ] ; then
	mv /system/bin/mpdecision_bck /system/bin/mpdecision
	echo "/system/bin/mpdecision_bck moved to /system/bin/mpdecision" | tee -a $SOOPLUS_LOGFILE;
fi

if [ ! -e /system/etc/init.d ]; then
	mkdir /system/etc/init.d
	chown -R root.root /system/etc/init.d
	chmod -R 755 /system/etc/init.d
	echo "init.d folder created and permission set to 755" | tee -a $SOOPLUS_LOGFILE;
fi;

#Set hotplugging
if [ "`grep HOTPLUG=1 $SOOPLUS_CONF`" ]; then
  stop mpdecision
  echo 0 > /sys/kernel/msm_mpdecision/conf/enabled
  echo 0 > /sys/kernel/msm_mpdecision/conf/scroff_single_core
  echo 1 > /sys/devices/platform/msm_sleeper/enabled
  echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/screen_off_max
  echo 960000 > /sys/devices/system/cpu/cpu0/cpufreq/screen_off_max_freq
  echo "msm_sleeper hotplug enabled" | tee -a $SOOPLUS_LOGFILE;
elif [ "`grep HOTPLUG=0 $SOOPLUS_CONF`" ]; then
  echo 0 > /sys/kernel/msm_mpdecision/conf/enabled
  echo 0 > /sys/kernel/msm_mpdecision/conf/scroff_single_core
  echo 0 > /sys/devices/platform/msm_sleeper/enabled
  echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/screen_off_max
  echo 960000 > /sys/devices/system/cpu/cpu0/cpufreq/screen_off_max_freq
  echo 20 > /sys/module/cpu_boost/parameters/boost_ms
  echo 1497600 > /sys/module/cpu_boost/parameters/sync_threshold
  echo 1190400 > /sys/module/cpu_boost/parameters/input_boost_freq
  echo 500 > /sys/module/cpu_boost/parameters/input_boost_ms
  start mpdecision
  echo "qcom mpdecision hotplug enabled" | tee -a $SOOPLUS_LOGFILE;
elif [ "`grep HOTPLUG=2 $SOOPLUS_CONF`" ]; then
  stop mpdecision
  echo 0 > /sys/devices/platform/msm_sleeper/enabled
  echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/screen_off_max
  echo 1 > /sys/kernel/msm_mpdecision/conf/enabled
  echo 1 > /sys/kernel/msm_mpdecision/conf/scroff_single_core
  echo "bricked_hotplug enabled" | tee -a $SOOPLUS_LOGFILE;
fi

#exFAT support
if [ "`grep EXFAT=1 $SOOPLUS_CONF`" ]; then
  insmod /system/lib/modules/exfat.ko;
  echo "exfat module loaded" | tee -a $SOOPLUS_LOGFILE;
fi

#disable wake gestures on lollipop
echo 0 > /sys/android_touch/wake_gestures

# Governor
if [ "`grep CPU=1 $SOOPLUS_CONF`" ]; then
  echo 1 > /sys/devices/system/cpu/cpu0/online;
  echo interactive > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
  echo 1 > /sys/devices/system/cpu/cpu1/online;
  echo interactive > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
  echo 1 > /sys/devices/system/cpu/cpu2/online;
  echo interactive > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
  echo 1 > /sys/devices/system/cpu/cpu3/online;
  echo interactive > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
  echo "20000 1400000:40000 1700000:20000" > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay;
  echo 90 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load;
  echo 1190400 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq;
  echo 1 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy;
  echo "85 1500000:90 1800000:70" > /sys/devices/system/cpu/cpufreq/interactive/target_loads;
  echo 40000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time;
  echo 20000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate;
  echo 30000 > /sys/devices/system/cpu/cpufreq/interactive/timer_slack;
  echo 100000 > /sys/devices/system/cpu/cpufreq/interactive/max_freq_hysteresis;
  echo 1190400 > /sys/devices/system/cpu/cpufreq/interactive/input_boost_freq;
  echo 250000 > /sys/devices/system/cpu/cpufreq/interactive/boostpulse_duration;
  echo 20 > /sys/module/cpu_boost/parameters/boost_ms
  echo 1497600 > /sys/module/cpu_boost/parameters/sync_threshold
  echo 1190400 > /sys/module/cpu_boost/parameters/input_boost_freq
  echo 500 > /sys/module/cpu_boost/parameters/input_boost_ms
  echo "interactive CPU governor" | tee -a $SOOPLUS_LOGFILE;
elif [ "`grep CPU=2 $SOOPLUS_CONF`" ]; then
  echo 1 > /sys/devices/system/cpu/cpu0/online;
  echo conservative > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
  echo 1 > /sys/devices/system/cpu/cpu1/online;
  echo conservative > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
  echo 1 > /sys/devices/system/cpu/cpu2/online;
  echo conservative > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
  echo 1 > /sys/devices/system/cpu/cpu3/online;
  echo conservative > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
  echo "conservative CPU governor" | tee -a $SOOPLUS_LOGFILE;
elif [ "`grep CPU=3 $SOOPLUS_CONF`" ]; then
  echo 1 > /sys/devices/system/cpu/cpu0/online;
  echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
  echo 1 > /sys/devices/system/cpu/cpu1/online;
  echo ondemand > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
  echo 1 > /sys/devices/system/cpu/cpu2/online;
  echo ondemand > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
  echo 1 > /sys/devices/system/cpu/cpu3/online;
  echo ondemand > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
  echo "ondemand CPU governor" | tee -a $SOOPLUS_LOGFILE;
else
  echo 1 > /sys/devices/system/cpu/cpu0/online;
  echo sooplus > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
  echo 1 > /sys/devices/system/cpu/cpu1/online;
  echo sooplus > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
  echo 1 > /sys/devices/system/cpu/cpu2/online;
  echo sooplus > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
  echo 1 > /sys/devices/system/cpu/cpu3/online;
  echo sooplus > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
  echo 3 > /sys/devices/system/cpu/cpufreq/sooplus/down_differential;
  echo 1 > /sys/devices/system/cpu/cpufreq/sooplus/gboost;
  echo 0 > /sys/devices/system/cpu/cpufreq/sooplus/ignore_nice_load;
  echo 300000 > /sys/devices/system/cpu/cpufreq/sooplus/input_event_min_freq;
  echo 500 > /sys/devices/system/cpu/cpufreq/sooplus/input_event_timeout;
  echo 300000 > /sys/devices/system/cpu/cpufreq/sooplus/optimal_freq;
  echo 1 > /sys/devices/system/cpu/cpufreq/sooplus/sampling_down_factor;
  echo 300000 > /sys/devices/system/cpu/cpufreq/sooplus/sync_freq;
  echo "1728000,1728000,1728000,1728000" > /sys/devices/system/cpu/cpufreq/sooplus/two_phase_freq;
  echo 15000 > /sys/devices/system/cpu/cpufreq/sooplus/ui_sampling_rate;
  echo 90 > /sys/devices/system/cpu/cpufreq/sooplus/up_threshold;
  echo 90 > /sys/devices/system/cpu/cpufreq/sooplus/up_threshold_any_cpu_load;
  echo 90 > /sys/devices/system/cpu/cpufreq/sooplus/up_threshold_multi_core;
  echo "sooplus CPU governor" | tee -a $SOOPLUS_LOGFILE;
fi

#Set Sweep2wake
S2W="`grep SWEEP2WAKE $SOOPLUS_CONF | cut -d '=' -f2`"
  echo $S2W > /sys/android_touch/sweep2wake
  echo "Sweep2wake $S2W" | tee -a $SOOPLUS_LOGFILE;

#Set Doubletap2wake
if [ "`grep DT2W=1 $SOOPLUS_CONF`" ]; then
  echo 1 > /sys/android_touch/doubletap2wake
  echo "Doubletap2wake enabled" | tee -a $SOOPLUS_LOGFILE;
elif [ "`grep DT2W=2 $SOOPLUS_CONF`" ]; then
  echo 2 > /sys/android_touch/doubletap2wake
  echo "Doubletap2wake fullscreen enabled" | tee -a $SOOPLUS_LOGFILE;
else
  echo 0 > /sys/android_touch/doubletap2wake
  echo "Doubletap2wake disabled" | tee -a $SOOPLUS_LOGFILE;
fi

#Set Sweep2sleep
if [ "`grep S2S=1 $SOOPLUS_CONF`" ]; then
  echo 1 > /sys/android_touch/sweep2sleep
  echo "Sweep2sleep right enabled" | tee -a $SOOPLUS_LOGFILE;
elif [ "`grep S2S=2 $SOOPLUS_CONF`" ]; then
  echo 2 > /sys/android_touch/sweep2sleep
  echo "Sweep2sleep left enabled" | tee -a $SOOPLUS_LOGFILE;
elif [ "`grep S2S=3 $SOOPLUS_CONF`" ]; then
  echo 3 > /sys/android_touch/sweep2sleep
  echo "Sweep2sleep left and right enabled" | tee -a $SOOPLUS_LOGFILE;
else
  echo 0 > /sys/android_touch/sweep2sleep
  echo "Sweep2sleep disabled" | tee -a $SOOPLUS_LOGFILE;
fi

#Set Wake vibration strength
VIB_STRENGTH="`grep VIB_STRENGTH $SOOPLUS_CONF | cut -d '=' -f2`"
  echo $VIB_STRENGTH > /sys/android_touch/vib_strength
  echo "Wake vibration strength $VIB_STRENGTH" | tee -a $SOOPLUS_LOGFILE;

#Set S2W/DT2W Power Key Toggle
if [ "`grep PWR_KEY=1 $SOOPLUS_CONF`" ]; then
  echo 1 > /sys/module/qpnp_power_on/parameters/pwrkey_suspend
  echo "Power key toggle for S2W/DT2W enabled" | tee -a $SOOPLUS_LOGFILE;
else
  echo 0 > /sys/module/qpnp_power_on/parameters/pwrkey_suspend
  echo "Power key toggle for S2W/DT2W disabled" | tee -a $SOOPLUS_LOGFILE;
fi

#Set S2W/DT2W Timeout
TIMEOUT=`grep "TIMEOUT" $SOOPLUS_CONF | cut -d '=' -f2`
echo $TIMEOUT > /sys/android_touch/wake_timeout
echo "S2W/DT2W Timeout\: $TIMEOUT" | tee -a $SOOPLUS_LOGFILE;

#Set FASTCHARGE
if [ "`grep FC=1 $SOOPLUS_CONF`" ]; then
  echo 1 > /sys/kernel/fast_charge/force_fast_charge
  echo "USB Fastcharge enabled" | tee -a $SOOPLUS_LOGFILE;
else
  echo 0 > /sys/kernel/fast_charge/force_fast_charge
  echo "USB Fastcharge disabled" | tee -a $SOOPLUS_LOGFILE;
fi

#exFAT support
if [ "`grep EXFAT=1 $SOOPLUS_CONF`" ]; then
  insmod /system/lib/modules/exfat.ko;
  echo "exFAT module loaded" | tee -a $SOOPLUS_LOGFILE;
fi

#Set Max screen off
if [ "`grep MAXSCROFF=1 $SOOPLUS_CONF`" ]; then
  echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/screen_off_max
  echo "Max screen off frequency enabled" | tee -a $SOOPLUS_LOGFILE;
else
  echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/screen_off_max
  echo "Max screen off frequency disabled" | tee -a $SOOPLUS_LOGFILE;
fi

#Set Backlight
if [ "`grep BL=1 $SOOPLUS_CONF`" ]; then
  echo 1 > /sys/module/lm3630_bl/parameters/backlight_dimmer
  echo "Backlight dimmer enabled" | tee -a $SOOPLUS_LOGFILE;
else
  echo 0 > /sys/module/lm3630_bl/parameters/backlight_dimmer
  echo "Backlight dimmer disabled" | tee -a $SOOPLUS_LOGFILE;
fi

#Set fsync
if [ "`grep FSYNC=0 $SOOPLUS_CONF`" ]; then
  echo 0 > /sys/module/sync/parameters/fsync_enabled;
  echo "fsync disabled" | tee -a $SOOPLUS_LOGFILE;
else
  echo 1 > /sys/module/sync/parameters/fsync_enabled;
  echo "fsync enabled" | tee -a $SOOPLUS_LOGFILE;
fi

#multicore powersaving
if [ "`grep MPS=1 $SOOPLUS_CONF`" ]; then
  echo 2 > /sys/devices/system/cpu/sched_mc_power_savings
  echo "multicore power saving aggressive enabled" | tee -a $SOOPLUS_LOGFILE;
else
  echo 0 > /sys/devices/system/cpu/sched_mc_power_savings
  echo "multicore power saving disabled" | tee -a $SOOPLUS_LOGFILE;
fi

# BLX
if [ "`grep BLX=1 $SOOPLUS_CONF`" ]; then
  echo 97 > /sys/class/misc/batterylifeextender/charging_limit;
  echo "BLX: charge_limit to 97%" | tee -a $SOOPLUS_LOGFILE;
elif [ "`grep BLX=2 $SOOPLUS_CONF`" ]; then
  echo 98 > /sys/class/misc/batterylifeextender/charging_limit;
  echo "BLX: charge_limit to 98%" | tee -a $SOOPLUS_LOGFILE;
elif [ "`grep BLX=3 $SOOPLUS_CONF`" ]; then
  echo 99 > /sys/class/misc/batterylifeextender/charging_limit;
  echo "BLX: charge_limit to 99%" | tee -a $SOOPLUS_LOGFILE;
elif [ "`grep BLX=4 $SOOPLUS_CONF`" ]; then
  echo 100 > /sys/class/misc/batterylifeextender/charging_limit;
  echo "BLX: charge_limit to 100%" | tee -a $SOOPLUS_LOGFILE;
elif [ "`grep BLX=0 $SOOPLUS_CONF`" ]; then
  echo 96 > /sys/class/misc/batterylifeextender/charging_limit;
  echo "BLX: charge_limit to 96%" | tee -a $SOOPLUS_LOGFILE;
fi

# GPU Governor
if [ "`grep GPU=1 $SOOPLUS_CONF`" ]; then
  echo simple > /sys/class/kgsl/kgsl-3d0/pwrscale/trustzone/governor;
  echo "GPU Governor enabled: simple" | tee -a $SOOPLUS_LOGFILE;
else
  echo ondemand > /sys/class/kgsl/kgsl-3d0/pwrscale/trustzone/governor;
  echo "GPU Governor enabled: Ondemand" | tee -a $SOOPLUS_LOGFILE;
fi

#vibrator settings
GVIB=`grep "GVIB" $SOOPLUS_CONF | cut -d '=' -f2`
echo $GVIB > /sys/class/timed_output/vibrator/amp
echo "Vibration strength\: $GVIB" | tee -a $SOOPLUS_LOGFILE;

#io scheduler settings
SCHED=`grep "SCHED" $SOOPLUS_CONF | cut -d '=' -f2`
if [ "`grep SCHED=1 $SOOPLUS_CONF`" ]; then
  echo cfq > /sys/block/mmcblk0/queue/scheduler;
  echo "CFQ io scheduler" | tee -a $SOOPLUS_LOGFILE;
elif [ "`grep SCHED=3 $SOOPLUS_CONF`" ]; then
  echo deadline > /sys/block/mmcblk0/queue/scheduler;
  echo "deadline io scheduler" | tee -a $SOOPLUS_LOGFILE;
elif [ "`grep SCHED=4 $SOOPLUS_CONF`" ]; then
  echo fiops > /sys/block/mmcblk0/queue/scheduler;
  echo "FIOPS io scheduler" | tee -a $SOOPLUS_LOGFILE;
elif [ "`grep SCHED=5 $SOOPLUS_CONF`" ]; then
  echo sio > /sys/block/mmcblk0/queue/scheduler;
  echo "SIO io scheduler" | tee -a $SOOPLUS_LOGFILE;
elif [ "`grep SCHED=6 $SOOPLUS_CONF`" ]; then
  echo bfq > /sys/block/mmcblk0/queue/scheduler;
  echo "BFQ io scheduler" | tee -a $SOOPLUS_LOGFILE;
else
  echo row > /sys/block/mmcblk0/queue/scheduler;
  echo "ROW io scheduler" | tee -a $SOOPLUS_LOGFILE;
fi

#Readahead settings
READAHEAD=`grep "READAHEAD" $SOOPLUS_CONF | cut -d '=' -f2`
echo $READAHEAD > /sys/block/mmcblk0/queue/read_ahead_kb
echo "Readahead size\: $READAHEAD" | tee -a $SOOPLUS_LOGFILE;


#gboost settings
if [ "`grep GBOOST=0 $SOOPLUS_CONF`" ]; then
  echo 0 > /sys/devices/system/cpu/cpufreq/sooplus/gboost;
  echo "gboost disabled" | tee -a $SOOPLUS_LOGFILE;
fi

#Set logcat
if [ "`grep LC=1 $SOOPLUS_CONF`" ]; then
  echo 1 > /sys/module/logger/parameters/enabled
  echo "Logcat enabled" | tee -a $SOOPLUS_LOGFILE;
else
  echo 0 > /sys/module/logger/parameters/enabled
  echo "Logcat disabled" | tee -a $SOOPLUS_LOGFILE;
fi

#Set Faux Sound
#Quality profile
if [ "`grep FS=1 $SOOPLUS_CONF`" ]; then
  echo "0" > /sys/kernel/sound_control_3/gpl_sound_control_locked;
#  echo "0" > /sys/kernel/sound_control_3/gpl_cam_mic_gain;
  echo "254 254" > /sys/kernel/sound_control_3/gpl_headphone_gain;
  echo "33 33" > /sys/kernel/sound_control_3/gpl_headphone_pa_gain;
#  echo "0" > /sys/kernel/sound_control_3/gpl_mic_gain;
  echo "254 254" > /sys/kernel/sound_control_3/gpl_speaker_gain;
#  echo "1" > /sys/kernel/sound_control_3/gpl_sound_control_locked;
#  echo "1" > /sys/kernel/sound_control_3/gpl_sound_control_rec_locked;
  echo "Faux sound Quality profile enabled" | tee -a $SOOPLUS_LOGFILE;
#Loudness profile
elif [ "`grep FS=2 $SOOPLUS_CONF`" ]; then
  echo "0" > /sys/kernel/sound_control_3/gpl_sound_control_locked;
#  echo "0" > /sys/kernel/sound_control_3/gpl_cam_mic_gain;
  echo "9 9" > /sys/kernel/sound_control_3/gpl_headphone_gain;
  echo "35 35" > /sys/kernel/sound_control_3/gpl_headphone_pa_gain;
#  echo "0" > /sys/kernel/sound_control_3/gpl_mic_gain;
  echo "5 5" > /sys/kernel/sound_control_3/gpl_speaker_gain;
#  echo "1" > /sys/kernel/sound_control_3/gpl_sound_control_locked;
#  echo "1" > /sys/kernel/sound_control_3/gpl_sound_control_rec_locked;
  echo "Faux sound Loudness profile enabled" | tee -a $SOOPLUS_LOGFILE;
elif [ "`grep FS=3 $SOOPLUS_CONF`" ]; then
  echo "0" > /sys/kernel/sound_control_3/gpl_sound_control_locked;
#  echo "0" > /sys/kernel/sound_control_3/gpl_cam_mic_gain;
  echo "251 251" > /sys/kernel/sound_control_3/gpl_headphone_gain;
  echo "40 40" > /sys/kernel/sound_control_3/gpl_headphone_pa_gain;
#  echo "0" > /sys/kernel/sound_control_3/gpl_mic_gain;
  echo "253 253" > /sys/kernel/sound_control_3/gpl_speaker_gain;
#  echo "1" > /sys/kernel/sound_control_3/gpl_sound_control_locked;
#  echo "1" > /sys/kernel/sound_control_3/gpl_sound_control_rec_locked;
  echo "Faux sound Quiet profile enabled" | tee -a $SOOPLUS_LOGFILE;
else
  echo "No Faux Sound profile enabled" | tee -a $SOOPLUS_LOGFILE;
fi

#Color presets
#Neriamarillo v3
if [ "`grep CP=1 $SOOPLUS_CONF`" ]; then
  #  Red Positive                = /sys/module/dsi_panel/kgamma_rp
  echo "0 10 17 27 37 45 57 75 86 105 117 125 125 119 113 100 85 75 67 61 52 37 21" > /sys/module/dsi_panel/kgamma_rp;
  #  Red Negative                = /sys/module/dsi_panel/kgamma_rn
  echo "0 10 17 27 37 45 57 75 86 105 117 125 125 119 113 100 85 75 67 61 52 37 21" > /sys/module/dsi_panel/kgamma_rn;
  #  Green Positive              = /sys/module/dsi_panel/kgamma_gp
  echo "83 85 86 88 91 94 101 111 115 127 132 136 115 111 106 94 78 69 63 57 49 36 20" > /sys/module/dsi_panel/kgamma_gp;
  #  Green Negative              = /sys/module/dsi_panel/kgamma_gn
  echo "83 85 86 88 91 94 101 111 115 127 132 136 115 111 106 94 78 69 63 57 49 36 20" > /sys/module/dsi_panel/kgamma_gn;
  #  Blue Positive               = /sys/module/dsi_panel/kgamma_bp
  echo "90 91 93 95 98 100 105 114 116 128 131 135 117 112 106 92 75 65 56 48 36 29 16" > /sys/module/dsi_panel/kgamma_bp;
  #  Blue Negative               = /sys/module/dsi_panel/kgamma_bn
  echo "90 91 93 95 98 100 105 114 116 128 131 135 117 112 106 92 75 65 56 48 36 29 16" > /sys/module/dsi_panel/kgamma_bn;
  #  White Point                 = /sys/module/dsi_panel/kgamma_w
  echo "32" > /sys/module/dsi_panel/kgamma_w;
  echo "Neriamarillo v3 color profile enabled" | tee -a $SOOPLUS_LOGFILE;
#Yorici Calibrated Punch
elif [ "`grep CP=2 $SOOPLUS_CONF`" ]; then
  #  Red Positive                = /sys/module/dsi_panel/kgamma_rp
  echo "0 18 23 36 45 54 63 80 91 107 118 126 124 118 110 94 74 57 43 35 26 10 5" > /sys/module/dsi_panel/kgamma_rp;
  #  Red Negative                = /sys/module/dsi_panel/kgamma_rn
  echo "0 18 23 36 45 54 63 81 91 107 118 126 124 118 110 93 73 56 43 36 25 10 5" > /sys/module/dsi_panel/kgamma_rn;
  #  Green Positive              = /sys/module/dsi_panel/kgamma_gp
  echo "0 20 30 43 50 57 67 85 95 110 121 128 122 116 108 94 74 55 43 35 26 10 5" > /sys/module/dsi_panel/kgamma_gp;
  #  Green Negative              = /sys/module/dsi_panel/kgamma_gn
  echo "0 20 31 43 50 57 67 84 95 111 120 128 122 116 109 93 73 55 41 34 24 10 5" > /sys/module/dsi_panel/kgamma_gn;
  #  Blue Positive               = /sys/module/dsi_panel/kgamma_bp
  echo "0 14 18 31 41 47 59 77 88 105 116 125 125 119 111 95 75 56 48 37 26 15 5" > /sys/module/dsi_panel/kgamma_bp;
  #  Blue Negative               = /sys/module/dsi_panel/kgamma_bn
  echo "0 14 19 33 41 46 60 77 88 105 116 123 125 119 111 95 76 57 41 36 24 15 5" > /sys/module/dsi_panel/kgamma_bn;
  #  White Point                 = /sys/module/dsi_panel/kgamma_w
  echo "31" > /sys/module/dsi_panel/kgamma_w;
  echo "Yorici v3 color profile enabled" | tee -a $SOOPLUS_LOGFILE;
#Piereligio True RGB v7
elif [ "`grep CP=3 $SOOPLUS_CONF`" ]; then
  #  Red Positive                = /sys/module/dsi_panel/kgamma_rp
  echo "0 12 19 30 39 48 56 72 83 105 121 130 118 115 114 108 100 80 66 60 48 38 22" > /sys/module/dsi_panel/kgamma_rp;
  #  Red Negative                = /sys/module/dsi_panel/kgamma_rn
  echo "0 12 19 30 39 48 56 72 83 105 119 130 119 115 116 106 88 80 71 62 52 42 25" > /sys/module/dsi_panel/kgamma_rn;
  #  Green Positive              = /sys/module/dsi_panel/kgamma_gp
  echo "0 12 20 31 40 55 62 79 84 109 123 134 116 112 112 104 101 76 67 58 49 39 21" > /sys/module/dsi_panel/kgamma_gp;
  #  Green Negative              = /sys/module/dsi_panel/kgamma_gn
  echo "0 12 20 31 40 55 62 76 89 109 123 132 115 113 111 103 78 75 67 58 49 39 21" > /sys/module/dsi_panel/kgamma_gn;
  #  Blue Positive               = /sys/module/dsi_panel/kgamma_bp
  echo "0 12 19 30 39 48 56 72 82 104 118 131 120 116 114 107 100 78 66 60 44 35 20" > /sys/module/dsi_panel/kgamma_bp;
  #  Blue Negative               = /sys/module/dsi_panel/kgamma_bn
  echo "0 12 19 30 39 48 56 72 82 104 118 127 119 116 115 106 84 78 66 60 44 35 20" > /sys/module/dsi_panel/kgamma_bn;
  #  White Point                 = /sys/module/dsi_panel/kgamma_w
  echo "32" > /sys/module/dsi_panel/kgamma_w;
  echo "Piereligio True RGV v7 color profile enabled" | tee -a $SOOPLUS_LOGFILE;
else
  echo "No color profile enabled" | tee -a $SOOPLUS_LOGFILE;
fi

# Tune LMK with values we love
chmod 660 /sys/module/lowmemorykiller/parameters/adj
chmod 660 /sys/module/lowmemorykiller/parameters/minfree
echo "1536,2048,4096,16384,28672,32768" > /sys/module/lowmemorykiller/parameters/minfree
echo 32 > /sys/module/lowmemorykiller/parameters/cost

echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 300000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo 300000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
echo 300000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq

if pgrep logwrapper; then
    killall logwrapper
    echo "logwrapper killed" | tee -a $SOOPLUS_LOGFILE;
fi

#fstrim
fstrim -v /system | tee -a $SOOPLUS_LOGFILE;
fstrim -v /cache | tee -a $SOOPLUS_LOGFILE;
fstrim -v /data | tee -a $SOOPLUS_LOGFILE;

exit 0
