//
//  BlogListDataSource.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "BlogListDataSource.h"
#import "BlogListModel.h"
#import "MBPhoto.h"
#import "MBTablePhotoItem.h"

@implementation BlogListDataSource

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    [super tableViewDidLoadModel:tableView];

    /* Clean table first */
    [self.items removeAllObjects];
		
	NSUInteger index = 0;
    for (MBPhoto *photo in [(id<BlogListModelProtocol>)self.model results]) {
		MBTablePhotoItem *item = [[[MBTablePhotoItem alloc] initWithMBPhoto:photo] autorelease];
		photo.index = index ++;
        [self.items addObject:item];
	}
	
	if (([self.items count] % 10) == 0) {
		[self.items addObject:[TTTableMoreButton itemWithText:NSLocalizedString(@"Load more ...", nil)]];
	}
    
    NSLog(@"Added %lu result objects", (unsigned long)[self.items count]);
}

-(void)dealloc
{
	NSLog(@"DEALLOC: BlogListDataSource %x", self);
	[[TTNavigator navigator].URLMap	removeURL:[NSString stringWithFormat:@"mb://_topicture/%x/(navigateToPhotos:)", self]];
	[super dealloc];
}


@end
