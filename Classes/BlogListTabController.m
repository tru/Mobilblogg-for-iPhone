//
//  BlogListTabController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-11.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "BlogListTabController.h"
#import "BlogListController.h"
#import "MBStore.h"

@implementation BlogListTabController

-(id)initWithBloggName:(NSString*)bloggName
{
	NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
							   bloggName, @"user",
							   @"listBlogg", @"func",
							   nil];
	
	self.title = [NSString stringWithFormat:NSLocalizedString(@"Photos by %@", nil), bloggName];
	
	return [self initWithArguments:arguments];
}

-(id)initWithFunction:(NSString*)functionName
{
	NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
							   functionName, @"func",
							   nil];
	
	if ([functionName isEqualToString:@"listFirstpage"]) {
		self.title = NSLocalizedString(@"First Page", nil);
	} else if ([functionName isEqualToString:@"listStartpage"]) {
		self.title = NSLocalizedString(@"My Start Page", nil);
	}
	
	return [self initWithArguments:arguments];
}

-(id)initWithArguments:(NSDictionary*)arguments
{
	TTDINFO(@"Init of BlogListTabController");
	self = [super init];
	_pool = [[NSAutoreleasePool alloc] init];
	_list = [[BlogListController alloc] initWithArguments:arguments];
	_photos = [[BlogListThumbsController alloc] initWithArguments:arguments];
	self.delegate = self;
	
	[self setViewControllers:[NSArray arrayWithObjects:
							  _list,
							  _photos,
							  nil]];
	
	NSUInteger activeTag = 0;
	NSNumber *tag = [MBStore getObjectForKey:@"activeTabView"];
	if (tag) {
		activeTag = [tag intValue];
	}
	
	self.selectedIndex = activeTag;
		
	return self;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	[MBStore setObject:[NSNumber numberWithInt:self.selectedIndex] forKey:@"activeTabView"];
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: BlogListTabController shutting down");
	[_list release];
	[_photos release];
	[_pool drain];
	[_pool release];
	[super dealloc];
}

@end
