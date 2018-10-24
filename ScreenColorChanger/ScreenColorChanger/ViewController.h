//
//  ViewController.h
//  ScreenColorChanger
//
//  Created by Peter Washington on 10/23/18.
//  Copyright © 2018 Peter Washington. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *low_delay;

@property (weak) IBOutlet NSTextField *high_delay;

@property (weak) IBOutlet NSTextField *time_step;

@property (weak) IBOutlet NSTextField *low_r;

@property (weak) IBOutlet NSTextField *low_g;

@property (weak) IBOutlet NSTextField *low_b;

@property (weak) IBOutlet NSTextField *high_r;

@property (weak) IBOutlet NSTextField *high_g;

@property (weak) IBOutlet NSTextField *high_b;


@end

