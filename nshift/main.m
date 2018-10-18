// Program to adjust the color temperature and hue of the screen.

// Copyright 2018 Peter Washington, Pervasive Wellbeing Technology Lab.



#import <Foundation/Foundation.h>
#import "CBBlueLightClient.h"
#import "MacGammaController.h"

#include <mach/mach.h>
#include <mach/mach_time.h>

static const uint64_t NANOS_PER_USEC = 1000ULL;
static const uint64_t NANOS_PER_MILLISEC = 1000ULL * NANOS_PER_USEC;
static const uint64_t NANOS_PER_SEC = 1000ULL * NANOS_PER_MILLISEC;

uint64_t time_to_wait_subliminal = 0.01 * NANOS_PER_SEC;
uint64_t time_to_wait_noticeable = 5 * NANOS_PER_SEC;

static mach_timebase_info_data_t timebase_info;

// PARAMETERS
float COLOR_DELTA = 0.01;
float LOW_R = 0.5;
float HIGH_R = 0.6;
float LOW_G = 0.5;
float HIGH_G = 0.6;
float LOW_B = 0.5;
float HIGH_B = 0.6;
uint64_t TIMESTEP = 0.0155 * NANOS_PER_SEC;

/*
 * TODO:
 *
 * ---------------------------------------------------------------------------------
 * ( ) = TODO
 * ( ) = DONE
 * ---------------------------------------------------------------------------------
 *
 * ( ) Add parameter to set the period (time to get from LOW back to LOW again)
 * ( ) Basically, parameter to set the frequency
 * (-) For 40Hz, the period is 0.025
 * ( ) Know the limits of the LED lights
 * ( ) Calibration phase to modify the gamma values as the thing is running.
 * ( ) Make adaptive system where the human perception wavelength matches the wave of the
 *     oscillations put out by the program.
 * ( ) Make code so that it is really easy to tweak all the parameters at very fine grained in order
 *     to get people's custom wavelengths.
 * ( ) Figure out how to get baseline RGB. Look for a function for getting Gamma display values.
 * ( ) Detect most common "color" value on the screen, and set that to baseline color of the screen.
 * ( ) This most common value will continuously update.
 * ( ) Add ability to have a delay between oscillations. Perhaps another "delay" parameters.
 * ( ) And also a parameter for how long the wave should last when it reaches the top of
 *      the wave as well.
 * (-) Refactor variables to make sense in terms of signal processing / waves.
 * (-) T = 1 / f
 */

static uint64_t abs_to_nanos(uint64_t abs) {
    return abs * timebase_info.numer  / timebase_info.denom;
}

static uint64_t nanos_to_abs(uint64_t nanos) {
    return nanos * timebase_info.denom / timebase_info.numer;
}

void changeColorRecursive(uint64_t n, bool i, float l) {
    //uint64_t next_time_to_schedule = n;
    bool is_increasing = i;
    float level = l;
    
    if (is_increasing) level += COLOR_DELTA;
    else level -= COLOR_DELTA;

    if (level > HIGH_B) is_increasing = false;
    if (level < LOW_B) is_increasing = true;
    
    uint64_t next_time_to_schedule = mach_absolute_time() + TIMESTEP;
    
    [MacGammaController setGammaWithRed:0.5 green:0.5 blue:level ];
    
    // Super quick waiting.
    mach_timebase_info(&timebase_info);
    mach_wait_until(next_time_to_schedule);
    
    changeColorRecursive(0, is_increasing, level);
}

int main(int argc, const char * argv[]) {
    

    //CBBlueLightClient *client = [[CBBlueLightClient alloc] init];
    
    uint64_t next_time_to_schedule = mach_absolute_time();
    changeColorRecursive(next_time_to_schedule, true, 0.55);
    
    // Restore color settings.
    //CGDisplayRestoreColorSyncSettings();
    
    return 0;
}


