//
//  MBAPI.m
//  mblogapi
//
//  Created by Tobias Rundström on 2009-10-20.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBAPI.h"
#import "MBURLConnection.h"

@implementation MBAPI

@synthesize username;
@synthesize password;

#define kMBAPIProtocol "http://"
#define kMBAPIHost "www.mobilblog.nu/o.o.i.s?template=.api.t" //&func=listBlogg&user=tru&page=1"

-(id) initWithDelegate:(id)delegate
{
	_delegate = delegate;
	
	return self;
}

-(NSURL*) _apiMethod:(NSString *)method andArguments:(NSString*)args
{
	NSString *url = [NSString stringWithFormat:@"%s%s&func=%@", kMBAPIProtocol, kMBAPIHost, method];
	if (args) {
		url = [NSString stringWithFormat:@"%@&%@", url, args];
	}
	NSURL *returl = [[NSURL alloc] initWithString:url];
	NSLog(@"Constructed URL: %@", returl);
	return returl;
}

-(void) _doRequest:(NSString *)method withArgument:(NSString*)arg delegate:(id)target andAction:(SEL)action
{
	NSMutableURLRequest *req = [[NSMutableURLRequest alloc] init];
	[req setURL:[self _apiMethod:method andArguments:arg]];
	
	[[MBURLConnection alloc] initWithRequest:req delegate:target andAction:action];
}

-(void) _doRequest:(NSString *)method delegate:(id)target andAction:(SEL)action
{
	[self _doRequest:method withArgument:nil delegate:target andAction:action];
}

-(void) gotPing:(id)payload
{
	if ([_delegate respondsToSelector:@selector(MBAPIDidConnect:)]) {
		[_delegate performSelector:@selector(MBAPIDidConnect:) withObject:self];
	}
}

-(void) connectWithUsername:(NSString*)user andPassword:(NSString*)pass
{
	[self setUsername:user];
	[self setPassword:pass];
//	[self _doRequest:@"Ping" delegate:self andAction:@selector(gotPing:)];
}

-(void)listBlogg:(NSString*)blog delegate:(id)delegate andSelector:(SEL)action
{
	[self _doRequest:@"listBlogg" withArgument:[NSString stringWithFormat:@"user=%@",blog] delegate:delegate andAction:action];
}


-(void)startPageList:(id)delegate andSelector:(SEL)action
{
	[self _doRequest:@"StartPageList" delegate:delegate andAction:action];
}

-(void)pictureInfo:(NSNumber*)identifier delegate:(id)delegate andSelector:(SEL)action
{
	[self _doRequest:@"PictureInfo" withArgument:[NSString stringWithFormat:@"pictureid=%@",identifier] delegate:delegate andAction:action];
}


/* MBURLConnecitonProtocol */
-(void)MBURLConnection:(MBURLConnection *)conn gotWrongCredentials:(NSError *)error
{
	if ([_delegate respondsToSelector:@selector(MBAPI:failWithWrongCredentials:)]) {
		[_delegate performSelector:@selector(MBAPI:failWithWrongCredentials:) withObject:error];
	}
}

-(void)MBURLConnection:(MBURLConnection *)conn gotParseError:(NSError *)error
{
	if ([_delegate respondsToSelector:@selector(MBAPI:didFailWithError:)]) {
		[_delegate performSelector:@selector(MBAPI:didFailWithError:) withObject:error];
	}
}

-(void)MBURLConnection:(MBURLConnection *)conn gotServerError:(NSError*)error
{
	/* let's throw a generic error here */
	[self MBURLConnection:conn gotParseError:error];
}

@end
