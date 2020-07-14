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
        svn export "https://github.com/bigtreetech/BIGTREETECH-SKR-V1.3.git/trunk/BTT SKR V1.3/firmware/Marlin-bugfix-2.0.x" marlin
    fi
}

function setPrinterName()
{
    sed -i '/#define CUSTOM_MACHINE_NAME/c\#define CUSTOM_MACHINE_NAME \"Anet-A8\"' marlin/Marlin/Configuration.h
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
    sed -i '/#define Y_MIN_POS/c\#define Y_MIN_POS -8' marlin/Marlin/Configuration.h
    sed -i '/#define Z_MAX_POS/c\#define Z_MAX_POS 230' marlin/Marlin/Configuration.h
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
setPrinterName
enableCR10StockDisplay
enableLinearAdvance
enableTMC2208Drivers
enableProgress
invertStepMotors
invertEndStops
setStepperResolution256
setStepsPerAxis256Steps
setDimensions
enablePause
enableBedAutoLeveling
build
extractFirmware
