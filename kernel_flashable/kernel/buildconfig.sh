#!/sbin/sh

#Build config file
CONFIGFILE="/tmp/sooplus.conf"

#VIBRATION
echo -e "\n\n##### Global Vibration Strength #####" >> $CONFIGFILE
echo -e "Enter vibration strength (0 to 100).  Default is 63.\n" >> $CONFIGFILE
echo "GVIB=63" >> $CONFIGFILE;

#S2W
SR=`grep "item.1.1" /tmp/aroma/gest.prop | cut -d '=' -f2`
SL=`grep "item.1.2" /tmp/aroma/gest.prop | cut -d '=' -f2`
SU=`grep "item.1.3" /tmp/aroma/gest.prop | cut -d '=' -f2`
SD=`grep "item.1.4" /tmp/aroma/gest.prop | cut -d '=' -f2`
echo -e "\n\n##### Sweep2wake Settings #####\n# 0 to disable sweep2wake" >> $CONFIGFILE
echo -e "# 1 to enable sweep right" >> $CONFIGFILE
echo -e "# 2 to enable sweep left" >> $CONFIGFILE
echo -e "# 4 to enable sweep up" >> $CONFIGFILE
echo -e "# 8 to enable sweep down\n" >> $CONFIGFILE
echo -e "# For combinations, add values together (e.g. all gestures enabled = 15)\n" >> $CONFIGFILE
if [ $SL = 1 ]; then
  SL=2
fi
if [ $SU == 1 ]; then
  SU=4
fi
if [ $SD == 1 ]; then
  SD=8
fi  

S2W=$(( SL + SR + SU + SD ))
echo SWEEP2WAKE=$S2W >> $CONFIGFILE;


#DT2W
DT2W=`grep "item.1.5" /tmp/aroma/gest.prop | cut -d '=' -f2`
DT2WH=`grep "item.2.3" /tmp/aroma/gest.prop | cut -d '=' -f2`
echo -e "\n\n##### Doubletap2Wake Settings #####\n# 0 to disable doubletap2wake" >> $CONFIGFILE
echo -e "# 1 to enable doubletap2wake (default)\n# 2 to enabled doubletap2wake fullscreen\n" >> $CONFIGFILE
if [ $DT2W = 1 ] && [ $DT2WH = 1 ]; then
  echo "DT2W=1" >> $CONFIGFILE;
elif [ $DT2W = 1 ] && [ $DT2WH = 0 ]; then
  echo "DT2W=2" >> $CONFIGFILE;
else
  echo "DT2W=0" >> $CONFIGFILE;
fi

#WG vibration strength
VIB_STRENGTH=`grep "item.2.1" /tmp/aroma/gest.prop | cut -d '=' -f2`
echo -e "\n\n##### Wake Vibration Settings #####\n# Set vibration strength (0 to 90)" >> $CONFIGFILE
echo -e "# 0 to disable haptic feedback for gestures" >> $CONFIGFILE
echo -e "# 20 is default\n" >> $CONFIGFILE
if [ $VIB_STRENGTH = 1 ]; then
  echo "VIB_STRENGTH=20" >> $CONFIGFILE;
else
  echo "VIB_STRENGTH=0" >> $CONFIGFILE;
fi

#S2W/DT2W Power key toggle
PWR_KEY=`grep "item.2.2" /tmp/aroma/gest.prop | cut -d '=' -f2`
echo -e "\n\n##### Power Key Toggles S2W/DT2W #####\n# 0 to disable" >> $CONFIGFILE
echo -e "# 1 to enable\n" >> $CONFIGFILE
if [ $PWR_KEY = 1 ]; then
  echo "PWR_KEY=1" >> $CONFIGFILE;
else
  echo "PWR_KEY=0" >> $CONFIGFILE;
fi

#S2W/DT2W Timeout
if [ ! -e /tmp/aroma/timeout.prop ]; then
  echo "selected.0=1" > /tmp/aroma/timeout.prop;
fi

TIMEOUT=`cat /tmp/aroma/timeout.prop | cut -d '=' -f2`
echo -e "\n\n##### S2W/DT2W Timeout #####\n# 0 = disabled" >> $CONFIGFILE
echo -e "# Otherwise, specify number of minutes (default is 60)\n" >> $CONFIGFILE
if [ $TIMEOUT = 1 ]; then
  echo "TIMEOUT=0" >> $CONFIGFILE;
elif [ $TIMEOUT = 2 ]; then
  echo "TIMEOUT=5" >> $CONFIGFILE;
elif [ $TIMEOUT = 3 ]; then
  echo "TIMEOUT=15" >> $CONFIGFILE;
elif [ $TIMEOUT = 4 ]; then
  echo "TIMEOUT=30" >> $CONFIGFILE;
elif [ $TIMEOUT = 5 ]; then
  echo "TIMEOUT=60" >> $CONFIGFILE;
elif [ $TIMEOUT = 6 ]; then
  echo "TIMEOUT=90" >> $CONFIGFILE;
elif [ $TIMEOUT = 7 ]; then
  echo "TIMEOUT=120" >> $CONFIGFILE;
