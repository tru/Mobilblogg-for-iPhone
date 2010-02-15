//
//  MobilBloggAppDelegate.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright Purple Scout 2009. All rights reserved.
//

#import "MobilBloggAppDelegate.h"
#import <Three20/Three20.h>

#import "UserConfigController.h"
#import "ShowPictureController.h"
#import "CommentViewController.h"
#import "GotoUserController.h"
#import "AboutController.h"
#import "ShowPictureInfoController.h"
#import "BlogListTabController.h"
#import "ProfileViewController.h"
#import "ConfigurationController.h"
#import "MBLogin.h"
#import "MBGlobal.h"
#import "MBStore.h"

@implementation MobilBloggAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	application.applicationIconBadgeNumber = 0;
	
	[[TTURLRequestQueue mainQueue] setMaxContentLength:0];
	//[[TTURLCache sharedCache] setMaxPixelCount:20*320*480];
	
	TTNavigator *ttnav = [TTNavigator navigator];
//	ttnav.persistenceMode = TTNavigatorPersistenceModeTop;
	
	TTURLMap *URLMap = ttnav.URLMap;
	[URLMap from:@"*" toViewController:[TTWebController class]];
	[URLMap from:@"mb://root" toViewController:[RootController class]];
	[URLMap from:@"mb://configuration" toViewController:[ConfigurationController class]];
	/* we want to open it from the root as a modal controller, and some times from the
	 configure class as a normal class */
	[URLMap from:@"mb://userconfmodal/(initWithDidFail:)" toModalViewController:[UserConfigController class]];
	[URLMap from:@"mb://userconf/(initWithDidFail:)" toViewController:[UserConfigController class]];
	
	[URLMap from:@"mb://listblog/(initWithBloggName:)" toViewController:[BlogListTabController class]];
	[URLMap	from:@"mb://picture?" toViewController:[ShowPictureController class]];
	[URLMap from:@"mb://comments/(initWithId:)" toViewController:[CommentViewController class]
													  transition:UIViewAnimationTransitionFlipFromLeft];
	[URLMap	from:@"mb://listfunction/(initWithFunction:)" toViewController:[BlogListTabController class]];
	[URLMap from:@"mb://gotouser" toViewController:[GotoUserController class]];
	[URLMap	from:@"mb://about" toViewController:[AboutController class]];
	[URLMap from:@"mb://photoinfo" toViewController:[ShowPictureInfoController class]
									     transition:UIViewAnimationTransitionFlipFromLeft];
	[URLMap from:@"mb://profile/(initWithUserName:)" toViewController:[ProfileViewController class]];
	
	NSString *username, *password;
	
	username = [MBStore getUserName];
	password = [MBStore getPasswordForUsername:username];
	
	if (!username || !password) {
		[ttnav openURL:@"mb://userconfmodal/yes" parent:@"mb://root" animated:NO];
	} else {
		MBLogin *login = [[[MBLogin alloc] initWithUsername:username andPassword:password] autorelease];
		login.delegate = self;
		
		//if (![ttnav restoreViewControllers]) {
			[ttnav openURL:@"mb://root" animated:NO];
		//}		
	}

	[application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert];	
}

#pragma mark login

-(void)loginDidSucceed
{
	TTDINFO("yay");
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

#pragma mark APNS

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	NSMutableString *token = [[NSMutableString alloc] init];
    const unsigned char *devTokenBytes = [deviceToken bytes];
	for (int i = 0; i < [deviceToken length]; i++)
		[token appendFormat:@"%02X", devTokenBytes[i]];
	TTDINFO("Registered with APNS! device token: %@", token);
	
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	if ([error code] == 3010) {
		/* we are in the simulator, let's just ignore the error */
		return;
	}
	
	/* genuine error, let's display it to the user */
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to register with Push notification", nil)
													message:[error localizedDescription]
												   delegate:nil
										  cancelButtonTitle:NSLocalizedString(@"Ok", nil)
										  otherButtonTitles:nil];
	
	[alert show];
}

#pragma mark app

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	[[TTNavigator navigator] openURL:URL.absoluteString animated:NO];
	return YES;
}

- (void)dealloc {
    [super dealloc];
}

@end
