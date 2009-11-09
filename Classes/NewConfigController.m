//
//  NewConfigController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-09.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "NewConfigController.h"
#import "MBStore.h"

@implementation NewConfigController


-(id)init
{
	self = [super init];
	
	self.title = NSLocalizedString(@"Settings", nil);
	self.tableViewStyle = UITableViewStyleGrouped;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
																						   target:self 
																						   action:@selector(saveSettings)];
	
	_activity = [[TTActivityLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 416)
												 style:TTActivityLabelStyleBlackBox
												  text:NSLocalizedString(@"Logging in", nil)];
	return self;
}

-(void)createModel
{
	_username = [[UITextField alloc] init];
	_password = [[UITextField alloc] init];
	
	_username.text = [MBStore getUserName];
	_password.text = [MBStore getPasswordForUsername:_username.text];
	
	_username.placeholder = NSLocalizedString(@"Username", nil);
	_username.clearButtonMode = UITextFieldViewModeWhileEditing;
	_username.keyboardType = UIKeyboardTypeEmailAddress;
	_username.autocorrectionType = UITextAutocorrectionTypeNo;
	_username.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_username.returnKeyType	= UIReturnKeyNext;
	_username.delegate = self;
	
	_password.placeholder = NSLocalizedString(@"Password", nil);
	_password.clearButtonMode = UITextFieldViewModeWhileEditing;
	_password.secureTextEntry = YES;
	_password.autocorrectionType = UITextAutocorrectionTypeNo;
	_password.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_password.returnKeyType = UIReturnKeyDone;
	_username.delegate = self;
	
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
					   NSLocalizedString(@"Username", nil),
					   _username,
					   NSLocalizedString(@"Password", nil),
					   _password,
					   nil];
}

-(BOOL)textFieldShouldReturn:(UITextField*)field
{
	if (field == _username) {
		[_username resignFirstResponder];
		[_password becomeFirstResponder];
	} else if (field == _password) {
		[_password resignFirstResponder];
	}
	return YES;
}


-(void)saveSettings
{
	NSLog(@"username = %@ and password = %@", _username.text, _password.text);
	MBLogin *login = [MBLogin loginWithUsername:_username.text andPassword:_password.text];
	login.delegate = self;
	[[self view] addSubview:_activity];
	[_username resignFirstResponder];
	[_password resignFirstResponder];
}

-(void)loginDidSucceed
{
	[MBStore saveUserName:_username.text];
	[MBStore savePassword:_password.text forUsername:_username.text];
	
	[self dismissModalViewControllerAnimated:YES];
}

-(void)loginDidFailWithError:(NSError *)err
{
	[_activity removeFromSuperview];

	UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"Login Failed"
												   message:[err localizedDescription]
												  delegate:self
										 cancelButtonTitle:[[err localizedRecoveryOptions] objectAtIndex:0]
										 otherButtonTitles:nil];
	[alview show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
}

-(void)dealloc
{
	[_activity release];
	[_password release];
	[_username release];
	[super dealloc];
}

@end
