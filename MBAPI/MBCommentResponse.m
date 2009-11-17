//
//  MBComments.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-15.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBCommentResponse.h"
#import "SBJSON.h"

@implementation MBCommentResponse
@synthesize comments = _comments;

-(id)init
{
	NSLog(@"CommentResponse got called");
	self = [super init];
	_comments = [[NSMutableArray alloc] init];
	return self;
}

-(void)dealloc
{
	NSLog(@"DEALLOC: MBCommentResponse");
	[_comments release];
	[super dealloc];
}

#pragma mark TTURLResponse
- (NSError*)request:(TTURLRequest*)request processResponse:(NSHTTPURLResponse*)response data:(id)data
{
	SBJSON *parser = [[SBJSON alloc] init];
	
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSError *jsonErr;
	NSArray *comments = [parser objectWithString:responseBody error:&jsonErr];
	NSDateFormatter *dFormater = [[NSDateFormatter alloc] init];
	[dFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	[responseBody release];
	
	if (!comments) {
		[dFormater release];
		[parser release];
		return jsonErr;
	}
	
	for (NSDictionary *c in comments) {
		MBComment *comment = [[MBComment alloc] initWithUserName:[c objectForKey:@"author"]];
		comment.photoId = [[c objectForKey:@"imgid"] intValue];
		
		NSString *strip = [[c objectForKey:@"comment"] stringByReplacingOccurrencesOfString:@"<br>" withString:@"<br/>"];
		TTStyledText *txt = [TTStyledText textFromXHTML:strip];
		NSLog(@"our text is = %@", strip);
		comment.comment = txt;
		comment.commentPlain = [c objectForKey:@"comment"];
						
		NSString *dateStr = [c objectForKey:@"createdate"];
		if (dateStr) {
			comment.date = [dFormater dateFromString:[c objectForKey:@"createdate"]];
			if (!comment.date) {
				NSLog(@"Date parsing fail %@", [c objectForKey:@"createdate"]);
			}
		}
		
		[_comments addObject:comment];
		[comment release];
	}
	
	[dFormater release];
	[parser release];
	
	NSLog(@"Data parsed and ready");
	
	return nil;
}


@end
