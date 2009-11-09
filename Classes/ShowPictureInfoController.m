//
//  ShowPictureInfoController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-09.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "ShowPictureInfoController.h"


@implementation ShowPictureInfoController

-(id)initWithNavigatorURL:(NSURL*)url query:(NSDictionary*)query
{
	self = [super init];
	_photo = [query objectForKey:@"photo"];
	self.variableHeightRows = YES;
	return self;
}

-(void)createModel
{
	/*FIXME, don't die here */
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
					   @"Author",
					   [TTTableTextItem itemWithText:_photo.user URL:[NSString stringWithFormat:@"mb://listblog/%@", _photo.user]],
					   @"Comments",
					   [TTTableMessageItem itemWithTitle:@"Cat" 
												 caption:nil 
													text:@"hahahahah ser rolig ut faktiskt!" 
											   timestamp:[NSDate dateWithToday]
												imageURL:@"http://mobilblogg.nu/cache/ttf/0eeb25b3f0eea52214.jpg"
													 URL:nil],
					   nil];
}

-(void)dealloc
{
	NSLog(@"DEALLOC: ShowPictureInfoController");
	[super dealloc];
}

@end
