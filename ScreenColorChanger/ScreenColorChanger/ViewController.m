//
//  ViewController.m
//  ScreenColorChanger
//
//  Created by Peter Washington on 10/23/18.
//  Copyright © 2018 Peter Washington. All rights reserved.
//

#import "ViewController.h"

#import "MacGammaController.h"
#include <mach/mach.h>
#include <mach/mach_time.h>

@implementation ViewController



/*
 * TODO - 10/24/2018
 *
 * This week: focus on the biology rather than the technical aspects.
 * Understand eye perception of signal and what is getting to the visual cortex. Prepare a slide.
 * In parallel, use a colorimiter to measure color / pupil dialation as well as EEG.
 * Talk with neuroscience friends; get in room with whiteboard and explain what we are doing.
 * Invite Pablo if possible.
 * Do we see signal / is visual cortex simulated with the low frequency????
 *
 * ----------------------------------------------------------------------------------------
 *
 * Get a coloromiter to verify!!!
 * Parameterize the rest of the variables.
 * Can buil different "duty cycles" with the delays.
 *
 */


static const uint64_t NANOS_PER_USEC = 1000ULL;
static const uint64_t NANOS_PER_MILLISEC = 1000ULL * NANOS_PER_USEC;
static const uint64_t NANOS_PER_SEC = 1000ULL * NANOS_PER_MILLISEC;

uint64_t time_to_wait_subliminal = 0.01 * NANOS_PER_SEC;
uint64_t time_to_wait_noticeable = 5 * NANOS_PER_SEC;

static mach_timebase_info_data_t timebase_info;

// PARAMETERS
float COLOR_DELTA = 0.0005;
float LOW_R = 0.4;
float HIGH_R = 0.45;
float LOW_G = 0.4;
float HIGH_G = 0.45;
float LOW_B = 0.4;
float HIGH_B = 0.45;
float DURATION_HIGH_R = 0.0025;
float DURATION_LOW_R = 0.0025;
float DURATION_HIGH_G = 0.0025;
float DURATION_LOW_G = 0.0025;
float DURATION_HIGH_B = 0.0025;
float DURATION_LOW_B = 0.0025;
uint64_t TIMESTEP = 0.00125 * NANOS_PER_SEC; // 0.0005 = 10Hz, 0.00125 = 4Hz

bool shouldStop = false;


static uint64_t abs_to_nanos(uint64_t abs) {
    return abs * timebase_info.numer  / timebase_info.denom;
}

static uint64_t nanos_to_abs(uint64_t nanos) {
    return nanos * timebase_info.denom / timebase_info.numer;
}

