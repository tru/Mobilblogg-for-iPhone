//
//  ShowPictureInfoController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-09.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "ShowPictureInfoController.h"


@implementation ShowPictureInfoController

-(id)initWithNavigatorURL:(NSURL*)url query:(NSDictionary*)query
{
	self = [super init];
	_photo = [query objectForKey:@"photo"];
	[_photo retain];
	self.title = _photo.caption;
	self.variableHeightRows = YES;
	self.tableViewStyle = UITableViewStyleGrouped;
	
	MBUser *user = [[MBUser alloc] initWithUserName:_photo.user];
	user.delegate = self;
	
	return self;
}

-(void)createModel
{
	_userItem = [TTTableImageItem itemWithText:_photo.user];
	
	_userItem.imageStyle = [TTImageStyle styleWithImageURL:nil
											  defaultImage:TTIMAGE(@"bundle://Three20.bundle/images/empty.png")
											   contentMode:UIViewContentModeScaleAspectFill
													  size:CGSizeMake(80, 80) next:TTSTYLE(rounded)];
	
	TTTableImageItem *image = [TTTableImageItem itemWithText:_photo.caption];
	image.imageURL = _photo.URL;
	image.imageStyle = [TTImageStyle styleWithImageURL:nil
										  defaultImage:TTIMAGE(@"bundle://Three20.bundle/images/empty.png")
										   contentMode:UIViewContentModeScaleAspectFill
												  size:CGSizeMake(80, 80) next:TTSTYLE(rounded)];
	
	/*FIXME, don't die here */
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
					   @"Photo",
					   image,
					   [TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:@"Lång brödtext om vad bilden kanske innehåller, eller bara något annat. Svårt att veta. Innehåller dessutom <br><br>radbryt<br><br> och kanske <b>HTML</b>"]],
					   [TTTableLongTextItem itemWithText:@"Showed 10 times"],
					   @"Author",
					   _userItem,
					   [TTTableTextItem itemWithText:@"User photos" URL:[NSString stringWithFormat:@"mb://listblog/%@", _photo.user]],
					   [TTTableTextItem itemWithText:@"User profile" URL:[NSString stringWithFormat:@"mb://profile/%@", _photo.user]],
					   nil];
}

-(void)MBUserDidReceiveInfo:(MBUser *)user
{
	NSLog(@"User info! %@", user.avatarURL);
	_userItem.imageURL = user.avatarURL;
	[self.tableView reloadData];
}

-(void)MBUser:(MBUser *)user didFailWithError:(NSError *)err
{
	NSLog(@"MBUser fail!");
}

-(void)dealloc
{
	NSLog(@"DEALLOC: ShowPictureInfoController");
	[_photo release];
	[super dealloc];
}

@end
