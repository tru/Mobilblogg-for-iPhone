//
//  GotoUser.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-09.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "GotoUserController.h"
#import "MBStore.h"
#import "FavoritesDataSource.h"
#import "MBErrorCodes.h"

@implementation GotoUserController

-(id)init
{
	self = [super init];
	self.title = NSLocalizedString(@"Goto user", nil);
	self.variableHeightRows = YES;
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Go", nil)
																			   style:UIBarButtonItemStyleDone
																			  target:self
																			  action:@selector(lookupUser)] autorelease];
	
/*	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						   target:self
																						   action:@selector(closeView)] autorelease];*/
	self.tableViewStyle = UITableViewStyleGrouped;
	_users = [[NSMutableDictionary alloc] init];
	
	_username = [[UITextField alloc] init];
	_username.placeholder = NSLocalizedString(@"Username", nil);
	_username.keyboardType = UIKeyboardTypeEmailAddress;
	_username.autocorrectionType = UITextAutocorrectionTypeNo;
	_username.autocapitalizationType = UITextAutocapitalizationTypeNone;
	
	UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//	activity.hidesWhenStopped = NO;
	
	_username.leftView = activity;
	_username.leftViewMode = UITextFieldViewModeAlways;
	_username.delegate = self;
	_username.returnKeyType = UIReturnKeySearch;
	
	self.dataSource = [[FavoritesDataSource alloc] initWithInputField:_username andDelegate:self];
	

	return self;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	return _shouldEnd;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self lookupUser];
	return NO;
}
	
-(void)lookupUser {
	NSLog(@"Lookup user");
	[((UIActivityIndicatorView*)_username.leftView) startAnimating];
	[_username resignFirstResponder];
	MBUser *user = [[MBUser alloc] initWithUserName:_username.text];
	user.delegate = self;
}

-(void)MBUserDidReceiveInfo:(MBUser *)user
{
	[((UIActivityIndicatorView*)_username.leftView) stopAnimating];
	self.navigationItem.rightBarButtonItem.enabled = YES;
	[_username resignFirstResponder];
	_shouldEnd = YES;
	[self gotoUser];
}

-(void)MBUser:(MBUser *)user didFailWithError:(NSError *)err
{
	if ([err domain] == MobilBloggErrorDomain && [err code] == MobilBloggErrorCodeNoSuchUser) {
		/* FIXME: Feedback? */
	} else if ([err domain] == @"org.brautaset.JSON.ErrorDomain") {
		/* This means parse error, let's treat it as a real user for now */
		[self MBUserDidReceiveInfo:user];
	}

	[((UIActivityIndicatorView*)_username.leftView) stopAnimating];
	
	_shouldEnd = NO;
}

-(void)dataSourceUpdate
{
	NSLog(@"Reloading data");
	[self.tableView reloadData];
}

-(void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
	if ([object isKindOfClass:[TTTableImageItem class]]) {
		[((FavoritesDataSource*)self.dataSource) goUser:((TTTableImageItem*)object).text];
	}
}

-(void)gotoUser
{	
	[((FavoritesDataSource*)self.dataSource) goUser:_username.text];
	
	[_username resignFirstResponder];
	[[TTNavigator navigator] openURL:[NSString stringWithFormat:@"mb://profile/%@", _username.text] animated:YES];
	_username.text = nil;

}


@end
