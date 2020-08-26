//
//  UnsupportedNotice.m
//  TogglDesktop
//
//  Created by Indrek Vändrik on 23/11/2018.
//  Copyright © 2018 Alari. All rights reserved.
//

#import "UnsupportedNotice.h"

@interface UnsupportedNotice ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation UnsupportedNotice

+ (instancetype)sharedInstance
{
	static UnsupportedNotice *instance;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		instance = [[UnsupportedNotice alloc] init];
	});
	return instance;
}

- (BOOL)unsupportedOS
{
	NSOperatingSystemVersion osVersion = [[NSProcessInfo processInfo] operatingSystemVersion];

	return (osVersion.majorVersion == 10 && osVersion.minorVersion < 11);
}

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		[self addButtonWithTitle:@"OK"];
		[self setAlertStyle:NSWarningAlertStyle];

		self.dateFormatter = [[NSDateFormatter alloc] init];
		self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
		self.dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
	}

	return self;
}

- (BOOL)validateOSVersion
{
	if (self.unsupportedOS)
	{
		[self showNotice];
	}
	return !self.unsupportedOS;
}

- (void)showNotice
{
	NSDate *today = [NSDate date];
	NSDate *deadline = [self.dateFormatter dateFromString:@"2019-01-01 00:00:00"];
	NSComparisonResult result = [today compare:deadline];

	NSString *title = [NSString stringWithFormat:@"Mac OS X version not supported"];
	NSString *text = @"";

	if (result == NSOrderedAscending)
	{
		text = @"Toggl Track will stop working with your current version of OS X from the 1st of January 2019.\n\n";
	}

	text = [text stringByAppendingString:@"Please upgrade your system to macOS 10.11 or later to continue using Toggl Track."];

	[self setMessageText:title];
	[self setInformativeText:text];
	[self runModal];

	if (result != NSOrderedAscending)
	{
		[[NSApplication sharedApplication] terminate:self];
	}
}

@end
