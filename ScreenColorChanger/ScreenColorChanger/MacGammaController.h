//
//  MacGammaController.h
//  nshift
//
//  Created by Peter Washington on 5/14/18.
//

#import <Foundation/Foundation.h>

@interface MacGammaController : NSObject

+ (void)setGammaWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (void)setGammaWithOrangeness:(CGFloat)percentOrange;
+ (void)setInvertedColorsEnabled:(BOOL)enabled;
+ (void)resetAllAdjustments;
+ (void)toggleDarkroom;
+ (void)toggleSystemTheme;
+ (void)setWhitePoint:(CGFloat)whitePoint;

@end

