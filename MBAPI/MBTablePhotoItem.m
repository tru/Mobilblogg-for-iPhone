//
//  MBTablePhotoItem.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-12.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBTablePhotoItem.h"


@implementation MBTablePhotoItem

@synthesize photo = _photo;

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

-(id)initWithMBPhoto:(MBPhoto*)photo
{
	NSString *caption;
	if ([photo.caption length] > 25) {
		caption = [MBTablePhotoItem wordWrapString:photo.caption atLength:25];
	} else {
		caption = photo.caption;
	}
	NSMutableString *subtitle = [NSMutableString stringWithFormat:@"By: %@", photo.user];
	if (photo.date) {
		[subtitle appendFormat:@" - %@", [photo.date formatRelativeTime]];
	}
	
	_photo = photo;
	[_photo retain];

	self = [super init];
	/* Note: We must set the URL here, otherwise we won't get the nice
	 * > arrow at the end of the item and we don't get visual feedback
	 * when someone is selecting an item.
	 * For this to work the controller have to ignore the mb://foobar
	 * URL. see BlogListController:shouldOpenURL:
	 */
	self.URL = @"mb://foobar";
	self.accessoryURL = nil;
	self.text = caption;
	self.subtitle = subtitle;
	self.defaultImage = TTIMAGE(@"bundle://Three20.bundle/images/empty.png");
	self.imageURL = photo.URL;
	
	return self;
}

-(void)dealloc
{
	[_photo release];
	[super dealloc];
}

@end
