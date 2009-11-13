//
//  ProfileViewController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-13.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "ProfileViewController.h"

@implementation ProfileViewController

-(id)initWithUserName:(NSString*)userName
{
	self = [super init];
	_user = [[MBUser alloc] initWithUserName:userName];
	_user.delegate = self;
	
	self.variableHeightRows = YES;
	
	self.title = [NSString stringWithFormat:NSLocalizedString(@"Profile for %@", nil), _user.name];
	self.tableViewStyle = UITableViewStyleGrouped;
	
	_activity = [[TTActivityLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 416)
												 style:TTActivityLabelStyleBlackBox
												  text:NSLocalizedString(@"Loading...", nil)];
	
	return self;
}

-(void)viewDidLoad
{
	[self.view addSubview:_activity];
}

-(void)createModel
{
	_userImageItem = [TTTableImageItem itemWithText:_user.name];
	_userImageItem.imageURL = @"http://mobilblogg.nu/cache/ttf/011086f0e011367f52.gif";
	
	_userTextItem = [TTTableStyledTextItem itemWithText:nil];

	_userImageItem.imageStyle = [TTImageStyle styleWithImageURL:nil
												   defaultImage:TTIMAGE(@"usericon.png")
													contentMode:UIViewContentModeScaleAspectFill
														   size:CGSizeMake(100, 100) next:TTSTYLE(rounded)];

	self.dataSource = [TTListDataSource dataSourceWithObjects:
					   _userImageItem,
					   _userTextItem,
					   [TTTableControlItem itemWithCaption:NSLocalizedString(@"Follow",nil) control:[[UISwitch alloc] init]],
					   [TTTableTextItem itemWithText:NSLocalizedString(@"User photos",nil)
												 URL:[NSString stringWithFormat:@"mb://listblog/%@", _user.name]],
						nil];
					   
}

-(void)MBUserDidReceiveInfo:(MBUser *)user
{
	_userImageItem.imageURL = _user.avatarURL;
	_userTextItem.text = [TTStyledText textFromXHTML:_user.info];
	[self.tableView reloadData];
	[_activity removeFromSuperview];
}

-(void)MBUser:(MBUser *)user didFailWithError:(NSError *)err
{
	[_activity removeFromSuperview];
}

-(void)dealloc
{
	[_user release];
	[_activity release];
	[super dealloc];
}

@end
