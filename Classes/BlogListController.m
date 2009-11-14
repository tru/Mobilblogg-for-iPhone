//
//  BlogListController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "BlogListController.h"
#import "BlogListModel.h"
#import "BlogListDataSource.h"
#import "MBPhoto.h"
#import "MBTablePhotoItem.h"
#import "ShowPictureController.h"
#import "BlogListThumbsDataSource.h"

@implementation BlogListController

-(id)initWithArguments:(NSDictionary*)arguments
{
	self = [super init];
	self.title = NSLocalizedString(@"List view", nil);
	self.variableHeightRows = YES;
	
	id<TTTableViewDataSource> ds = [BlogListDataSource dataSourceWithItems:nil];
	ds.model = [[[BlogListModel alloc] initWithArguments:arguments] autorelease];
	self.dataSource = ds;
	
	self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:TTIMAGE(@"bundle://41-picture-frame.png") tag:0];

	return self;
}

-(void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath
{
	NSLog(@"helo!");
	if ([object isKindOfClass:[MBTablePhotoItem class]]) {
		MBPhoto *photo = ((MBTablePhotoItem*)object).photo;
		ShowPictureController *ctrl = [[[ShowPictureController alloc] init] autorelease];
		photo.photoSource = [[[BlogListThumbsDataSource alloc] initWithModel:(BlogListModel*)self.dataSource.model] autorelease];
		ctrl.centerPhoto = photo;
		NSLog(@"centerPhoto = %d", photo.photoId);
		[self.navigationController pushViewController:ctrl animated:YES];
	} else {
		[super didSelectObject:object atIndexPath:indexPath];
	}
}

-(BOOL)shouldOpenURL:(NSString *)URL
{
	if ([URL isEqualToString:@"mb://foobar"]) {
		return NO;
	}
	
	return YES;
}

-(void)refresh
{
	NSLog(@"Refreshing");
	[self reload];
}

-(void)dealloc
{
	NSLog(@"DEALLOC: BlogListController");
	[super dealloc];
}

@end
