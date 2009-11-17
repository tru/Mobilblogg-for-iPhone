//
//  MBURLResponse.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBBlogListResponse.h"
#import "JSON.h"
#import "MBPhoto.h"
#import "MBErrorCodes.h"

@implementation MBBlogListResponse
@synthesize entries = _entries;

-(id)init
{
	NSLog(@"Response got called");
	self = [super init];
	_entries = [[NSMutableArray alloc] init];
	return self;
}

-(void)dealloc
{
	NSLog(@"DEALLOC: MBURLResponse");
	[_entries release];
	[super dealloc];
}

-(void)printErrorTrace:(NSError*)err
{
	NSLog(@"Error tranceback:");
	NSError *node = err;
	while (node) {
		NSLog(@"  %@", [node localizedDescription]);
		node = [[node userInfo] objectForKey:NSUnderlyingErrorKey];
	}
}

#pragma mark TTURLResponse
- (NSError*)request:(TTURLRequest*)request processResponse:(NSHTTPURLResponse*)response data:(id)data
{
	SBJSON *parser = [[SBJSON alloc] init];
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSError *jsonErr;
	NSArray *photos = [parser objectWithString:responseBody error:&jsonErr];
	NSDateFormatter *dFormater = [[NSDateFormatter alloc] init];
	[dFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	[responseBody release];
	
	if (!photos) {
		[self printErrorTrace:jsonErr];
		[dFormater release];
		[parser release];
		return jsonErr;
	}
	
	
	for (NSDictionary *p in photos) {
		
		if ([p objectForKey:@"error"]) {
			NSError *err = [NSError errorWithDomain:MobilBloggErrorDomain code:MobilBloggErrorCodeServer 
										   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
													 [p objectForKey:@"error"], NSLocalizedDescriptionKey, nil]];
			[dFormater release];
			[parser release];
			
			return err;
		}
		
		MBPhoto *photo = [MBPhoto photoWithPhotoId:[[p objectForKey:@"id"] intValue]];
		photo.caption = [[p objectForKey:@"caption"] stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
		photo.user = [p objectForKey:@"user"];
		photo.thumbURL = [p objectForKey:@"picture_small"];
		photo.smallURL = [p objectForKey:@"picture_large"];
		photo.URL = [p objectForKey:@"picture_large"];
		NSString *dateStr = [p objectForKey:@"createdate"];
		if (dateStr) {
			photo.date = [dFormater dateFromString:[p objectForKey:@"createdate"]];
			if (!photo.date) {
				NSLog(@"Date parsing fail %@", [p objectForKey:@"createdate"]);
			}
		}
		
		[_entries addObject:photo];
	}
	
	[dFormater release];
	[parser release];
	
	NSLog(@"Data parsed and ready");
	
	return nil;
}

@end