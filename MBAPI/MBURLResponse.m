//
//  MBURLResponse.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBURLResponse.h"
#import "JSON.h"

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
	SBJSON *parser = [[SBJSON alloc] init];
	
	/* Wee Latrin1 ;) */
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
	responseBody = [responseBody stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
	NSError *jsonErr;
	NSArray *photos = [parser objectWithString:responseBody error:&jsonErr];
	
	for (NSDictionary *p in photos) {
		NSLog(@"Adding item with caption %@", [p objectForKey:@"caption"]);
		TTTableSubtitleItem *item = [TTTableSubtitleItem itemWithText:[p objectForKey:@"caption"]
															 subtitle:[NSString stringWithFormat:@"By %@", [p objectForKey:@"user"]]
															 imageURL:[p objectForKey:@"picture_small"]
																  URL:[NSString stringWithFormat:@"mb://picture/%@", [p objectForKey:@"id"]]];
		[self.entries addObject:item];
	}
	
	return nil;
}

- (NSString*)format
{
	return @"JSON";
}

@end