fi

#S2S
S2S=`grep selected.0 /tmp/aroma/s2s.prop | cut -d '=' -f2`
echo -e "\n\n##### Sweep2sleep Settings #####\n# 0 to disable sweep2sleep" >> $CONFIGFILE
echo -e "# 1 to enable sweep2sleep right" >> $CONFIGFILE
echo -e "# 2 to enable sweep2sleep left" >> $CONFIGFILE
echo -e "# 3 to enable sweep2sleep left and right\n" >> $CONFIGFILE
if [ $S2S = 2 ]; then
  echo "S2S=1" >> $CONFIGFILE;
elif [ $S2S = 3 ]; then
  echo "S2S=2" >> $CONFIGFILE;
elif [ $S2S = 4 ]; then
  echo "S2S=3" >> $CONFIGFILE;
else
  echo "S2S=0" >> $CONFIGFILE;
fi

#USB Fastcharge
FC=`grep "item.0.1" /tmp/aroma/mods.prop | cut -d '=' -f2`
echo -e "\n\n##### Fastcharge Settings ######\n# 1 to enable usb fastcharge\n# 0 to disable usb fastcharge\n" >> $CONFIGFILE
if [ $FC = 1 ]; then
  echo "FC=1" >> $CONFIGFILE;
else
  echo "FC=0" >> $CONFIGFILE;
fi

#multicore power saving
MPS=`grep "item.0.2" /tmp/aroma/mods.prop | cut -d '=' -f2`
echo -e "\n\n##### multicore power saving Settings ######\n# 1 to enable multicore power saving\n# 0 to disable multicore power saving\n" >> $CONFIGFILE
if [ $MPS = 1 ]; then
  echo "MPS=1" >> $CONFIGFILE;
else
  echo "MPS=0" >> $CONFIGFILE;
fi

#Backlight
BL=`grep "item.0.3" /tmp/aroma/mods.prop | cut -d '=' -f2`
echo -e "\n\n##### Backlight Settings #####\n# 0 to for stock backlight" >> $CONFIGFILE
echo -e "# 1 for dimmer backlight\n" >> $CONFIGFILE
if [ $BL = 1 ]; then
  echo "BL=1" >> $CONFIGFILE;
else
  echo "BL=0" >> $CONFIGFILE;
fi

#logcat
LC=`grep "item.0.4" /tmp/aroma/mods.prop | cut -d '=' -f2`
echo -e "\n\n##### LOGCAT Settings #####\n# 0 to disable Logcat" >> $CONFIGFILE
echo -e "# 1 to enable logcat\n" >> $CONFIGFILE
if [ $LC = 1 ]; then
  echo "LC=0" >> $CONFIGFILE;
else
  echo "LC=1" >> $CONFIGFILE;
fi

#GPU Governor
GPU=`grep "item.0.6" /tmp/aroma/mods.prop | cut -d '=' -f2`
echo -e "\n\n##### GPU Governor Settings #####\n# 0 to enable ondemand GPU Governor" >> $CONFIGFILE
echo -e "# 1 to enable simple GPU governor\n" >> $CONFIGFILE
if [ $GPU = 1 ]; then
  echo "GPU=1" >> $CONFIGFILE;
else
  echo "GPU=0" >> $CONFIGFILE;
fi

#fsync
FSYNC=`grep "item.0.7" /tmp/aroma/mods.prop | cut -d '=' -f2`
echo -e "\n\n##### fsync Settings ######\n# 1 to enable (default)\n# 0 to disable\n" >> $CONFIGFILE
if [ $FSYNC = 1 ]; then
  echo "FSYNC=0" >> $CONFIGFILE;
else
  echo "FSYNC=1" >> $CONFIGFILE;
fi

#exFAT support
EXFAT=`grep "item.0.8" /tmp/aroma/mods.prop | cut -d '=' -f2`
echo -e "\n\n##### exFAT support #####\n# 0 to disable exFAT support" >> $CONFIGFILE
echo -e "# 1 to enable exFAT support\n" >> $CONFIGFILE
if [ $EXFAT = 1 ]; then
  echo "EXFAT=1" >> $CONFIGFILE;
else
  echo "EXFAT=0" >> $CONFIGFILE;
fi

#hotplug settings
HOTPLUG=`grep selected.0 /tmp/aroma/hotplug.prop | cut -d '=' -f2`
echo -e "\n\n##### Hotplug settings #####\n# 0 to enable qcom mpdecision" >> $CONFIGFILE
echo -e "# 1 to enable msm_sleeper\n# 2 to enable bricked_hotplug\n" >> $CONFIGFILE
if [ "$HOTPLUG" = 1 ]; then
  echo "HOTPLUG=1" >> $CONFIGFILE;
elif [ "$HOTPLUG" = 2 ]; then
  echo "HOTPLUG=2" >> $CONFIGFILE;
else
  echo "HOTPLUG=0" >> $CONFIGFILE;
fi

