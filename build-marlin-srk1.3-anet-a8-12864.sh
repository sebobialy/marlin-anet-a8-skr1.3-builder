export PLATFORMIO_CORE_DIR=`pwd`/platformio

function downloadPlatfromIO()
{
    if [ ! -d $PLATFORMIO_CORE_DIR ]; then
        mkdir platformio
        python3 -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/develop/scripts/get-platformio.py)"
    fi
}

function downloadNXPLPCPlatform()
{
    if [ ! -d $PLATFORMIO_CORE_DIR/platforms/nxplpc ];then
        ${PLATFORMIO_CORE_DIR}/penv/bin/platformio platform install nxplpc
    fi
}

function downloadMarlin()
{
    if [ ! -d marlin ]; then
        svn export "https://github.com/MarlinFirmware/Marlin/tags/2.0.5.4" marlin
    fi
}

function configureBoard()
{
    sed -i '/#define MOTHERBOARD/c\#define MOTHERBOARD BOARD_BTT_SKR_V1_3' marlin/Marlin/Configuration.h
    sed -i '/default_envs = mega2560/c\default_envs = LPC1768' marlin/platformio.ini
    sed -i '/#define EEPROM_SETTINGS/c\#define EEPROM_SETTINGS' marlin/Marlin/Configuration.h
    sed -i '/#define SERIAL_PORT_2 -1/c\#define SERIAL_PORT_2 -1' marlin/Marlin/Configuration.h
    sed -i '/#define SDSUPPORT/c\#define SDSUPPORT' marlin/Marlin/Configuration.h
    sed -i '/#define SDCARD_CONNECTION/c\#define SDCARD_CONNECTION ONBOARD' marlin/Marlin/Configuration_adv.h
    sed -i '/#define SD_DETECT_STATE HIGH/c\#define SD_DETECT_STATE HIGH' marlin/Marlin/Configuration_adv.h
    sed -i '/#define SD_CHECK_AND_RETRY/c\#define SD_CHECK_AND_RETRY' marlin/Marlin/Configuration_adv.h
    sed -i '/#define LONG_FILENAME_HOST_SUPPORT/c\#define LONG_FILENAME_HOST_SUPPORT' marlin/Marlin/Configuration_adv.h
    sed -i '/#define SCROLL_LONG_FILENAMES/c\#define SCROLL_LONG_FILENAMES' marlin/Marlin/Configuration_adv.h
    sed -i '/#define STATUS_MESSAGE_SCROLLING/c\#define STATUS_MESSAGE_SCROLLING' marlin/Marlin/Configuration_adv.h
    sed -i '/#define MENU_HOLLOW_FRAME/c\//#define MENU_HOLLOW_FRAME' marlin/Marlin/Configuration_adv.h
    sed -i '/#define XYZ_HOLLOW_FRAME/c\//#define XYZ_HOLLOW_FRAME' marlin/Marlin/Configuration_adv.h
    sed -i '/#define STATUS_FAN_FRAMES/c\#define STATUS_FAN_FRAMES 4' marlin/Marlin/Configuration_adv.h
    sed -i '/#define BOOT_MARLIN_LOGO_ANIMATED/c\#define BOOT_MARLIN_LOGO_ANIMATED' marlin/Marlin/Configuration_adv.h
    sed -i '/#define LCD_SHOW_E_TOTAL/c\#define LCD_SHOW_E_TOTAL' marlin/Marlin/Configuration_adv.h
}

function configurePrinter()
{
    sed -i '/#define CUSTOM_MACHINE_NAME/c\#define CUSTOM_MACHINE_NAME \"Anet-A8\"' marlin/Marlin/Configuration.h
    sed -i '/#define DEFAULT_NOMINAL_FILAMENT_DIA 3.0/c\#define DEFAULT_NOMINAL_FILAMENT_DIA 1.75' marlin/Marlin/Configuration.h
    sed -i '/#define TEMP_SENSOR_BED 0/c\#define TEMP_SENSOR_BED 1' marlin/Marlin/Configuration.h
    sed -i '/#define NUM_Z_STEPPER_DRIVERS 1/c\#define NUM_Z_STEPPER_DRIVERS 2' marlin/Marlin/Configuration_adv.h
    sed -i '/#define BED_MAXTEMP/c\#define BED_MAXTEMP 110' marlin/Marlin/Configuration.h
    sed -i '/#define BABYSTEPPING/c\#define BABYSTEPPING' marlin/Marlin/Configuration_adv.h
    sed -i '/#define BABYSTEP_WITHOUT_HOMING/c\#define BABYSTEP_WITHOUT_HOMING' marlin/Marlin/Configuration_adv.h
}

