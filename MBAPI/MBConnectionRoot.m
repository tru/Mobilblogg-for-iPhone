//
//  MBConnectionRoot.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-12.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBConnectionRoot.h"
#import "GTMNSDictionary+URLArguments.h"
#import "JSON.h"
#import <Three20/Three20.h>

@implementation MBConnectionRoot

@synthesize url = _url;
@synthesize delegate = _delegate;

-(id)initWithArguments:(NSDictionary*)arguments
{
	self = [super init];
	_data = nil;
	
	NSMutableDictionary *args = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								 @".api.t", @"template",
								 nil];
	
	[args addEntriesFromDictionary:arguments];

	_url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.mobilblogg.nu/o.o.i.s?%@", [args gtm_httpArgumentsString]]];
	TTDINFO(@"Connection Root at URL: %@", _url);
	
	NSURLRequest *req = [NSURLRequest requestWithURL:_url];
	NSURLConnection *conn = [NSURLConnection connectionWithRequest:req delegate:self];
	[conn start];
	
	return self;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	//TTDINFO(@"Adding data");
	if (_data) {
		[_data appendData:data];
	} else {
		_data = [data mutableCopy];
	}
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	TTDINFO(@"MBConnectionRoot fail");
	[_delegate MBConnectionRoot:self didFailWithError:error];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//TTDINFO(@"We are done!");
	SBJSON *parser = [[SBJSON alloc] init];
	
	NSString *responseBody = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
//	TTDINFO(@"body = %@", responseBody);
	NSError *jsonErr;
	NSArray *response = [parser objectWithString:responseBody error:&jsonErr];
	
	[parser release];
	[responseBody release];
	
	if (!response) {
		[_delegate MBConnectionRoot:self didFailWithError:jsonErr];
		return;
	}
	
	[_delegate MBConnectionRoot:self didFinishWithObject:response];
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: MBConnectionRoot");
	[_data release];
	[super dealloc];
}

@end
