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
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation MBLogin

@synthesize delegate = _delegate;

-(id)initWithUsername:(NSString*)username andPassword:(NSString*)password
{	
	self = [super init];

	/* store these for later use */
	_password = [password copy];
	_username = [username copy];
	
	/* First we need the salt */
	MBSalt *salt = [[MBSalt alloc] initWithUsername:_username];
	salt.delegate = self;
	[salt release];

	return self;
}

-(void)saltDidSucceed:(NSString *)salt
{
	TTDINFO(@"Have salt: %@", salt);

	/* concat salt and password */
	NSData *mySecStr = [[salt stringByAppendingString:_password] dataUsingEncoding:NSASCIIStringEncoding];
	
	/* now we can do SHA-1 on it */
	uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
	char finaldigest[CC_SHA1_DIGEST_LENGTH * 2 + 1] = {0};
	
	CC_SHA1(mySecStr.bytes, mySecStr.length, digest);
	
	/* make the digest into a hexformat */
	for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
		sprintf(finaldigest+i*2,"%02x", digest[i]);
	}
	
	_passwordHash = [NSString stringWithCString:finaldigest encoding:NSASCIIStringEncoding];
	[self doLogin];
}

-(void)saltDidFailWithError:(NSError *)err
{
	[_delegate loginDidFailWithError:err];
}
	
-(void)doLogin
{
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"login", @"func",
						  _username, @"username",
						  _passwordHash, @"password",
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
	[_password release];
	[_username release];
	[super dealloc];
}


@end
