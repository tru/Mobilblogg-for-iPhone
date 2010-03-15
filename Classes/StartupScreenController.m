//
//  StartupScreenController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2010-03-01.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import "StartupScreenController.h"
#import "MBLogin.h"
#import "MBStore.h"
#import "MBGlobal.h"

@implementation StartupScreenController

-(void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:TT_FAST_TRANSITION_DURATION];
	_activity.alpha = 1.0;
	[UIView commitAnimations];
}

-(void)loadView
{
	[super loadView];
	
	TTImageView *imgView = [[TTImageView alloc] initWithFrame:self.view.bounds];
	imgView.urlPath = @"bundle://Default.png";
	self.view = imgView;
	
	_activity = [[TTActivityLabel alloc] initWithFrame:CGRectMake(0, 150, 320, 40) style:TTActivityLabelStyleGray];
	[self.view addSubview:_activity];
	_activity.text = NSLocalizedString(@"Initializing...", nil);
	_activity.alpha = 0.0;
	
}

-(void)viewDidLoad
{
	NSString *username, *password;
	
	username = [MBStore getUserName];
	password = [MBStore getPasswordForUsername:username];
	
	if (!username || !password) {
		TTURLAction *ac = [TTURLAction actionWithURLPath:@"mb://userconfmodal/yes"];
		[ac setParentURLPath:@"mb://root"];
		[ac applyAnimated:YES];
		[[TTNavigator navigator] openURLAction:ac];
	} else {
		_login = [[MBLogin alloc] initWithUsername:username andPassword:password];
		_login.delegate = self;
		[_login release];
	}

}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: StartupScreenController");
	[_activity release];
	[super dealloc];
}

#pragma mark login

-(void)loginDidSucceed
{
	[UIView beginAnimations:nil context:nil];
	[UIView	setAnimationDelay:TT_FLIP_TRANSITION_DURATION];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop)];
	self.view.alpha = 0.0;
	[UIView commitAnimations];
}

-(void)animationDidStop
{
	TTDINFO("Fade done!");
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	TTURLAction *ac = [TTURLAction actionWithURLPath:@"mb://root"];
	[ac setParentURLPath:nil];
	[ac applyAnimated:NO];
	[[TTNavigator navigator] openURLAction:ac];
}

-(void)loginDidFailWithError:(NSError *)err
{
	UIAlertView *alert;
	
	if ([[err domain] isEqualToString:MobilBloggErrorDomain] && [err code] == MobilBloggErrorCodeInvalidCredentials) {
		alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login failed", nil)
										   message:NSLocalizedString(@"Saved credentials are not valid", nil)
										  delegate:self
								 cancelButtonTitle:NSLocalizedString(@"Ok", nil)
								 otherButtonTitles:NSLocalizedString(@"Settings", nil),nil];
	} else {
		alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login failed", nil)
										   message:[err localizedDescription]
										  delegate:self
								 cancelButtonTitle:NSLocalizedString(@"Ok", nil)
								 otherButtonTitles:nil];

	}

	[alert show];
	[alert release];
}


@end
