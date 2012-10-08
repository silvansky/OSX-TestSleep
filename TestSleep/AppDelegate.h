//
//  AppDelegate.h
//  TestSleep
//
//  Created by Valentine Gorshkov on 08.10.12.
//  Copyright (c) 2012 silvansky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet NSButton *toggleButton;
@property (nonatomic, retain) IBOutlet NSTextField *timerField;
@property (nonatomic, retain) IBOutlet NSTextField *statusField;

- (IBAction)toggle:(id)sender;

@end
