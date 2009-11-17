//
//  CommentModel.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-15.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "CommentModel.h"
#import "MBCommentResponse.h"
#import "GTMNSDictionary+URLArguments.h"

#define kMBAPIProtocol "http://"
#define kMBAPIHost "www.mobilblogg.nu/o.o.i.s" //&func=listBlogg&user=tru&page=1"

@implementation CommentModel

-(id)initWithPhotoId:(NSUInteger)photoId
{
	self = [super init];
	_photoId = photoId;
	_response = [[MBCommentResponse alloc] init];
	return self;
}

-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
	[_response.comments removeAllObjects];

	NSString *url = [NSString stringWithFormat:@"%s%s", kMBAPIProtocol, kMBAPIHost];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								 @".api.t", @"template",
								 @"listComments", @"func",
								 [NSString stringWithFormat:@"%d", _photoId], @"imgid",
								 nil];
	url = [url stringByAppendingFormat:@"?%@", [dict gtm_httpArgumentsString]];
	
	NSLog(@"Created URL: %@", url);
	
	TTURLRequest *req = [TTURLRequest requestWithURL:url delegate:self];
	req.cachePolicy = TTURLRequestCachePolicyNetwork;
	req.response = _response;
	req.httpMethod = @"GET";
	
	[req send];
}

-(void)reset
{
	NSLog(@"Reset!");
    [super reset];
    [[_response comments] removeAllObjects];
}

-(NSArray *)results
{
    return [[[_response comments] copy] autorelease];
}

-(NSUInteger)totalResultsAvailableOnServer
{
	return [[_response comments] count];
}

-(void)dealloc
{
	NSLog(@"DEALLOC: CommentModel");
    [_response release];
    [super dealloc];
}

@end
