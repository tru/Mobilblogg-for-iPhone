//
//  BlogListDataSource.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "BlogListDataSource.h"
#import "BlogListModel.h"

@implementation BlogListDataSource

- (void)tableViewDidLoadModel:(UITableView *)tableView
{
    [super tableViewDidLoadModel:tableView];
    
    NSLog(@"Removing all objects in the table view.");
    [self.items removeAllObjects];
    
/*	[self.items addObject:@"Today"];*/
    for (TTTableSubtitleItem *photo in [(id<BlogListModelProtocol>)self.model results])
        [self.items addObject:photo];
    
    NSLog(@"Added %lu result objects", (unsigned long)[self.items count]);
}


@end
