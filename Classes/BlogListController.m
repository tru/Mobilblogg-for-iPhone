//
//  BlogListController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "BlogListController.h"


@implementation BlogListController

@synthesize name;
@synthesize mbapi;

-(id)initWithName:(NSString*)nameStr
{
	self = [super init];
	self.name = nameStr;
	self.title = [NSString stringWithFormat:@"Blog for %@", nameStr];
	//self.tableViewStyle = UITableViewStyleGrouped;
	self.variableHeightRows = YES;
/*	self.mbapi = [[MBAPI alloc] initWithDelegate:self];
	
	[mbapi listBlogg:nameStr delegate:self andSelector:@selector(gotBloggList:)];*/
	
	return self;
}

-(void)gotBloggList:(NSArray*)list
{
	NSLog(@"We are here!");

	UIImage *localImage = TTIMAGE(@"bundle://photoDefault.png");
	TTTableSubtitleItem *item = [TTTableSubtitleItem itemWithText:@"Blah blah blah"
														 subtitle:@"huuusedusted uetdues"
														 imageURL:@"http://www.mobilblogg.nu/cache/ttf/0eeb22fb80eeb0b738.jpg"
													 defaultImage:localImage
															  URL:@"mb://picture/1"
													 accessoryURL:nil];

	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
					   @"Today",
					   item,
					   item,
					   item,
					   item,
					   nil
					   ];

}

-(void)createModel
{
	[self gotBloggList:nil];
}

@end
