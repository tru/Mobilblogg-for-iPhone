//
//  NSString+MBAPI.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "NSString+MBAPI.h"


@implementation NSString (MBAPI)

-(NSString *)wordWrapToLength:(NSUInteger)length
{
	if ([self length] <= length) {
		return self;
	}
	NSMutableString *str = [self mutableCopy];
	char space = [str characterAtIndex:length];
	NSUInteger len = length;
	while (space != ' ' && len) {
		len--;
		space = [str characterAtIndex:len];
	}
	
	if (len == 0) {
		len = length;
	}
		
	NSString *retstr = [str substringToIndex:len];
	[str release];
	return [retstr stringByPaddingToLength:len+3 withString:@"." startingAtIndex:0];
}

@end
