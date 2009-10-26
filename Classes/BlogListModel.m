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
@synthesize funcName;

-(id)initWithFunction:(NSString*)fName
{
	self = [super init];
	page = 1;
	self.funcName = fName;
	responseModel = [[MBURLResponse alloc] init];
	return self;
}

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
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
						  @".api.t", @"template",
						  [NSString stringWithFormat:@"%lu",page], @"page",
						  nil];
	
	if (self.bloggName) {
		[dict setObject:@"listBlogg" forKey:@"func"];
		[dict setObject:self.bloggName forKey:@"user"];
	} else if (self.funcName) {
		[dict setObject:self.funcName forKey:@"func"];
	}
	
	url = [url stringByAppendingFormat:@"?%@", [dict gtm_httpArgumentsString]];
	TTURLRequest *req = [TTURLRequest requestWithURL:url delegate:self];
	req.cachePolicy = cachePolicy;
	req.response = responseModel;
	req.httpMethod = @"GET";
	
	[req send];
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
	NSLog(@"Helo results!");
    return [[[responseModel entries] copy] autorelease];
}

-(void)dealloc
{
    [bloggName release];
    [responseModel release];
    [super dealloc];
}

@end
