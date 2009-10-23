//
//  MBURLResponse.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBURLResponse.h"

@implementation MBURLResponse
@synthesize entries;

+ (id)response
{
	NSLog(@"inited!");
    return [[[[self class] alloc] init] autorelease];
}

-(id)init
{
	NSLog(@"Response got called");
	self = [super init];
	self.entries = [[NSMutableArray alloc] init];
	return self;
}

-(void)dealloc
{
	[entries release];
	[super dealloc];
}

#pragma mark TTURLResponse
- (NSError*)request:(TTURLRequest*)request processResponse:(NSHTTPURLResponse*)response data:(id)data
{
    NSLog(@"We have data, I guess %s", [data bytes]);
	return nil;
}

- (NSString*)format
{
	return @"JSON";
}

@end
