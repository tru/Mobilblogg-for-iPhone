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
											  defaultImage:nil
											   contentMode:UIViewContentModeScaleAspectFill
													  size:CGSizeMake(80, 80) next:TTSTYLE(rounded)];
	/*FIXME, don't die here */
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
					   @"Photo",
					   [TTTableImageItem itemWithText:_photo.caption imageURL:_photo.thumbURL defaultImage:TTIMAGE(@"bundle://Three20.bundle/images/empty.png") URL:nil],
					   [TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:@"Lång brödtext om vad bilden kanske innehåller, eller bara något annat. Svårt att veta. Innehåller dessutom <br><br>radbryt<br><br> och kanske <b>HTML</b>"]],
					   [TTTableLongTextItem itemWithText:@"Showed 10 times"],
					   @"Author",
					   _userItem,
					   [TTTableTextItem itemWithText:@"User photos"],
					   [TTTableTextItem itemWithText:@"User profile"],
					   @"Comments",
					   [TTTableMessageItem itemWithTitle:@"Cat" 
												 caption:nil 
													text:@"hahahahah ser rolig ut faktiskt!" 
											   timestamp:[NSDate dateWithToday]
												imageURL:@"http://mobilblogg.nu/cache/ttf/0eeb25b3f0eea52214.jpg"
													 URL:nil],
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
	[super dealloc];
}

@end
