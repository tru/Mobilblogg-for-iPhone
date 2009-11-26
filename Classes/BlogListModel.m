//
//  BlogListModel.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "BlogListModel.h"
#import "GTMNSDictionary+URLArguments.h"

@implementation BlogListModel

#define kMBAPIProtocol "http://"
#define kMBAPIHost "www.mobilblogg.nu/o.o.i.s" //&func=listBlogg&user=tru&page=1"

-(id)initWithArguments:(NSDictionary*)arguments
{
	self = [super init];
	_page = 1;
	_arguments = arguments;
	[_arguments retain];
	_response = [[MBBlogListResponse alloc] init];
	return self;
}

-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
	if (more) {
		_page += 1;
	} else {
		[_response.entries removeAllObjects];
	}
	
	NSString *url = [NSString stringWithFormat:@"%s%s", kMBAPIProtocol, kMBAPIHost];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
						  @".api.t", @"template",
						  [NSString stringWithFormat:@"%lu",_page], @"page",
						  nil];
	[dict addEntriesFromDictionary:_arguments];
	url = [url stringByAppendingFormat:@"?%@", [dict gtm_httpArgumentsString]];
		
	TTURLRequest *req = [TTURLRequest requestWithURL:url delegate:self];
	req.cachePolicy = TTURLRequestCachePolicyNetwork;
	req.response = _response;
	req.httpMethod = @"GET";
	
	[req send];
}

-(void)reset
{
    [super reset];
    _page = 1;
    [[_response entries] removeAllObjects];
}

-(NSArray *)results
{
    return [[[_response entries] copy] autorelease];
}

-(NSUInteger)totalResultsAvailableOnServer
{
	NSUInteger numentries = [[_response entries] count];
	if (numentries % 10 == 0) {
		return numentries + 10;
	} else {
		return numentries;
	}
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: BlogListModel");
    [_response release];
    [super dealloc];
}

@end
