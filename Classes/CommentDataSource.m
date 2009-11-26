//
//  CommentPhotoSource.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-15.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "CommentDataSource.h"
#import "MBComment.h"
#import "CommentModel.h"
#import "MBCommentItemCell.h"

@implementation CommentDataSource

@synthesize delegate = _delegate;

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    [super tableViewDidLoadModel:tableView];

    /* Clean table first */
    [self.items removeAllObjects];
		
    for (MBComment *comment in [((CommentModel*)self.model) results]) {
		[comment retain];
		MBUser *user = [[[MBUser alloc] initWithUserName:comment.user] autorelease];
		user.delegate = self;
        [self.items addObject:comment];
	}
	
}

-(void)MBUserDidReceiveInfo:(MBUser *)user
{
	for (MBComment *c in self.items) {
		if (c.user == user.name) {
			c.imageURL = user.avatarURL;
			break;
		}
	}
	[_delegate dataSourceUpdate];
}

-(Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[MBComment class]]) {
		return [MBCommentItemCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

-(void)dataSourceUpdate
{
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: CommentDataSource %x", self);
	[super dealloc];
}

@end
