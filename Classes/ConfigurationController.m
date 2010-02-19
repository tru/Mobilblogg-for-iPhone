//
//  ConfigurationController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-12-19.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "ConfigurationController.h"
#import "MBStore.h"


@implementation ConfigurationController

+(void)redirectConsoleLogToDocumentFolder
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *logPath = [documentsDirectory
                       stringByAppendingPathComponent:@"console.log"];
  freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

-(id)init
{
	self = [super init];
	self.title = NSLocalizedString(@"Settings", nil);
	self.tableViewStyle = UITableViewStyleGrouped;
	
	[[TTNavigator navigator].URLMap	from:@"mb://_cleardata" toViewController:self selector:@selector(clearData)];
	[[TTNavigator navigator].URLMap	from:@"mb://_clearpassword" toViewController:self selector:@selector(clearPassword)];
	
	return self;
}

-(void)createModel
{
	
	_alwaysShowCaptionSwitch = [[[UISwitch alloc] init] autorelease];
	_debugLogSwitch = [[[UISwitch alloc] init] autorelease];
	
	if ([MBStore getBoolForKey:@"hideCaptions"]) {
		_alwaysShowCaptionSwitch.on = NO;
	} else {
		_alwaysShowCaptionSwitch.on = YES;
	}
	[_alwaysShowCaptionSwitch addTarget:self action:@selector(switchAlwaysShowCaption) forControlEvents:UIControlEventValueChanged];
	TTTableControlItem *alwaysShowCaption = [TTTableControlItem itemWithCaption:NSLocalizedString(@"Always show caption", nil)
																		control:_alwaysShowCaptionSwitch];

	if ([MBStore getBoolForKey:@"debugLog"]) {
		_debugLogSwitch.on = YES;
	} else {
		_debugLogSwitch.on = NO;
	}
	[_debugLogSwitch addTarget:self action:@selector(switchDebugLog) forControlEvents:UIControlEventValueChanged];
	TTTableControlItem *debugLogItem = [TTTableControlItem itemWithCaption:NSLocalizedString(@"Enable debug log", nil)
																		control:_debugLogSwitch];
	
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
					   NSLocalizedString(@"Credentials", nil),
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Configure credentials", nil) URL:@"mb://userconfmodal/no"],
					   NSLocalizedString(@"Application", nil),
					   alwaysShowCaption,
#ifdef DEBUGBUILD					   
					   NSLocalizedString(@"Debug", nil),
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Clear password", nil) URL:@"mb://_clearpassword"],
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Clear stored data", nil) URL:@"mb://_cleardata"],
					   debugLogItem,
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Show debug log", nil) URL:@"mb://debuglog"],
#endif
					   nil];
					   
}

-(void)switchAlwaysShowCaption
{
	[MBStore setBool:!_alwaysShowCaptionSwitch.on forKey:@"hideCaptions"];
}

-(void)switchDebugLog
{
	NSLog(@"debuglog switch! %d", _debugLogSwitch.on);
	[MBStore setBool:_debugLogSwitch.on forKey:@"debugLog"];
	if (_debugLogSwitch.on) {
		[ConfigurationController redirectConsoleLogToDocumentFolder];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please restart!", nil)
														message:NSLocalizedString(@"When disabling the log you need to restart the application", nil)
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"OK", nil)
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

-(void)clearData
{
	TTDINFO(@"Removing stored data");
	[MBStore removeAllData];
	[self dismissModalViewController];
}

-(void)clearPassword
{
	TTDINFO(@"Removing stored password");
	[MBStore removePassword];
	[self dismissModalViewController];
}

@end
