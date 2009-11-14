//
//  BlogListThumbsController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-12.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "BlogListThumbsController.h"
#import "BlogListThumbsDataSource.h"
#import "BlogListModel.h"
#import "ShowPictureController.h"

@implementation BlogListThumbsController

-(id)initWithArguments:(NSDictionary*)arguments
{
	self = [super init];
	
	self.title = NSLocalizedString(@"Thumb view", nil);
	_bmodel = [[[BlogListModel alloc] initWithArguments:arguments] autorelease];
	BlogListThumbsDataSource *ds = [[BlogListThumbsDataSource alloc] initWithModel:_bmodel];

	[self setPhotoSource:ds];
	self.model = [ds underlyingModel];
	
	self.navigationBarStyle = UIStatusBarStyleDefault;
	self.statusBarStyle = UIStatusBarStyleDefault;
	self.wantsFullScreenLayout = NO;
	self.hidesBottomBarWhenPushed = NO;
	
	self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Thumb view", nil) image:TTIMAGE(@"bundle://42-photos.png") tag:1];
	
	_firstAppear = YES;
	
	return self;
}

-(id)createPhotoViewController
{
	return [[[ShowPictureController alloc] init] autorelease];
}

-(void)updateTableLayout {
	self.tableView.contentInset = UIEdgeInsetsMake(4, 0, 0, 0);
	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)dealloc
{
	[super dealloc];
}

@end
