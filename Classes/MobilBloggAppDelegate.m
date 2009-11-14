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
#import "SearchUserViewController.h"
#import "CommentViewController.h"
#import "GotoUserController.h"
#import "AboutController.h"
#import "ShowPictureInfoController.h"
#import "BlogListTabController.h"
#import "ProfileViewController.h"

@implementation MobilBloggAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	[[TTURLRequestQueue mainQueue] setMaxContentLength:0];
	//[[TTURLCache sharedCache] setMaxPixelCount:20*320*480];
	
	TTNavigator *ttnav = [TTNavigator navigator];
	TTURLMap *URLMap = ttnav.URLMap;
	[URLMap from:@"*" toViewController:[TTWebController class]];
	[URLMap from:@"mb://root" toViewController:[RootController class]];
	/* we want to open it from the root as a modal controller, and some times from the
	 configure class as a normal class */
	[URLMap from:@"mb://userconfmodal/(initWithDidFail:)" toModalViewController:[UserConfigController class]];
	[URLMap from:@"mb://userconf/(initWithDidFail:)" toViewController:[UserConfigController class]];
	
	[URLMap from:@"mb://listblog/(initWithBloggName:)" toViewController:[BlogListTabController class]];
	[URLMap	from:@"mb://picture?" toViewController:[ShowPictureController class]];
	[URLMap from:@"mb://searchuser" toViewController:[SearchUserViewController class]];
	[URLMap from:@"mb://comments/(initWithId:)" toViewController:[CommentViewController class]
													  transition:UIViewAnimationTransitionFlipFromLeft];
	[URLMap	from:@"mb://listfunction/(initWithFunction:)" toViewController:[BlogListTabController class]];
	[URLMap from:@"mb://gotouser" toViewController:[GotoUserController class]];
	[URLMap	from:@"mb://about" toViewController:[AboutController class]];
	[URLMap from:@"mb://photoinfo" toViewController:[ShowPictureInfoController class]
									     transition:UIViewAnimationTransitionFlipFromLeft];
	[URLMap from:@"mb://profile/(initWithUserName:)" toViewController:[ProfileViewController class]];
	
	if (![ttnav restoreViewControllers]) {
		[ttnav openURL:@"mb://root" animated:NO];
	}
	
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	[[TTNavigator navigator] openURL:URL.absoluteString animated:NO];
	return YES;
}

- (void)dealloc {
    [super dealloc];
}

@end
