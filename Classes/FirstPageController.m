//
//  FirstPageController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-26.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "FirstPageController.h"
#import "BlogListModel.h"
#import "BlogListDataSource.h"

@implementation FirstPageController

-(id)init
{
	self = [super init];
	self.title = NSLocalizedString (@"First Page", nil);
	self.variableHeightRows = YES;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																						   target:self 
																						   action:@selector(refresh)];

	NSLog(@"Creating Model");
	
	id<TTTableViewDataSource> ds = [BlogListDataSource dataSourceWithItems:nil];
	ds.model = [[BlogListModel alloc] initWithFunction:@"listFirstpage"];
	self.dataSource = ds;

	return self;
}

-(void)refresh
{
	NSLog(@"Refreshing");
	[self reload];
}

@end
