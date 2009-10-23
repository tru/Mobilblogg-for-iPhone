//
//  BlogListController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "BlogListController.h"
#import "BlogListModel.h"


@implementation BlogListController

@synthesize name;
@synthesize mbapi;

-(id)initWithName:(NSString*)nameStr
{
	self = [super init];
	self.name = nameStr;
	self.title = [NSString stringWithFormat:@"Blog for %@", nameStr];
	self.variableHeightRows = YES;	
	return self;
}

-(void)createModel
{
	NSLog(@"Creating Model");
	
	TTSectionedDataSource *ds = [TTSectionedDataSource dataSourceWithArrays:nil];
	ds.model = [[BlogListModel alloc] initWithBloggName:self.name];
	self.dataSource = ds;
	
}

@end
