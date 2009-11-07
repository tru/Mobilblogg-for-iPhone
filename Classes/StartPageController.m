//
//  StartPageController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-06.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "StartPageController.h"
#import "BlogListModel.h"
#import "BlogListDataSource.h"

@implementation StartPageController

-(id)init
{
	self = [super init];
	self.title = NSLocalizedString (@"Start Page", nil);
	self.variableHeightRows = YES;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																						   target:self 
																						   action:@selector(refresh)];

	NSLog(@"Creating Model");
	
	id<TTTableViewDataSource> ds = [BlogListDataSource dataSourceWithItems:nil];
	ds.model = [[BlogListModel alloc] initWithFunction:@"listStartpage"];
	self.dataSource = ds;

	return self;
}

-(void)refresh
{
	NSLog(@"Refreshing");
	[self reload];
}


@end
