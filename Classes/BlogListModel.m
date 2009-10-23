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
#define kMBAPIHost "www.mobilblog.nu/o.o.i.s" //&func=listBlogg&user=tru&page=1"

@synthesize bloggName;

-(id)initWithBloggName:(NSString*)bName
{
	self = [super init];
	page = 1;
	self.bloggName = bName;
	responseModel = [[MBURLResponse alloc] init];
	return self;
}

-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
	if (more) {
		page += 1;
	} else {
		[responseModel.entries removeAllObjects];
	}

	NSLog(@"Loading data for %@ at page %d", bloggName, page);
	
	NSString *url = [NSString stringWithFormat:@"%s%s", kMBAPIProtocol, kMBAPIHost];
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  @".api.t", @"template",
						  @"listBlogg", @"func",
						  self.bloggName, @"user",
						  [NSString stringWithFormat:@"%lu",page], @"page",
						  nil];
	
	url = [url stringByAppendingFormat:@"?%@", [dict gtm_httpArgumentsString]];
	TTURLRequest *req = [TTURLRequest requestWithURL:url delegate:self];
	req.cachePolicy = TTURLRequestCachePolicyNoCache;
	req.response = responseModel;
	req.httpMethod = @"GET";
	
	[req send];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request
{
	NSLog(@"Hello did finish load!");
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error
{
	NSLog(@"Error: %@", [error localizedDescription]);
}

-(void)reset
{
	NSLog(@"Reset it");
    [super reset];
	[bloggName release];
    page = 1;
    [[responseModel entries] removeAllObjects];
}

-(NSArray *)results
{
	NSLog(@"Helo results!)");
    return [[[responseModel entries] copy] autorelease];
}

-(void)dealloc
{
    [bloggName release];
    [responseModel release];
    [super dealloc];
}

@end
