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
	
	if ([MBStore getBoolForKey:@"hideCaptions"]) {
		_alwaysShowCaptionSwitch.on = NO;
	} else {
		_alwaysShowCaptionSwitch.on = YES;
	}
	[_alwaysShowCaptionSwitch addTarget:self action:@selector(switchAlwaysShowCaption) forControlEvents:UIControlEventValueChanged];
	TTTableControlItem *alwaysShowCaption = [TTTableControlItem itemWithCaption:NSLocalizedString(@"Always show caption", nil)
																		control:_alwaysShowCaptionSwitch];

#if 0
	_savePhoto = [[[UISwitch alloc] init] autorelease];
	
	if ([MBStore getBoolForKey:@"savePhotos"]) {
		_savePhoto.on = NO;
	} else {
		_savePhoto.on = YES;
	}
	[_savePhoto	addTarget:self action:@selector(switchSavePhoto) forControlEvents:UIControlEventValueChanged];

	TTTableControlItem *savePhotoToLibrary = [TTTableControlItem itemWithCaption:NSLocalizedString(@"Save photo", nil)
																		 control:_savePhoto];
#endif
	
	
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
					   NSLocalizedString(@"Credentials", nil),
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Configure credentials", nil) URL:@"mb://userconfmodal/no"],
					   NSLocalizedString(@"Application", nil),
					   alwaysShowCaption,
#ifdef DEBUG					   
					   NSLocalizedString(@"Debug", nil),
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Clear password", nil) URL:@"mb://_clearpassword"],
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Clear stored data", nil) URL:@"mb://_cleardata"],

#endif
					   nil];
					   
}

-(void)switchAlwaysShowCaption
{
	[MBStore setBool:!_alwaysShowCaptionSwitch.on forKey:@"hideCaptions"];
}

-(void)switchSavePhoto
{
	[MBStore setBool:!_savePhoto.on forKey:@"savePhotos"];
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