function enableCR10StockDisplay()
{
    sed -i '/#define CR10_STOCKDISPLAY/c\#define CR10_STOCKDISPLAY' marlin/Marlin/Configuration.h
}

function enableLinearAdvance()
{
    sed -i '/\/\/#define LIN_ADVANCE/c\#define LIN_ADVANCE' marlin/Marlin/Configuration_adv.h
    sed -i '/#define LIN_ADVANCE_K/c\#define LIN_ADVANCE_K 0.12' marlin/Marlin/Configuration_adv.h

    # workaround bug on 32 bit boards, extruder does not work if LIN_ADVANCE is enabled
    # https://github.com/MarlinFirmware/Marlin/issues/12983
    sed -i '/#define MINIMUM_STEPPER_PULSE/c\#define MINIMUM_STEPPER_PULSE 1' marlin/Marlin/Configuration_adv.h
}

function enableSCurve()
{
    sed -i '/#define S_CURVE_ACCELERATION/c\#define S_CURVE_ACCELERATION' marlin/Marlin/Configuration.h
}

function enableTMC2208Drivers()
{
    sed -i '/#define X_DRIVER_TYPE/c\#define X_DRIVER_TYPE TMC2208' marlin/Marlin/Configuration.h
    sed -i '/#define Y_DRIVER_TYPE/c\#define Y_DRIVER_TYPE TMC2208' marlin/Marlin/Configuration.h
    sed -i '/#define Z_DRIVER_TYPE/c\#define Z_DRIVER_TYPE TMC2208' marlin/Marlin/Configuration.h
    sed -i '/#define Z2_DRIVER_TYPE/c\#define Z2_DRIVER_TYPE TMC2208' marlin/Marlin/Configuration.h
    sed -i '/#define E0_DRIVER_TYPE/c\#define E0_DRIVER_TYPE TMC2208' marlin/Marlin/Configuration.h
    sed -i '/#define E1_DRIVER_TYPE/c\#define E1_DRIVER_TYPE TMC2208' marlin/Marlin/Configuration.h
    sed -i '/#define Z_DUAL_STEPPER_DRIVERS/c\#define Z_DUAL_STEPPER_DRIVERS' marlin/Marlin/Configuration_adv.h
}

function enableProgress()
{
    sed -i '/#define LCD_SET_PROGRESS_MANUALLY/c\#define LCD_SET_PROGRESS_MANUALLY' marlin/Marlin/Configuration_adv.h
}

function invertStepMotors()
{
    sed -i '/#define INVERT_X_DIR/c\#define INVERT_X_DIR false' marlin/Marlin/Configuration.h
    sed -i '/#define INVERT_Y_DIR/c\#define INVERT_Y_DIR false' marlin/Marlin/Configuration.h
    sed -i '/#define INVERT_Z_DIR/c\#define INVERT_Z_DIR true' marlin/Marlin/Configuration.h
    sed -i '/#define INVERT_E0_DIR/c\#define INVERT_E0_DIR false' marlin/Marlin/Configuration.h
}

function invertEndStops()
{
    sed -i '/#define X_MIN_ENDSTOP_INVERTING/c\#define X_MIN_ENDSTOP_INVERTING true' marlin/Marlin/Configuration.h
    sed -i '/#define Y_MIN_ENDSTOP_INVERTING/c\#define Y_MIN_ENDSTOP_INVERTING true' marlin/Marlin/Configuration.h
    sed -i '/#define Z_MIN_ENDSTOP_INVERTING/c\#define Z_MIN_ENDSTOP_INVERTING true' marlin/Marlin/Configuration.h
}

setStepperResolution256()
{
    sed -i '/#define X_MICROSTEPS/c\#define X_MICROSTEPS 256' marlin/Marlin/Configuration_adv.h
    sed -i '/#define Y_MICROSTEPS/c\#define Y_MICROSTEPS 256' marlin/Marlin/Configuration_adv.h
    sed -i '/#define Z_MICROSTEPS/c\#define Z_MICROSTEPS 256' marlin/Marlin/Configuration_adv.h
    sed -i '/#define Z2_MICROSTEPS/c\#define Z2_MICROSTEPS 256' marlin/Marlin/Configuration_adv.h
    sed -i '/#define E0_MICROSTEPS/c\#define E0_MICROSTEPS 256' marlin/Marlin/Configuration_adv.h
}

function setStepsPerAxis256Steps()
{
    sed -i '/#define DEFAULT_AXIS_STEPS_PER_UNIT/c\#define DEFAULT_AXIS_STEPS_PER_UNIT   { 1600, 1600, 6400, 1600 }' marlin/Marlin/Configuration.h
}

