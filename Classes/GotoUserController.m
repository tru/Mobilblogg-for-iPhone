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
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Go", nil)
																			   style:UIBarButtonItemStyleDone
																			  target:self
																			  action:@selector(gotoUser)] autorelease];
	
/*	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						   target:self
																						   action:@selector(closeView)] autorelease];*/
	self.tableViewStyle = UITableViewStyleGrouped;
	return self;
}


-(void)rehashDataSource
{
	NSMutableArray *itemsToSource = [[NSMutableArray alloc] init];	
	NSArray *previousUsers = [MBStore getObjectForKey:@"previousGotoUsers"];
	for (NSString *user in previousUsers) {
		TTTableTextItem *item = [TTTableTextItem itemWithText:user URL:[NSString stringWithFormat:@"mb://listblog/%@", user]];
		[itemsToSource addObject:item];
	}
	
	self.dataSource = [TTSectionedDataSource dataSourceWithArrays:@"Goto user", 
					   [NSArray arrayWithObject:_username],
					   @"Previous users",
					   itemsToSource,
					   nil];
	
	[itemsToSource release];
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
