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

+ (NSString *)wordWrapString:(NSString *)string atLength:(NSUInteger)length
{
	if ([string length] < length) {
		return string;
	}
	NSMutableString *str = [string mutableCopy];
	char space = [str characterAtIndex:length];
	NSUInteger len = length;
	while (space != ' ') {
		len--;
		space = [str characterAtIndex:len];
	}
	
	NSLog(@"wordwrapped: %@ to %@", string, [string substringToIndex:len]);
	
	NSString *retstr = [str substringToIndex:len];
	[str release];
	return [retstr stringByPaddingToLength:len+3 withString:@"." startingAtIndex:0];
}

- (void)tableViewDidLoadModel:(UITableView *)tableView
{
    [super tableViewDidLoadModel:tableView];
    
    NSLog(@"Removing all objects in the table view.");
    [self.items removeAllObjects];
	
	[MBPhoto setCurrentBlogList:[(id<BlogListModelProtocol>)self.model results]];
	
    for (MBPhoto *photo in [(id<BlogListModelProtocol>)self.model results]) {
		NSString *caption;
		if ([photo.caption length] > 25) {
			caption = [BlogListDataSource wordWrapString:photo.caption atLength:25];
		} else {
			caption = photo.caption;
		}
		NSMutableString *subtitle = [NSMutableString stringWithFormat:@"By: %@", photo.user];
		if (photo.date) {
			[subtitle appendFormat:@" - %@", [photo.date formatRelativeTime]];
		}
		TTTableSubtitleItem *item = [TTTableSubtitleItem itemWithText:caption
															 subtitle:subtitle
															 imageURL:photo.thumbURL
																  URL:[@"mb://picture/" stringByAppendingFormat:@"%d", photo.photoId]];
        [self.items addObject:item];
	}

	
	[self.items addObject:[TTTableMoreButton itemWithText:@"Load more ..."]];
    
    NSLog(@"Added %lu result objects", (unsigned long)[self.items count]);
}

-(void)dealloc
{
	NSLog(@"BlogListDataSource get's dealloced");
	[super dealloc];
}


@end