function setDimensions()
{
    sed -i '/#define X_BED_SIZE/c\#define X_BED_SIZE 220' marlin/Marlin/Configuration.h
    sed -i '/#define Y_BED_SIZE/c\#define Y_BED_SIZE 220' marlin/Marlin/Configuration.h
    sed -i '/#define X_MIN_POS/c\#define X_MIN_POS -34' marlin/Marlin/Configuration.h
    sed -i '/#define X_MAX_POS/c\#define X_MAX_POS 230' marlin/Marlin/Configuration.h
    sed -i '/#define Y_MIN_POS/c\#define Y_MIN_POS -8' marlin/Marlin/Configuration.h
    sed -i '/#define Y_MAX_POS/c\#define Y_MAX_POS 234' marlin/Marlin/Configuration.h
    sed -i '/#define Z_MAX_POS/c\#define Z_MAX_POS 230' marlin/Marlin/Configuration.h
    sed -i '/#define MESH_INSET/c\#define MESH_INSET 25' marlin/Marlin/Configuration.h
}

function enablePause()
{
    sed -i '/#define NOZZLE_PARK_FEATURE/c\#define NOZZLE_PARK_FEATURE' marlin/Marlin/Configuration.h
    sed -i '/#define ADVANCED_PAUSE_FEATURE/c\#define ADVANCED_PAUSE_FEATURE' marlin/Marlin/Configuration_adv.h
}

function enableBedAutoLeveling()
{
    sed -i '/#define AUTO_BED_LEVELING_UBL/c\#define AUTO_BED_LEVELING_UBL' marlin/Marlin/Configuration.h
    sed -i '/#define LCD_BED_LEVELING/c\#define LCD_BED_LEVELING' marlin/Marlin/Configuration.h
    sed -i '/#define FIX_MOUNTED_PROBE/c\#define FIX_MOUNTED_PROBE' marlin/Marlin/Configuration.h
    sed -i '/#define Z_MIN_PROBE_ENDSTOP_INVERTING/c\#define Z_MIN_PROBE_ENDSTOP_INVERTING true' marlin/Marlin/Configuration.h
    sed -i '/#define NOZZLE_TO_PROBE_OFFSET/c\#define NOZZLE_TO_PROBE_OFFSET { -22, -36, 0 }' marlin/Marlin/Configuration.h
    sed -i '/#define Z_SAFE_HOMING/c\#define Z_SAFE_HOMING' marlin/Marlin/Configuration.h
    sed -i '/#define RESTORE_LEVELING_AFTER_G28/c\#define RESTORE_LEVELING_AFTER_G28' marlin/Marlin/Configuration.h
    sed -i '/#define GRID_MAX_POINTS_X 10/c\#define GRID_MAX_POINTS_X 4' marlin/Marlin/Configuration.h
    sed -i '/#define G26_MESH_VALIDATION/c\#define G26_MESH_VALIDATION' marlin/Marlin/Configuration.h
}

function enableNozzleClean()
{
    sed -i '/#define NOZZLE_CLEAN_FEATURE/c\#define NOZZLE_CLEAN_FEATURE' marlin/Marlin/Configuration.h
}

function enableAbout()
{
    sed -i '/#define LCD_INFO_MENU/c\#define LCD_INFO_MENU' marlin/Marlin/Configuration_adv.h
    sed -i '/#define PRINTCOUNTER/c\#define PRINTCOUNTER' marlin/Marlin/Configuration.h
}

function enableGames()
{
    sed -i '/#define MARLIN_BRICKOUT/c\#define MARLIN_BRICKOUT' marlin/Marlin/Configuration_adv.h
    sed -i '/#define MARLIN_INVADERS/c\#define MARLIN_INVADERS' marlin/Marlin/Configuration_adv.h
    sed -i '/#define MARLIN_SNAKE/c\#define MARLIN_SNAKE' marlin/Marlin/Configuration_adv.h
}

function build()
{
    cd marlin
    ${PLATFORMIO_CORE_DIR}/penv/bin/platformio run
    cd ..
}

function extractFirmware()
{
    cp marlin/.pio/build/LPC1768/firmware.bin FIRMWARE.BIN
}

downloadPlatfromIO
downloadNXPLPCPlatform
downloadMarlin
configureBoard
configurePrinter
enableCR10StockDisplay
enableLinearAdvance
enableSCurve
enableTMC2208Drivers
enableProgress
invertStepMotors
invertEndStops
setStepperResolution256
setStepsPerAxis256Steps
setDimensions
enablePause
enableBedAutoLeveling
enableNozzleClean
enableAbout
enableGames
build
extractFirmware
