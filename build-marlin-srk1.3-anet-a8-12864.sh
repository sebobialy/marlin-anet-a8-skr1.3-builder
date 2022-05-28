MARLIN_VERSION="2.0.9.3"

export PLATFORMIO_CORE_DIR=`pwd`/platformio

function error()
{
    echo $1
    exit
}

function sedOrError()
{
    sed -i '/'".*$1.*"'/{s//'"$2"'/;h};${x;/./{x;q1};x}' $3

    return $?
}

function sedOrDie()
{
    sedOrError "$1" "$2" "$3" && error "unknown pattern $1"
}


function downloadPlatfromIO()
{
    if [[ ! -d $PLATFORMIO_CORE_DIR ]]; then
        mkdir platformio
        python3 -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/develop/scripts/get-platformio.py)"
    fi
}

function downloadNXPLPCPlatform()
{
    if [[ ! -d $PLATFORMIO_CORE_DIR/platforms/nxplpc ]]; then
        "${PLATFORMIO_CORE_DIR}/penv/bin/platformio" platform install nxplpc
    fi
}

function downloadMarlin()
{
    if [ ! -d marlin ]; then
        svn export "https://github.com/MarlinFirmware/Marlin/tags/$MARLIN_VERSION" marlin
    fi
}

function configureBoard()
{
    sedOrDie '#define MOTHERBOARD' '#define MOTHERBOARD BOARD_BTT_SKR_V1_3' marlin/Marlin/Configuration.h
    sedOrDie 'default_envs =' 'default_envs = LPC1768' marlin/platformio.ini
    sedOrDie '#define EEPROM_SETTINGS' '#define EEPROM_SETTINGS' marlin/Marlin/Configuration.h
    sedOrDie '#define SERIAL_PORT_2 -1' '#define SERIAL_PORT_2 -1' marlin/Marlin/Configuration.h
    sedOrDie '#define SDSUPPORT' '#define SDSUPPORT' marlin/Marlin/Configuration.h
    sedOrDie '#define SDCARD_CONNECTION' '#define SDCARD_CONNECTION ONBOARD' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define SD_DETECT_STATE HIGH' '#define SD_DETECT_STATE HIGH' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define SD_CHECK_AND_RETRY' '#define SD_CHECK_AND_RETRY' marlin/Marlin/Configuration.h
    sedOrDie '#define LONG_FILENAME_HOST_SUPPORT' '#define LONG_FILENAME_HOST_SUPPORT' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define SCROLL_LONG_FILENAMES' '#define SCROLL_LONG_FILENAMES' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define STATUS_MESSAGE_SCROLLING' '#define STATUS_MESSAGE_SCROLLING' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define MENU_HOLLOW_FRAME' '\/\/#define MENU_HOLLOW_FRAME' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define XYZ_HOLLOW_FRAME' '\/\/#define XYZ_HOLLOW_FRAME' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define STATUS_FAN_FRAMES' '#define STATUS_FAN_FRAMES 4' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define BOOT_MARLIN_LOGO_ANIMATED' '#define BOOT_MARLIN_LOGO_ANIMATED' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define LCD_SHOW_E_TOTAL' '#define LCD_SHOW_E_TOTAL' marlin/Marlin/Configuration_adv.h
}

function configurePrinter()
{
    sedOrDie '#define CUSTOM_MACHINE_NAME' '#define CUSTOM_MACHINE_NAME \"Anet-A8\"' marlin/Marlin/Configuration.h
    sedOrDie '#define DEFAULT_NOMINAL_FILAMENT_DIA' '#define DEFAULT_NOMINAL_FILAMENT_DIA 1.75' marlin/Marlin/Configuration.h
    sedOrDie '#define TEMP_SENSOR_BED' '#define TEMP_SENSOR_BED 1' marlin/Marlin/Configuration.h
    sedOrDie '#define NUM_Z_STEPPER_DRIVERS' '#define NUM_Z_STEPPER_DRIVERS 2' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define BED_MAXTEMP' '#define BED_MAXTEMP 110' marlin/Marlin/Configuration.h
    sedOrDie '#define BABYSTEPPING' '#define BABYSTEPPING' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define BABYSTEP_WITHOUT_HOMING' '#define BABYSTEP_WITHOUT_HOMING' marlin/Marlin/Configuration_adv.h
}

