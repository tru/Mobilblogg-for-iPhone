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


@implementation BlogListController

@synthesize name;

-(id)initWithName:(NSString*)nameStr
{
	self = [super init];
	self.name = nameStr;
	self.title = [NSString stringWithFormat:@"Blog for %@", nameStr];
	self.variableHeightRows = YES;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																						   target:self 
																						   action:@selector(refresh)];

	NSLog(@"Creating Model");
	
	id<TTTableViewDataSource> ds = [BlogListDataSource dataSourceWithItems:nil];
	ds.model = [[BlogListModel alloc] initWithBloggName:self.name];
	self.dataSource = ds;

	return self;
}

-(void)refresh
{
	NSLog(@"Refreshing");
	[self reload];
}

@end
