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
#import "MBPush.h"
#import "DebugLogView.h"
#import "UploaderViewController.h"
#import "StartupScreenController.h"

@implementation MobilBloggStyleSheet

-(UIColor*)navigationBarTintColor
{
	return [UIColor mbColor];
}

@end



@implementation MobilBloggAppDelegate

BOOL gLogging = FALSE;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	application.applicationIconBadgeNumber = 0;
	
	[[TTURLRequestQueue mainQueue] setMaxContentLength:0];
	//[[TTURLCache sharedCache] setMaxPixelCount:20*320*480];
	
	TTNavigator *ttnav = [TTNavigator navigator];
//	ttnav.persistenceMode = TTNavigatorPersistenceModeTop;
	
	TTURLMap *URLMap = ttnav.URLMap;
	[URLMap from:@"*" toViewController:[TTWebController class]];
	[URLMap from:@"mb://startup" toViewController:[StartupScreenController class]];
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
	[URLMap from:@"mb://debuglog" toViewController:[DebugLogView class]];
	[URLMap from:@"mb://upload" toViewController:[UploaderViewController class]];

	[TTStyleSheet setGlobalStyleSheet:[[[MobilBloggStyleSheet alloc] init] autorelease]];
	
	if ([MBStore getBoolForKey:@"debugLog"]) {
		[ConfigurationController redirectConsoleLogToDocumentFolder];
	}
	
	[ttnav openURLAction:[TTURLAction actionWithURLPath:@"mb://startup"]];

	//[application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert];	
}


#pragma mark APNS

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	NSMutableString *token = [[NSMutableString alloc] init];
    const unsigned char *devTokenBytes = [deviceToken bytes];
	for (int i = 0; i < [deviceToken length]; i++)
		[token appendFormat:@"%02X", devTokenBytes[i]];
	TTDINFO("Registered with APNS! device token: %@", token);
	NSString *username = [MBStore getUserName];
	[[MBPush alloc] initWithUsername:username andToken:token];
	
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

#pragma mark -

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
	return YES;
}

- (void)dealloc {
    [super dealloc];
}

@end
