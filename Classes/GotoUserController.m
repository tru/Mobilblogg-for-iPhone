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


/* Subclass of UITextField to be able to set the rightitemrect
 * to something sane */
@implementation GotoUserTextField

-(id)init
{
	self = [super init];
	self.placeholder = NSLocalizedString(@"Username", nil);
	self.keyboardType = UIKeyboardTypeEmailAddress;
	self.autocorrectionType = UITextAutocorrectionTypeNo;
	self.autocapitalizationType = UITextAutocapitalizationTypeNone;
	
	UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//	activity.hidesWhenStopped = NO;
	
	self.rightView = activity;
	self.rightViewMode = UITextFieldViewModeAlways;
	self.returnKeyType = UIReturnKeySearch;

	return self;
}

/* We want to offset that UIActivityIndicatorView otherwise it looks
 * like shit */
-(CGRect)rightViewRectForBounds:(CGRect)bounds
{
	CGRect r = [super rightViewRectForBounds:bounds];
	return CGRectOffset(r, -10, 0);
}

@end


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
	
	self.tableViewStyle = UITableViewStyleGrouped;
	_users = [[NSMutableDictionary alloc] init];
	
	_username = [[GotoUserTextField alloc] init];
	_username.delegate = self;
	
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
	[((UIActivityIndicatorView*)_username.rightView) startAnimating];
	[_username resignFirstResponder];
	MBUser *user = [[[MBUser alloc] initWithUserName:_username.text] autorelease];
	user.delegate = self;
}

-(void)MBUserDidReceiveInfo:(MBUser *)user
{
	[((UIActivityIndicatorView*)_username.rightView) stopAnimating];
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

	[((UIActivityIndicatorView*)_username.rightView) stopAnimating];
	
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
