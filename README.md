Anet A8 Malin firmware builder for SKR 1.3

This is simple bash scipt that allows to build fully working Malin firmware on SKR1.3 for use with slighty modified Anet A8.

Just put it anywhere on your Linux box add executable attribute (chmod +x) and press enter.

Windows Subsystem for Linux (Ubuntu 20.04 tested) is kinda supported, but sometimes buggy (will fail with some AV settings with strange "Access denied" problems, use real Linux instead).

It will:
1) Download PlatformIO to local directory
2) Configure PlatformIO to use with SKR1.3
3) Download Malin v2.0.9.3 branch for SKR1.3
4) Apply all necessary patches (geometry, features, bug fixes, etc)
5) Start build process

No changes to operating system is done, everything is local. Result of this build is single file "FIRMWARE.BIN" that You should put on your SD card and wait for auto flasing after powering it up.

Features enabled by default:
1) Linear advance
2) TMC2208 control
3) Pause
4) Auto leveling (unified)
5) Host commands
6) BLTouch
7) 128x64 CR10 display
8) BMG extruder
10) Pid setup in menu
9) Many more little things (and games!)

Please notice that this is not compatible with stock Anet A8 because:

a) it was modified to use with 128x64 CR10 LCD (warning: hardware modifications required for using Anet 128x64 to work at all, conectors are similar but different, do not connect original 2x16 LCD without modification also!)

b) it is prepared to use BLTouch/3DTouch bed leveling sensor.

c) it is using BMG extruder istead of stock one (and you should do this upgrade anyway)

Both features can be easely disabled within script, just comment lines that You do not want to be injected into Malin config.

Just remember to erase all settings by initializing EEPROM, and setup proper Pid parameters (using autotune in menu) and nozzle offset from probe, before use.

Sebastian Biały.