#BLX
BLX=`grep selected.0 /tmp/aroma/blx.prop | cut -d '=' -f2`
echo -e "\n\n##### Battery life extender settings #####\n# 0 for 96%" >> $CONFIGFILE
echo -e "# 1 for 97%\n# 2 for 98%\n# 3 for 99%\n# 4 for 100%\n" >> $CONFIGFILE
if [ "$BLX" = 2 ]; then
  echo "BLX=1" >> $CONFIGFILE;
elif [ "$BLX" = 3 ]; then
  echo "BLX=2" >> $CONFIGFILE;
elif [ "$BLX" = 4 ]; then
  echo "BLX=3" >> $CONFIGFILE;
elif [ "$BLX" = 5 ]; then
  echo "BLX=4" >> $CONFIGFILE;
elif [ "$BLX" = 1 ]; then
  echo "BLX=0" >> $CONFIGFILE;
fi

#CPU Governor
CPU=`grep selected.0 /tmp/aroma/cpu.prop | cut -d '=' -f2`
echo -e "\n\n##### CPU Gov settings #####\n# 0 to enable sooplus Governor" >> $CONFIGFILE
echo -e "# 1 to enable interactive gov\n# 2 to enable conservative governor\n# 3 to enable ondemand governor\n" >> $CONFIGFILE
if [ "$CPU" = 2 ]; then
  echo "CPU=1" >> $CONFIGFILE;
elif [ "$CPU" = 3 ]; then
  echo "CPU=2" >> $CONFIGFILE;
elif [ "$CPU" = 4 ]; then
  echo "CPU=3" >> $CONFIGFILE;
else
  echo "CPU=0" >> $CONFIGFILE;
fi

#i/o scheduler
SCHED=`grep selected.1 /tmp/aroma/disk.prop | cut -d '=' -f2`
echo -e "\n\n##### i/o Scheduler #####\n# 1 CFQ (stock)" >> $CONFIGFILE
echo -e "# 2 ROW (default)\n# 3 deadline\n# 4 FIOPS\n# 5 SIO\n# 6 BFQ\n" >> $CONFIGFILE
if [ $SCHED = 1 ]; then
  echo "SCHED=1" >> $CONFIGFILE;
elif [ $SCHED = 2 ]; then
  echo "SCHED=2" >> $CONFIGFILE;
elif [ $SCHED = 3 ]; then
  echo "SCHED=3" >> $CONFIGFILE;
elif [ $SCHED = 4 ]; then
  echo "SCHED=4" >> $CONFIGFILE;
elif [ $SCHED = 5 ]; then
  echo "SCHED=5" >> $CONFIGFILE;
elif [ $SCHED = 6 ]; then
  echo "SCHED=6" >> $CONFIGFILE;
fi

#Readahead buffer size
READAHEAD=`grep selected.2 /tmp/aroma/disk.prop | cut -d '=' -f2`
echo -e "\n\n##### Readahead Buffer Size #####\n# 128 (stock)" >> $CONFIGFILE
echo -e "# 256\n# 512\n# 1024\n" >> $CONFIGFILE
if [ $READAHEAD = 1 ]; then
  echo "READAHEAD=128" >> $CONFIGFILE;
elif [ $READAHEAD = 2 ]; then
  echo "READAHEAD=256" >> $CONFIGFILE;
elif [ $READAHEAD = 3 ]; then
  echo "READAHEAD=512" >> $CONFIGFILE;
elif [ $READAHEAD = 4 ]; then
  echo "READAHEAD=1024" >> $CONFIGFILE;
fi

#Faux Sound
FSP=`grep "selected.1" /tmp/aroma/misc.prop | cut -d '=' -f2`
echo -e "\n\n##### Faux Sound Settings #####\n# 0 = STOCK" >> $CONFIGFILE
echo -e "# 1 = QUALITY" >> $CONFIGFILE
echo -e "# 2 = LOUDNESS" >> $CONFIGFILE
echo -e "# 3 = QUIET\n" >> $CONFIGFILE
if [ "$FSP" = 2 ]; then
  echo "FS=1" >> $CONFIGFILE;
elif [ "$FSP" = 3 ]; then
  echo "FS=2" >> $CONFIGFILE;
elif [ "$FSP" = 4 ]; then
  echo "FS=3" >> $CONFIGFILE;
else
  echo "FS=0" >> $CONFIGFILE;
fi

#Color Preset
CPP=`grep "selected.2" /tmp/aroma/misc.prop | cut -d '=' -f2`
echo -e "\n\n##### Color Preset #####\n# 0 = STOCK" >> $CONFIGFILE
echo -e "# 1 = Neriamarillo v3" >> $CONFIGFILE
echo -e "# 2 = Yorici Calibrated Punch" >> $CONFIGFILE
echo -e "# 3 = Piereligio True RGB v7\n" >> $CONFIGFILE
if [ "$CPP" = 2 ]; then
  echo "CP=1" >> $CONFIGFILE;
elif [ "$CPP" = 3 ]; then
  echo "CP=2" >> $CONFIGFILE;
elif [ "$CPP" = 4 ]; then
  echo "CP=3" >> $CONFIGFILE;
else
  echo "CP=0" >> $CONFIGFILE;
fi

echo -e "\n\n##############################" >> $CONFIGFILE
#END
