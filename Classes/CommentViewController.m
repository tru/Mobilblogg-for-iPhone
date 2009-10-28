//
//  CommentViewController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "CommentViewController.h"

@implementation CommentViewController
//@synthesize photoId = _photoId;

-(id)initWithId:(id)pId
{
	self = [super init];
	_photoId = [pId intValue];

	self.title=NSLocalizedString (@"Comments", nil);
	self.variableHeightRows = YES;
	self.dataSource = [TTListDataSource dataSourceWithObjects:[TTTableMessageItem itemWithTitle:@"Cat" 
																						caption:nil 
																						   text:@"hahahahah ser rolig ut faktiskt!" 
																					  timestamp:[NSDate dateWithToday]
																					   imageURL:@"http://mobilblogg.nu/cache/ttf/0eeb25b3f0eea52214.jpg"
																							URL:nil],
					   nil];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
																						   target:self 
																						   action:@selector(writeComment)];
	return self;
}

-(void)writeComment
{
	TTPostController *pc = [[TTPostController alloc] init];
	[pc showInView:self.tableView animated:YES];
	[pc release];
}

@end
