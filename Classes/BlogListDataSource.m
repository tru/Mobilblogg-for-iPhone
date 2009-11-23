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
#import "MBPhotoItemCell.h"

@implementation BlogListDataSource

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    [super tableViewDidLoadModel:tableView];

    /* Clean table first */
    [self.items removeAllObjects];
		
	NSUInteger index = 0;
    for (MBPhoto *photo in [(id<BlogListModelProtocol>)self.model results]) {
		photo.index = index ++;
        [self.items addObject:[photo retain]];
	}
	
	if (([self.items count] % 10) == 0) {
		[self.items addObject:[TTTableMoreButton itemWithText:NSLocalizedString(@"Load more ...", nil)]];
	}
    
    NSLog(@"Added %lu result objects", (unsigned long)[self.items count]);
}

-(Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[MBPhoto class]]) {
		return [MBPhotoItemCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

-(void)dealloc
{
	NSLog(@"DEALLOC: BlogListDataSource %x", self);
	[[TTNavigator navigator].URLMap	removeURL:[NSString stringWithFormat:@"mb://_topicture/%x/(navigateToPhotos:)", self]];
	[super dealloc];
}


@end
