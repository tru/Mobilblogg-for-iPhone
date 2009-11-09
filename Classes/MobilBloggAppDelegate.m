//
//  MobilBloggAppDelegate.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright Purple Scout 2009. All rights reserved.
//

#import "MobilBloggAppDelegate.h"
#import <Three20/Three20.h>

#import "ConfigController.h"
#import "NewConfigController.h"
#import "BlogListController.h"
#import "ShowPictureController.h"
#import "SearchUserViewController.h"
#import "CommentViewController.h"
#import "FirstPageController.h"
#import "StartPageController.h"

@implementation MobilBloggAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	TTNavigator *ttnav = [TTNavigator navigator];
	TTURLMap *URLMap = ttnav.URLMap;
	[URLMap from:@"mb://root" toViewController:[RootController class]];
	[URLMap from:@"mb://configure" toModalViewController:[NewConfigController class]];
	[URLMap from:@"mb://listblog/(initWithName:)" toViewController:[BlogListController class]];
	[URLMap	from:@"mb://picture/(initWithId:)" toViewController:[ShowPictureController class]];
	[URLMap from:@"mb://searchuser" toViewController:[SearchUserViewController class]];
	[URLMap from:@"mb://comments/(initWithId:)" toViewController:[CommentViewController class]
													  transition:UIViewAnimationTransitionFlipFromLeft];
	[URLMap	from:@"mb://firstpage" toViewController:[FirstPageController class]];
	[URLMap from:@"mb://mystartpage" toViewController:[StartPageController class]];
	
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
