//
//  AppDelegate.m
//  TestSleep
//
//  Created by Valentine Gorshkov on 08.10.12.
//  Copyright (c) 2012 silvansky. All rights reserved.
//

#import "AppDelegate.h"

#import <IOKit/pwr_mgt/IOPMLib.h>


@implementation AppDelegate
{
	IOPMAssertionID _assertionID;
	NSTimer *_timer;
	NSDate *_lastClickTime;
}

- (void)dealloc
{
	self.toggleButton = nil;
	self.timerField = nil;
	self.statusField = nil;
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	_assertionID = kIOPMNullAssertionID;
	_timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
	_lastClickTime = [[NSDate date] retain];
}

- (void)onTimer:(NSTimer *)timer
{
	if (timer == _timer)
	{
		NSDate *currentTime = [NSDate date];
		NSTimeInterval _interval = [currentTime timeIntervalSinceDate:_lastClickTime];
		unsigned long interval = _interval;
		unsigned long hours = interval / (60 * 60);
		unsigned long minutes = interval / 60;
		unsigned long seconds = interval % 60;
		NSString *elapsedTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
		[self.timerField setStringValue:elapsedTime];
	}
}

- (void)logAssertions
{
	NSLog(@"\n_____________________\n");
    NSDictionary* assertions = nil;
    IOPMCopyAssertionsByProcess((CFDictionaryRef*)&assertions);
    NSLog(@"%@", assertions);
}

- (IBAction)toggle:(id)sender
{
	if (_assertionID == kIOPMNullAssertionID)
	{
		// toggle on
		CFStringRef reasonForActivity= CFSTR("Test reason");

		SInt32 sysVer = 0;
		Gestalt(gestaltSystemVersion, &sysVer);
		CFStringRef sleepKey;
		if (sysVer < 0x1070)
		{
			sleepKey = kIOPMAssertionTypeNoDisplaySleep;
		}
		else
		{
			sleepKey = kIOPMAssertionTypePreventUserIdleDisplaySleep;
		}

		IOReturn success = IOPMAssertionCreateWithName(sleepKey, kIOPMAssertionLevelOn, reasonForActivity, &_assertionID);
		[self.statusField setStringValue:@"Assert ON"];
		NSLog(@"*** lock: %d, success: %d", _assertionID, success);
		[self logAssertions];
	}
	else
	{
		// toggle off
		IOReturn success = IOPMAssertionRelease(_assertionID);
		[self.statusField setStringValue:@"Assert OFF"];
		NSLog(@"*** unlock: %d. success: %d", _assertionID, success);
		_assertionID = kIOPMNullAssertionID;
		[self logAssertions];
	}
	[_lastClickTime release];
	_lastClickTime = [[NSDate date] retain];
}

@end