void changeColorRecursive(bool ir, float lr, bool ig, float lg, bool ib, float lb,
                          int8_t dhr, int8_t dhg, int8_t dhb, int8_t dlr, int8_t dlg, int8_t dlb, int64_t iter) {
    // Copy input parameters.
    bool is_increasing_r = ir;
    float level_r = lr;
    bool is_increasing_g = ig;
    float level_g = lg;
    bool is_increasing_b = ib;
    float level_b = lb;
    int8_t delay_high_r = dhr;
    int8_t delay_low_r = dlr;
    int8_t delay_high_g = dhg;
    int8_t delay_low_g = dlg;
    int8_t delay_high_b = dhb;
    int8_t delay_low_b = dlb;
    int64_t iteration = iter;
    
    // Terminate after the recursive function stack gets overloaded.
    if (iteration > 40000) {
        return;
    }
    
    // End if the "Stop" button has been pressed.
    if (shouldStop) {
        CGDisplayRestoreColorSyncSettings();
        return;
    }
    
    // Detect when color thresholds have been exceeded.
    if (level_r > HIGH_R) {
        is_increasing_r = false;
        delay_high_r = 0;
    }
    if (level_r < LOW_R) {
        is_increasing_r = true;
        delay_low_r = 0;
    }
    if (level_g > HIGH_G) {
        is_increasing_g = false;
        delay_high_g = 0;
    }
    if (level_g < LOW_G) {
        is_increasing_g = true;
        delay_low_g = 0;
    }
    if (level_b > HIGH_B) {
        is_increasing_b = false;
        delay_high_b = 0;
    }
    if (level_b < LOW_B) {
        is_increasing_b = true;
        delay_low_b = 0;
    }
    
    // Increase delay clock. Reset delay clock when exceed threshold.
    if (delay_high_r > -1) {
        if (delay_high_r >= DURATION_HIGH_R) {
            delay_high_r = -1;
        } else {
            delay_high_r++;
        }
    }
    if (delay_low_r > -1) {
        if (delay_low_r >= DURATION_LOW_R) {
            delay_low_r = -1;
        } else {
            delay_low_r++;
        }
    }
    if (delay_high_g > -1) {
        if (delay_high_g >= DURATION_HIGH_G) {
            delay_high_g = -1;
        } else {
            delay_high_g++;
        }
    }
    if (delay_low_g > -1) {
        if (delay_low_g >= DURATION_LOW_G) {
            delay_low_g = -1;
        } else {
            delay_low_g++;
        }
    }
    if (delay_high_b > -1) {
        if (delay_high_b >= DURATION_HIGH_B) {
            delay_high_b = -1;
        } else {
            delay_high_b++;
        }
    }
    if (delay_low_b > -1) {
        if (delay_low_b >= DURATION_LOW_B) {
            delay_low_b = -1;
        } else {
            delay_low_b++;
        }
    }
    
    // Increase or decrease color level on each channel. Also account for delays.
    if (delay_high_r == -1 && is_increasing_r) {
        level_r += COLOR_DELTA;
    }
    else if (delay_low_r == -1 && !is_increasing_r) {
        level_r -= COLOR_DELTA;
    }
    if (delay_high_g == -1 && is_increasing_g) {
        level_g += COLOR_DELTA;
    }
    else if (delay_low_g == -1 && !is_increasing_g) {
        level_g -= COLOR_DELTA;
    }
    if (delay_high_b == -1 && is_increasing_b) {
        level_b += COLOR_DELTA;
    }
    else if (delay_low_b == -1 && !is_increasing_b) {
        level_b -= COLOR_DELTA;
    }
    
    // Actually set the monitor display settings.
    [MacGammaController setGammaWithRed:level_r green:level_g blue:level_b];
    
    // Super quick waiting.
    uint64_t next_time_to_schedule = mach_absolute_time() + TIMESTEP;
    mach_timebase_info(&timebase_info);
    mach_wait_until(next_time_to_schedule);
    
    // Recursively call the next iteration of the color change.
    changeColorRecursive(is_increasing_r, level_r, is_increasing_g, level_g, is_increasing_b, level_b,
                         delay_high_r, delay_high_g, delay_high_b, delay_low_r, delay_low_g, delay_low_b, iteration + 1);
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    
    //uint64_t next_time_to_schedule = mach_absolute_time();
    //changeColorRecursive(true, 0.55, true, 0.55, true, 0.55,
    // -1, -1, -1, -1, -1, -1);
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (IBAction)onStartPressed:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        changeColorRecursive(true, 0.55, true, 0.55, true, 0.55,
                             -1, -1, -1, -1, -1, -1, 0);
    });
}


- (IBAction)onStopPressed:(id)sender {
    // Restore color settings.
    shouldStop = true;
}


- (IBAction)onChangeLowDelay:(id)sender {
    DURATION_LOW_R = [_low_delay doubleValue];
    DURATION_LOW_G = [_low_delay doubleValue];
    DURATION_LOW_B = [_low_delay doubleValue];
}


- (IBAction)onChangeHighDelay:(id)sender {
    DURATION_HIGH_R = [_high_delay doubleValue];
    DURATION_HIGH_G = [_high_delay doubleValue];
    DURATION_HIGH_B = [_high_delay doubleValue];
}


- (IBAction)onChangeTimestep:(id)sender {
    TIMESTEP = [_time_step doubleValue];
}


- (IBAction)onChangeLowR:(id)sender {
    LOW_R = [_low_r doubleValue];
}


- (IBAction)onChangeLowG:(id)sender {
    LOW_G = [_low_g doubleValue];
}


- (IBAction)onChangeLowB:(id)sender {
    LOW_B = [_low_b doubleValue];
}


- (IBAction)onChangeHighR:(id)sender {
    HIGH_R = [_high_r doubleValue];
}


- (IBAction)onChangeHighG:(id)sender {
    HIGH_G = [_high_g doubleValue];
}


- (IBAction)onChangeHighB:(id)sender {
    HIGH_B = [_high_b doubleValue];
}


@end
