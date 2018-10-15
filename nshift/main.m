// Program to adjust the color temperature and hue of the screen.

// Copyright 2018 Peter Washington, Pervasive Wellbeing Technology Lab.



#import <Foundation/Foundation.h>
#import "CBBlueLightClient.h"
#import "MacGammaController.h"

#include <mach/mach.h>
#include <mach/mach_time.h>

#define RATE_OF_CHANGE 0.001


#define STUDY_CONDITION 1

static const uint64_t NANOS_PER_USEC = 1000ULL;
static const uint64_t NANOS_PER_MILLISEC = 1000ULL * NANOS_PER_USEC;
static const uint64_t NANOS_PER_SEC = 1000ULL * NANOS_PER_MILLISEC;

uint64_t time_to_wait_subliminal = 0.01 * NANOS_PER_SEC;
uint64_t time_to_wait_noticeable = 5 * NANOS_PER_SEC;

static mach_timebase_info_data_t timebase_info;

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
    
    if (is_increasing) level += 0.001;
    else level -= 0.005;

    if (level > 0.33) is_increasing = false;
    if (level < 0.27) is_increasing = true;
    
    uint64_t next_time_to_schedule = mach_absolute_time() + time_to_wait_subliminal;
    
    [MacGammaController setGammaWithRed:0 green:0 blue:level];
    
    // Super quick waiting.
    mach_timebase_info(&timebase_info);
    mach_wait_until(next_time_to_schedule);
    
    changeColorRecursive(0, is_increasing, level);
}

int main(int argc, const char * argv[]) {
    
    // INITIALIZE VARIABLES
    CBBlueLightClient *client = [[CBBlueLightClient alloc] init];
    uint64_t next_time_to_schedule = mach_absolute_time();
    
    changeColorRecursive(next_time_to_schedule, true, 0.3);
    
    // Restore color settings.
    //CGDisplayRestoreColorSyncSettings();
    
    return 0;
}


