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
#import "MBGlobal.h"
#import <Three20/Three20.h>

@implementation MBLogin

@synthesize delegate = _delegate;

-(id)initWithUsername:(NSString*)username andPassword:(NSString*)password
{	
	self = [super init];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"login", @"func",
						  username, @"username",
						  password, @"password",
						  nil];
	
	_connRoot = [[MBConnectionRoot alloc] initWithArguments:dict];
	_connRoot.delegate = self;
	
	/* Remove all cookies, we want new ones */
	NSHTTPCookieStorage *store = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray *cookies = [store cookiesForURL:_connRoot.url];
	for (NSHTTPCookie *c in cookies) {
		TTDINFO(@"Removing cookie %@", [c name]);
		[store deleteCookie:c];
	}
	
	TTDINFO(@"MBLogin inited");
	
	return self;
}

-(void)MBConnectionRoot:(MBConnectionRoot *)connection didFailWithError:(NSError *)err
{
	[_delegate loginDidFailWithError:err];
}

-(void)MBConnectionRoot:(MBConnectionRoot *)connection didFinishWithObject:(id)object
{
	TTDINFO(@"did finish with object!");
	NSDictionary *dict = [object objectAtIndex:0];
	if ([[dict objectForKey:@"status"] intValue] == 1) {
		[_delegate loginDidSucceed];
	} else {
		NSDictionary *errDict = [NSDictionary dictionaryWithObjectsAndKeys:
								 NSLocalizedString(@"Server rejected credentials", nil), NSLocalizedDescriptionKey,
								 [NSArray arrayWithObject:NSLocalizedString(@"Try again?", nil)], NSLocalizedRecoveryOptionsErrorKey,
								 nil];
		NSError *err = [NSError errorWithDomain:MobilBloggErrorDomain code:MobilBloggErrorCodeInvalidCredentials userInfo:errDict];
		[_delegate loginDidFailWithError:err];
	}
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: MBLogin");
	[super dealloc];
}


@end