function enableCR10StockDisplay()
{
    sedOrDie '#define CR10_STOCKDISPLAY' '#define CR10_STOCKDISPLAY' marlin/Marlin/Configuration.h
}

function enableLinearAdvance()
{
    sedOrDie '\/\/#define LIN_ADVANCE' '#define LIN_ADVANCE' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define LIN_ADVANCE_K' '#define LIN_ADVANCE_K 0.12' marlin/Marlin/Configuration_adv.h

    # workaround bug on 32 bit boards, extruder does not work if LIN_ADVANCE is enabled
    # https://github.com/MarlinFirmware/Marlin/issues/12983
    sedOrDie '#define MINIMUM_STEPPER_PULSE' '#define MINIMUM_STEPPER_PULSE 1' marlin/Marlin/Configuration_adv.h
}

function enableSCurve()
{
    sedOrDie '#define S_CURVE_ACCELERATION' '#define S_CURVE_ACCELERATION' marlin/Marlin/Configuration.h
}

function enableTMC2208Drivers()
{
    sedOrDie '#define X_DRIVER_TYPE' '#define X_DRIVER_TYPE TMC2208' marlin/Marlin/Configuration.h
    sedOrDie '#define Y_DRIVER_TYPE' '#define Y_DRIVER_TYPE TMC2208' marlin/Marlin/Configuration.h
    sedOrDie '#define Z_DRIVER_TYPE' '#define Z_DRIVER_TYPE TMC2208' marlin/Marlin/Configuration.h
    sedOrDie '#define Z2_DRIVER_TYPE' '#define Z2_DRIVER_TYPE TMC2208' marlin/Marlin/Configuration.h
    sedOrDie '#define E0_DRIVER_TYPE' '#define E0_DRIVER_TYPE TMC2208' marlin/Marlin/Configuration.h
    sedOrDie '#define E1_DRIVER_TYPE' '#define E1_DRIVER_TYPE TMC2208' marlin/Marlin/Configuration.h
}

function enableProgress()
{
    sedOrDie '#define LCD_SET_PROGRESS_MANUALLY' '#define LCD_SET_PROGRESS_MANUALLY' marlin/Marlin/Configuration_adv.h
}

function invertStepMotors()
{
    sedOrDie '#define INVERT_X_DIR' '#define INVERT_X_DIR false' marlin/Marlin/Configuration.h
    sedOrDie '#define INVERT_Y_DIR' '#define INVERT_Y_DIR false' marlin/Marlin/Configuration.h
    sedOrDie '#define INVERT_Z_DIR' '#define INVERT_Z_DIR true' marlin/Marlin/Configuration.h
    sedOrDie '#define INVERT_E0_DIR' '#define INVERT_E0_DIR false' marlin/Marlin/Configuration.h
}

function invertEndStops()
{
    sedOrDie '#define X_MIN_ENDSTOP_INVERTING' '#define X_MIN_ENDSTOP_INVERTING true' marlin/Marlin/Configuration.h
    sedOrDie '#define Y_MIN_ENDSTOP_INVERTING' '#define Y_MIN_ENDSTOP_INVERTING true' marlin/Marlin/Configuration.h
    sedOrDie '#define Z_MIN_ENDSTOP_INVERTING' '#define Z_MIN_ENDSTOP_INVERTING true' marlin/Marlin/Configuration.h
}

setStepperResolution256()
{
    sedOrDie '#define X_MICROSTEPS' '#define X_MICROSTEPS 256' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define Y_MICROSTEPS' '#define Y_MICROSTEPS 256' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define Z_MICROSTEPS' '#define Z_MICROSTEPS 256' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define Z2_MICROSTEPS' '#define Z2_MICROSTEPS 256' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define E0_MICROSTEPS' '#define E0_MICROSTEPS 256' marlin/Marlin/Configuration_adv.h
}

setAccelerations()
{
    sedOrDie '#define DEFAULT_MAX_ACCELERATION' '#define DEFAULT_MAX_ACCELERATION { 1500, 1500, 100, 5000 }' marlin/Marlin/Configuration.h
    sedOrDie '#define DEFAULT_ACCELERATION' '#define DEFAULT_ACCELERATION 1500' marlin/Marlin/Configuration.h
    sedOrDie '#define DEFAULT_RETRACT_ACCELERATION' '#define DEFAULT_RETRACT_ACCELERATION 1500' marlin/Marlin/Configuration.h
    sedOrDie '#define DEFAULT_TRAVEL_ACCELERATION' '#define DEFAULT_TRAVEL_ACCELERATION 1500' marlin/Marlin/Configuration.h
}

