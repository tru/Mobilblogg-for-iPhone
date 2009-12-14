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
#import "MBGlobal.h"


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

	NSString *url = [NSString stringWithFormat:@"%@%@", kMobilBloggHTTPProtocol, kMobilBloggHTTPBasePath];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								 kMobilBloggTemplateName, @"template",
								 @"listComments", @"func",
								 [NSString stringWithFormat:@"%d", _photoId], @"imgid",
								 nil];
	url = [url stringByAppendingFormat:@"?%@", [dict gtm_httpArgumentsString]];
	
	TTDINFO(@"Created URL: %@", url);
	
	TTURLRequest *req = [TTURLRequest requestWithURL:url delegate:self];
	req.cachePolicy = TTURLRequestCachePolicyNetwork;
	req.response = _response;
	req.httpMethod = @"GET";
	
	[req send];
}

-(void)reset
{
	TTDINFO(@"Reset!");
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
	TTDINFO(@"DEALLOC: CommentModel");
    [_response release];
    [super dealloc];
}

@end
