//
//  MBURLResponse.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBURLResponse.h"
#import "JSON.h"
#import "MBPhoto.h"

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
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSError *jsonErr;
	NSArray *photos = [parser objectWithString:responseBody error:&jsonErr];
	
	if (!photos) {
		NSLog(@"Error? %@", [jsonErr localizedDescription]);
	}
	
	for (NSDictionary *p in photos) {
		NSLog(@"Adding item with caption %@", [p objectForKey:@"caption"]);
		MBPhoto *photo = [[MBPhoto alloc] initWithPhotoId:[[p objectForKey:@"id"] intValue]];
		photo.caption = [p objectForKey:@"caption"];
		photo.user = [p objectForKey:@"user"];
		photo.thumbURL = [p objectForKey:@"picture_small"];
		photo.smallURL = [p objectForKey:@"picture_large"];
		photo.URL = [p objectForKey:@"picture_large"];
		
		[MBPhoto storePhoto:photo]; /* global cache of photos */
		[self.entries addObject:photo];
	}
	
	return nil;
}

- (NSString*)format
{
	return @"JSON";
}

@end