function setStepsPerAxis256Steps()
{
    sedOrDie '#define DEFAULT_AXIS_STEPS_PER_UNIT' '#define DEFAULT_AXIS_STEPS_PER_UNIT   { 1600, 1600, 6400, 1600 }' marlin/Marlin/Configuration.h
}

function setDimensions()
{
    sedOrDie '#define X_BED_SIZE' '#define X_BED_SIZE 220' marlin/Marlin/Configuration.h
    sedOrDie '#define Y_BED_SIZE' '#define Y_BED_SIZE 220' marlin/Marlin/Configuration.h
    sedOrDie '#define X_MIN_POS' '#define X_MIN_POS -17' marlin/Marlin/Configuration.h
    sedOrDie '#define X_MAX_POS' '#define X_MAX_POS 230' marlin/Marlin/Configuration.h
    sedOrDie '#define Y_MIN_POS' '#define Y_MIN_POS -8' marlin/Marlin/Configuration.h
    sedOrDie '#define Y_MAX_POS' '#define Y_MAX_POS 234' marlin/Marlin/Configuration.h
    sedOrDie '#define Z_MAX_POS' '#define Z_MAX_POS 230' marlin/Marlin/Configuration.h
    sedOrDie '#define MESH_INSET' '#define MESH_INSET 25' marlin/Marlin/Configuration.h
}

function enablePause()
{
    sedOrDie '#define NOZZLE_PARK_FEATURE' '#define NOZZLE_PARK_FEATURE' marlin/Marlin/Configuration.h
    sedOrDie '#define ADVANCED_PAUSE_FEATURE' '#define ADVANCED_PAUSE_FEATURE' marlin/Marlin/Configuration_adv.h
}

function enableBedAutoLeveling()
{
    sedOrDie '#define AUTO_BED_LEVELING_UBL' '#define AUTO_BED_LEVELING_UBL' marlin/Marlin/Configuration.h
    sedOrDie '#define LCD_BED_LEVELING' '#define LCD_BED_LEVELING' marlin/Marlin/Configuration.h
    sedOrDie '#define FIX_MOUNTED_PROBE' '#define FIX_MOUNTED_PROBE' marlin/Marlin/Configuration.h
    sedOrDie '#define Z_MIN_PROBE_ENDSTOP_INVERTING' '#define Z_MIN_PROBE_ENDSTOP_INVERTING true' marlin/Marlin/Configuration.h
    sedOrDie '#define NOZZLE_TO_PROBE_OFFSET' '#define NOZZLE_TO_PROBE_OFFSET { -22, -36, 0 }' marlin/Marlin/Configuration.h
    sedOrDie '#define Z_SAFE_HOMING' '#define Z_SAFE_HOMING' marlin/Marlin/Configuration.h
    sedOrDie '#define RESTORE_LEVELING_AFTER_G28' '#define RESTORE_LEVELING_AFTER_G28' marlin/Marlin/Configuration.h
    sedOrDie '#define GRID_MAX_POINTS_X' '#define GRID_MAX_POINTS_X 4' marlin/Marlin/Configuration.h
    sedOrDie '#define G26_MESH_VALIDATION' '#define G26_MESH_VALIDATION' marlin/Marlin/Configuration.h
}

function enableNozzleClean()
{
    sedOrDie '#define NOZZLE_CLEAN_FEATURE' '#define NOZZLE_CLEAN_FEATURE' marlin/Marlin/Configuration.h
}

function enableAbout()
{
    sedOrDie '#define LCD_INFO_MENU' '#define LCD_INFO_MENU' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define PRINTCOUNTER' '#define PRINTCOUNTER' marlin/Marlin/Configuration.h
}

function enableGames()
{
    sedOrDie '#define MARLIN_BRICKOUT' '#define MARLIN_BRICKOUT' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define MARLIN_INVADERS' '#define MARLIN_INVADERS' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define MARLIN_SNAKE' '#define MARLIN_SNAKE' marlin/Marlin/Configuration_adv.h
}

