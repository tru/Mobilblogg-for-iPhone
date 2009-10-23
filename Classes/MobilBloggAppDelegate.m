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
#import "BlogListController.h"

@implementation MobilBloggAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	TTNavigator *ttnav = [TTNavigator navigator];
	TTURLMap *URLMap = ttnav.URLMap;
	[URLMap from:@"mb://root" toViewController:[RootController class]];
	[URLMap from:@"mb://configure" toModalViewController:[ConfigController class]];
	[URLMap from:@"mb://listblog/(initWithName:)" toViewController:[BlogListController class]];
/*	[URLMap from:@"mb://gotouser" toViewController:[SearchController class]];*/
	
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
