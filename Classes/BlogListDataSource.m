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

@implementation BlogListDataSource

- (void)tableViewDidLoadModel:(UITableView *)tableView
{
    [super tableViewDidLoadModel:tableView];
    
    NSLog(@"Removing all objects in the table view.");
    [self.items removeAllObjects];
    
    for (MBPhoto *photo in [(id<BlogListModelProtocol>)self.model results]) {
		TTTableSubtitleItem *item = [TTTableSubtitleItem itemWithText:photo.caption 
															 subtitle:[@"By: " stringByAppendingString:photo.user]
															 imageURL:[photo.smallURL absoluteString]
																  URL:[@"mb://picture/" stringByAppendingFormat:@"%d", photo.photoId]];
        [self.items addObject:item];
	}

	
	[self.items addObject:[TTTableMoreButton itemWithText:@"Load more ..."]];
    
    NSLog(@"Added %lu result objects", (unsigned long)[self.items count]);
}


@end