function enablePids()
{
    sedOrDie '#define PID_EDIT_MENU' '#define PID_EDIT_MENU' marlin/Marlin/Configuration.h
    sedOrDie '#define PID_AUTOTUNE_MENU' '#define PID_AUTOTUNE_MENU' marlin/Marlin/Configuration.h
    sedOrDie '#define PIDTEMPBED' '#define PIDTEMPBED' marlin/Marlin/Configuration.h
}

function enableHostActionCommands()
{
    sedOrDie '#define HOST_ACTION_COMMANDS' '#define HOST_ACTION_COMMANDS' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define HOST_PAUSE_M76' '#define HOST_PAUSE_M76' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define HOST_PROMPT_SUPPORT' '#define HOST_PROMPT_SUPPORT' marlin/Marlin/Configuration_adv.h
    sedOrDie '#define HOST_START_MENU_ITEM' '#define HOST_START_MENU_ITEM' marlin/Marlin/Configuration_adv.h
}

function build()
{
    cd marlin
    "${PLATFORMIO_CORE_DIR}/penv/bin/platformio" run
    cd ..
}

function extractFirmware()
{
    cp marlin/.pio/build/LPC1768/firmware.bin FIRMWARE.BIN
}

function setupBMGExtruder()
{
    # https://www.thingiverse.com/thing:3807114
    # https://www.thingiverse.com/thing:3951233
    sedOrDie '#define NOZZLE_TO_PROBE_OFFSET' '#define NOZZLE_TO_PROBE_OFFSET { 42, 0, 0 }' marlin/Marlin/Configuration.h
    sedOrDie '#define INVERT_E0_DIR' '#define INVERT_E0_DIR false' marlin/Marlin/Configuration.h
    sedOrDie '#define DEFAULT_AXIS_STEPS_PER_UNIT' '#define DEFAULT_AXIS_STEPS_PER_UNIT   { 1600, 1600, 6400, 6640 }' marlin/Marlin/Configuration.h
    sedOrDie '#define X_BED_SIZE' '#define X_BED_SIZE 220' marlin/Marlin/Configuration.h
    sedOrDie '#define Y_BED_SIZE' '#define Y_BED_SIZE 220' marlin/Marlin/Configuration.h
    sedOrDie '#define X_MIN_POS' '#define X_MIN_POS -17' marlin/Marlin/Configuration.h
    sedOrDie '#define X_MAX_POS' '#define X_MAX_POS 220+17' marlin/Marlin/Configuration.h
    sedOrDie '#define Y_MIN_POS' '#define Y_MIN_POS -7' marlin/Marlin/Configuration.h
    sedOrDie '#define Y_MAX_POS' '#define Y_MAX_POS 220+7' marlin/Marlin/Configuration.h
    sedOrDie '#define Z_MAX_POS' '#define Z_MAX_POS 240' marlin/Marlin/Configuration.h
}

function setupBLTouch()
{
    sedOrDie '#define Z_MIN_ENDSTOP_INVERTING' '#define Z_MIN_ENDSTOP_INVERTING false' marlin/Marlin/Configuration.h
    sedOrDie '#define Z_MIN_PROBE_ENDSTOP_INVERTING' '#define Z_MIN_PROBE_ENDSTOP_INVERTING false' marlin/Marlin/Configuration.h
    sedOrDie '#define BLTOUCH' '#define BLTOUCH' marlin/Marlin/Configuration.h
    sedOrDie '#define FIX_MOUNTED_PROBE' '\/\/#define FIX_MOUNTED_PROBE' marlin/Marlin/Configuration.h
    sedOrDie '#define BLTOUCH_DELAY' '#define BLTOUCH_DELAY 700' marlin/Marlin/Configuration_adv.h
}


downloadPlatfromIO
downloadNXPLPCPlatform
downloadMarlin
configureBoard
configurePrinter
enableCR10StockDisplay
enableLinearAdvance
#enableSCurve
enableTMC2208Drivers
enableProgress
invertStepMotors
invertEndStops
setStepperResolution256
setStepsPerAxis256Steps
setAccelerations
setDimensions
enablePause
enableBedAutoLeveling
enableNozzleClean
enableAbout
enableGames
setupBMGExtruder
setupBLTouch
enablePids
enableHostActionCommands
build
extractFirmware
