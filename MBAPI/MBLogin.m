//
//  MBLogin.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-06.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBLogin.h"
#import "GTMNSDictionary+URLArguments.h"
#import "JSON.h"


@implementation MBLogin

@synthesize delegate = _delegate;

+(id)loginWithUsername:(NSString*)username andPassword:(NSString*)password
{
	self = [super alloc];
	
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"login", @"func",
						  @".api.t", @"template",
						  username, @"username",
						  password, @"password",
						  nil];
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.mobilblogg.nu/o.o.i.s?%@", [dict gtm_httpArgumentsString]]];
	NSLog(@"Login at URL: %@", url);
	
	/* Remove all cookies, we want new ones */
	NSHTTPCookieStorage *store = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray *cookies = [store cookiesForURL:url];
	for (NSHTTPCookie *c in cookies) {
		NSLog(@"Removing cookie %@", [c name]);
		[store deleteCookie:c];
	}
	
	NSURLRequest *req = [NSURLRequest requestWithURL:url];
	NSURLConnection *conn = [NSURLConnection connectionWithRequest:req delegate:self];
	[conn start];
	
	return [self autorelease];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSLog(@"Adding data");
	if (_responseData) {
		[_responseData appendData:data];
	} else {
		_responseData = [data mutableCopy];
	}
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[_delegate loginDidFailWithError:error];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"We are done!");
	SBJSON *parser = [[SBJSON alloc] init];
	
	NSString *responseBody = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
	NSLog(@"body = %@", responseBody);
	NSError *jsonErr;
	NSArray *response = [parser objectWithString:responseBody error:&jsonErr];
	
	NSNumber *num = [[response objectAtIndex:0] objectForKey:@"status"];

	[responseBody release];
	[parser release];
	_responseData = nil;
	
	if (num && [num intValue] == 1) {
		NSLog(@"Cool, we managed to login!");
		[_delegate loginDidSucceed];
	} else {
		NSDictionary *errDict = [NSDictionary dictionaryWithObjectsAndKeys:
								 NSLocalizedString(@"Server rejected credentials", nil), NSLocalizedDescriptionKey,
								 [NSArray arrayWithObject:NSLocalizedString(@"Try again?", nil)], NSLocalizedRecoveryOptionsErrorKey,
								 nil];
		NSError *err = [NSError errorWithDomain:@"mobilblogg" code:1 userInfo:errDict];
		[_delegate loginDidFailWithError:err];

	}
}

-(void)dealloc
{
	NSLog(@"DEALLOC: MBLogin");
	[_responseData release];
	[super dealloc];
}


@end
