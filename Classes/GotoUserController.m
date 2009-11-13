//
//  GotoUser.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-09.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "GotoUserController.h"
#import "MBStore.h"

@implementation GotoUserController

-(id)init
{
	self = [super init];
	self.title = NSLocalizedString(@"Goto user", nil);
	self.variableHeightRows = YES;
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Go", nil)
																			   style:UIBarButtonItemStyleDone
																			  target:self
																			  action:@selector(gotoUser)] autorelease];
	
/*	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						   target:self
																						   action:@selector(closeView)] autorelease];*/
	self.tableViewStyle = UITableViewStyleGrouped;
	_users = [[NSMutableDictionary alloc] init];
	return self;
}


-(void)rehashDataSource
{
	NSMutableArray *itemsToSource = [[NSMutableArray alloc] init];	
	NSArray *previousUsers = [MBStore getObjectForKey:@"previousGotoUsers"];
	TTImageStyle *style = [TTImageStyle styleWithImageURL:nil
											 defaultImage:nil
											  contentMode:UIViewContentModeScaleAspectFill
													 size:CGSizeMake(40, 40)
													 next:TTSTYLE(rounded)];
	for (NSString *user in previousUsers) {
		TTTableImageItem *item = [TTTableImageItem itemWithText:user];
		item.imageStyle = style;
		item.imageURL = @"http://mobilblogg.nu/cache/ttf/011086f0e011367f52.gif";
		item.URL =  [NSString stringWithFormat:@"mb://profile/%@", user];
		[itemsToSource addObject:item];
		[_users setObject:item forKey:user];
		MBUser *mbuser = [[[MBUser alloc] initWithUserName:user] autorelease];
		mbuser.delegate = self;
	}
	
	self.dataSource = [TTSectionedDataSource dataSourceWithArrays:@"Goto user", 
					   [NSArray arrayWithObject:_username],
					   @"Previous users",
					   itemsToSource,
					   nil];
	
	[itemsToSource release];
}

-(void)MBUserDidReceiveInfo:(MBUser *)user
{
	TTTableImageItem *item = [_users objectForKey:user.name];
	if (item) {
		item.imageURL = user.avatarURL;
	}
	[self.tableView reloadData];
}

-(void)MBUser:(MBUser*)user didFailWithError:(NSError*)err
{
	TTTableImageItem *item = [_users objectForKey:user.name];
	if (item) {
		item.imageURL = @"http://mobilblogg.nu/cache/ttf/011086f0e011367f52.gif";
	}
	[self.tableView reloadData];

}

-(void)createModel
{
	
	_username = [[UITextField alloc] init];
	_username.placeholder = NSLocalizedString(@"Username", nil);
	_username.keyboardType = UIKeyboardTypeEmailAddress;
	_username.autocorrectionType = UITextAutocorrectionTypeNo;
	_username.autocapitalizationType = UITextAutocapitalizationTypeNone;
	
	[self rehashDataSource];
	
}


-(void)gotoUser
{
	NSMutableArray *previousUsers = [NSMutableArray arrayWithArray:[MBStore getObjectForKey:@"previousGotoUsers"]];
	if (![previousUsers containsObject:_username.text]) {
		[previousUsers addObject:_username.text];
	}
	[MBStore setObject:previousUsers forKey:@"previousGotoUsers"];
	
	[_username resignFirstResponder];
	
	[[TTNavigator navigator] openURL:[NSString stringWithFormat:@"mb://listblog/%@",_username.text] animated:YES];
	_username.text = nil;

	[self rehashDataSource];
}

@end
