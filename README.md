# marlin-anet-a8-skr1.3-builder
Anet A8 Malin firmware builder for SKR 1.3

This is simple bash scipt that allows to build fully working Malin firmware on SKR1.3 for use with slighty modified Anet A8.

Just put it anywhere on your Linux box (Windows Linux subsystem not tested) and press enter.

I will:
1) Download PlatformIO to local directory
2) Configure PlatformIO to use with SKR1.3
3) Download Malin branch for SKR1.3
4) Apply all necessary patches (geometry, features, bug fixes, etc)
5) Start build process

No changes to operating system is done, everything is local. Result of this build is single file "FIRMWARE.BIN" that You should put on your SD card and wait for auto flasing after powering it up.

Features enabled by default:
1) Linear advance
2) TMC2208 control
3) Pause
4) Auto leveling (unified)

Please notice that this is not compatible with stock Anet A8 because:

a) it was modified to use with 128x64 LCD CR10 (warning: using Anet 128x64, hardware modifications required for this to work at all, conectors are similar but different, do not connect original LCD also without modification!)

b) it is prepared to use induction bed leveling sensor (might work just fine with stock endstop, however You will get bunch of unused items in menu).

Both features can be easely disabled within script, just comment lines that You do not want to be injected into Malin config.

Sebastian Biały.
