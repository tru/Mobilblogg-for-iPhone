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


@implementation ConfigController

@synthesize username;
@synthesize password;

- (id)init
{
	self = [super initWithNibName:@"ConfigController" bundle:[NSBundle mainBundle]];
	self.title = @"Configuration";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
											 initWithTitle:@"Cancel" 
											 style:UIBarButtonItemStyleBordered 
											 target:self action:@selector(dismiss)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
											 initWithTitle:@"Save" 
											 style:UIBarButtonItemStyleDone
											 target:self action:@selector(save)];

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
	[MBStore saveUserName:username.text];
	[self dismissModalViewControllerAnimated:YES];
}


@end
