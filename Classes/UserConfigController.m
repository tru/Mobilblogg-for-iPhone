//
//  NewConfigController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-09.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "UserConfigController.h"
#import "MBStore.h"

@implementation UserConfigController

-(id)initWithDidFail:(NSString*)didFail
{
	self = [super init];
	
	self.title = NSLocalizedString(@"Settings", nil);
	self.tableViewStyle = UITableViewStyleGrouped;
		
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
																						   target:self 
																						   action:@selector(saveSettings)];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						  target:self
																						  action:@selector(cancelSettings)];
	
	if ([didFail isEqualToString:@"yes"]) {
		self.navigationItem.leftBarButtonItem.enabled = NO;
	}
	
	_activity = [[TTActivityLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 480)
												 style:TTActivityLabelStyleBlackBox
												  text:NSLocalizedString(@"Logging in...", nil)];
	
	[[TTNavigator navigator].URLMap	from:@"mb://_cleardata" toViewController:self selector:@selector(clearData)];
	[[TTNavigator navigator].URLMap	from:@"mb://_clearpassword" toViewController:self selector:@selector(clearPassword)];
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
	
	_alwaysShowCaptionSwitch = [[[UISwitch alloc] init] autorelease];
	
	if ([MBStore getBoolForKey:@"hideCaptions"]) {
		_alwaysShowCaptionSwitch.on = NO;
	} else {
		_alwaysShowCaptionSwitch.on = YES;
	}
	[_alwaysShowCaptionSwitch addTarget:self action:@selector(switchAlwaysShowCaption) forControlEvents:UIControlEventValueChanged];
	TTTableControlItem *alwaysShowCaption = [TTTableControlItem itemWithCaption:NSLocalizedString(@"Always show caption", nil)
																		control:_alwaysShowCaptionSwitch];
	
		
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
					   NSLocalizedString(@"Credentials", nil),
					   _username,
					   _password,
					   NSLocalizedString(@"Interface", nil),
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

-(void)clearData
{
	NSLog(@"Removing stored data");
	[MBStore removeAllData];
	[self dismissModalViewController];
}

-(void)clearPassword
{
	NSLog(@"Removing stored password");
	[MBStore removePassword];
	[self dismissModalViewController];
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

-(void)cancelSettings
{
	[self dismissModalViewController];
}


-(void)saveSettings
{
	NSLog(@"username = %@ and password = %@", _username.text, _password.text);
	MBLogin *login = [[[MBLogin alloc] initWithUsername:_username.text andPassword:_password.text] autorelease];
	login.delegate = self;
	[self.navigationController.view addSubview:_activity];
	[_username resignFirstResponder];
	[_password resignFirstResponder];
}

-(void)loginDidSucceed
{
	[MBStore saveUserName:_username.text];
	[MBStore savePassword:_password.text forUsername:_username.text];
		
	[_activity removeFromSuperview];
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
	[alview release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
}

-(void)dealloc
{
	[[TTNavigator navigator].URLMap	removeURL:@"mb://_cleardata"];
	[_activity release];
	[_password release];
	[_username release];
	[super dealloc];
}

@end
