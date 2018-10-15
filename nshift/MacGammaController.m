//
//  MacGammaController.m
//  nshift
//
//  Created by Peter Washington on 5/14/18.
//

#import "MacGammaController.h"
#include <dlfcn.h>

@implementation MacGammaController

float quadraticBezier (float x, float a, float b) {
    float epsilon = 0.00001;
    a = MAX(0.0, MIN(1, a));
    b = MAX(0.0, MIN(1, b));
    
    if (a == 0.5) {
        a += epsilon;
    }
    
    float om2a = 1.0f - (2.0f * a);
    float t = (sqrt((a * a) + (om2a * x)) - a) / om2a;
    float y = ((1.0f - 2.0f * b) * (t * t)) + ((2.0f * b) * t);
    return y;
}

float symmetricQuadraticBezier(float x, float bulge) {
    bulge = (bulge / 2.0f) + 0.5f;
    float a = bulge;
    float b = 1.0f - bulge;
    float r = quadraticBezier(x, a, b);
    return r;
}

+ (void)setGammaWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    CGDirectDisplayID displays[12] = {0};
    uint32_t numDisplays = 0;
    
    CGGetActiveDisplayList(12, displays, &numDisplays);
    
    const CGGammaValue redTable[256] = {0.0, red};
    const CGGammaValue greenTable[256] = {0.0, green};
    const CGGammaValue blueTable[256] = {0.0, blue};
    
    const CGGammaValue redTable2[256] = {0.0, red};
    const CGGammaValue greenTable2[256] = {0.0, 0.5};
    const CGGammaValue blueTable2[256] = {0.0, blue};
    
    for (int i = 0; i < numDisplays; i++) {
        //CGSetDisplayTransferByTable(displays[i], 2, redTable, greenTable, blueTable);
        
        CGSetDisplayTransferByTable(displays[i], 2, redTable2, greenTable2, blueTable2);
        
        //CGDisplayRestoreColorSyncSettings();
    }
}

+ (void)setWhitePoint:(CGFloat)whitePoint {
    CGDirectDisplayID displays[12] = {0};
    uint32_t numDisplays = 0;
    
    CGGetActiveDisplayList(12, displays, &numDisplays);
    
    CGGammaValue table[256] = {0.0, 0.0};
    
    for (int i = 0; i < 256; i++) {
        table[i] = symmetricQuadraticBezier(i / 255.0f, (whitePoint * 2) - 1);
    }
    
    NSAssert(whitePoint <= 0.5, @"White point value should not be greater than 0.5!");
    
    for (int i = 0; i < numDisplays; i++) {
        CGSetDisplayTransferByTable(CGMainDisplayID(), 256, table, table, table);
    }
}

+ (void)setGammaWithOrangeness:(CGFloat)percentOrange {
    if (percentOrange > 1) {
        percentOrange = 1;
    }
    else if (percentOrange < 0) {
        percentOrange = 0;
    }
    
    float red = 1.0;
    float blue = 1 - percentOrange;
    float green = (red + blue) / 2.0;
    
    if (percentOrange == 0) {
        red = blue = green = 1;
    }
    
    [self setGammaWithRed:red green:green blue:blue];
}

+ (void)setInvertedColorsEnabled:(BOOL)enabled {
    void *(*CGDisplaySetInvertedPolarity)(BOOL invertedPolarity) = dlsym(RTLD_DEFAULT, "CGDisplaySetInvertedPolarity");
    NSParameterAssert(CGDisplaySetInvertedPolarity);
    CGDisplaySetInvertedPolarity(enabled);
}

@end

