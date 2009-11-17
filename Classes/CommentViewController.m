//
//  CommentViewController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentModel.h"
#import "CommentDataSource.h"

@implementation CommentViewController
//@synthesize photoId = _photoId;

-(id)initWithId:(id)pId
{
	self = [super init];
	self.title = NSLocalizedString(@"Comments", nil);
	self.variableHeightRows = YES;
	
	id<TTTableViewDataSource> ds = [CommentDataSource dataSourceWithItems:nil];
	ds.model = [[[CommentModel alloc] initWithPhotoId:[pId intValue]] autorelease];
	((CommentDataSource*)ds).delegate = self;
	self.dataSource = ds;
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
																						   target:self 
																						   action:@selector(writeComment)];
	return self;
}

-(void)dataSourceUpdate
{
	[self.tableView	reloadData];
}

-(void)writeComment
{
	TTPostController *pc = [[TTPostController alloc] init];
	[pc showInView:self.tableView animated:YES];
	[pc release];
}

@end
