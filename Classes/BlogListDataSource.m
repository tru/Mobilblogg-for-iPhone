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

+(NSString *)wordWrapString:(NSString *)string atLength:(NSUInteger)length
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
		
	NSString *retstr = [str substringToIndex:len];
	[str release];
	return [retstr stringByPaddingToLength:len+3 withString:@"." startingAtIndex:0];
}

-(id)init
{
	self = [super init];
	/*FIXME: FUGLY delux, must be fixed*/
	[[TTNavigator navigator].URLMap from:[NSString stringWithFormat:@"mb://_topicture/%x/(navigateToPhotos:)", self] toViewController:self];
	
	return self;
}

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    [super tableViewDidLoadModel:tableView];

    /* Clean table first */
    [self.items removeAllObjects];
		
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
																  URL:[@"mb://_topicture/" stringByAppendingFormat:@"%x/%d", self,photo.photoId]];
        [self.items addObject:item];
	}

	[self.items addObject:[TTTableMoreButton itemWithText:NSLocalizedString(@"Load more ...", nil)]];
    
    NSLog(@"Added %lu result objects", (unsigned long)[self.items count]);
}

-(void)navigateToPhotos:(id)photoId
{
	NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
						   photoId, @"photoId",
						   [(id<BlogListModelProtocol>)self.model results], @"photoList",
						   nil];
	[[TTNavigator navigator] openURL:@"mb://picture" query:query animated:YES];
}

-(void)dealloc
{
	NSLog(@"DEALLOC: BlogListDataSource %x", self);
	[[TTNavigator navigator].URLMap	removeURL:[NSString stringWithFormat:@"mb://_topicture/%x/(navigateToPhotos:)", self]];
	[super dealloc];
}


@end
