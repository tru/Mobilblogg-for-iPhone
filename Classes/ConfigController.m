//
//  ConfigController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "ConfigController.h"
#import "MBStore.h"
#import <Three20/Three20.h>
#import "GTMNSDictionary+URLArguments.h"
#import "JSON.h"
#import "MBLogin.h"


@implementation ConfigController

@synthesize username;
@synthesize password;
@synthesize activity = _activity;

- (id)init
{
	self = [super initWithNibName:@"ConfigController" bundle:[NSBundle mainBundle]];
	self.title = NSLocalizedString(@"Configuration", nil),
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
											 initWithTitle:NSLocalizedString(@"Cancel", nil)
											 style:UIBarButtonItemStyleBordered 
											 target:self action:@selector(dismiss)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
											 initWithTitle:NSLocalizedString(@"Save", nil)
											 style:UIBarButtonItemStyleDone
											 target:self action:@selector(save)];

	self.navigationItem.leftBarButtonItem.enabled = NO;
	
	if ([MBStore getUserName] && [MBStore getPasswordForUsername:[MBStore getUserName]]) {
		self.navigationItem.leftBarButtonItem.enabled = YES;
	}

	
	return self;
}

- (void)viewDidLoad
{
	NSString *uname = [MBStore getUserName];
	NSLog(@"uname = %@", uname);
	if (uname) {
		[username setText:uname];
	}

}

- (void)dismiss
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc
{
	[username release];
	[password release];
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
	if (textField == username) {
		[username resignFirstResponder];
		[password becomeFirstResponder];
	} else if (textField == password) {
		[password resignFirstResponder];
	}
	return TRUE;
}

- (void)save
{
	MBLogin *login = [MBLogin loginWithUsername:username.text andPassword:password.text];
	login.delegate = self;
}

-(void)loginDidFailWithError:(NSError *)err
{
	UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Login Failed"
												   message:[err localizedDescription]
												  delegate:self
										 cancelButtonTitle:[[err localizedRecoveryOptions] objectAtIndex:0]
										 otherButtonTitles:nil];
	[view show];
}

-(void)loginDidSucceed
{
	[MBStore saveUserName:username.text];
	[MBStore savePassword:password.text forUsername:username.text];
	
	[self dismissModalViewControllerAnimated:YES];
}
	
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[_activity stopAnimating];
}

@end
