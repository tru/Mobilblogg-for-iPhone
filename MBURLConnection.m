//
//  MBURLConnection.m
//  mblogapi
//
//  Created by Tobias Rundström on 2009-10-21.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBURLConnection.h"


@implementation MBURLConnection

-(id)initWithRequest:(NSURLRequest *)request delegate:(id)target andAction:(SEL)action
{
	[super initWithRequest:request delegate:self];
	_cbAction = action;
	_data = [[NSMutableData alloc] init];
	_delegate = target;
	_json = [SBJSON new];
	
	return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
	if ([response statusCode] == 401) {
		/* Wrong Credentials */
		NSLog(@"ERROR: Wrong credentials");
		if ([_delegate respondsToSelector:@selector(MBURLConnection:gotWrongCredentials:)]) {
			[_delegate performSelector:@selector(MBURLConnection:gotWrongCredentials:) withObject:[NSError alloc]];
		}
		[self cancel];
	}
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Finished!");
	NSError *jsonErr;
	NSString *jsonStr = [[NSString alloc] initWithData:_data encoding:NSISOLatin1StringEncoding];
	
	NSLog(@"JSON data to parse: %@", jsonStr);
	
	NSDictionary *jsonDict = [_json	objectWithString:jsonStr error:&jsonErr];
	if (jsonDict == nil) {
		NSLog(@"Error from JSON parser: %@", [jsonErr localizedDescription]);
		if ([_delegate respondsToSelector:@selector(MBURLConnection:gotParseError:)]) {
			[_delegate performSelector:@selector(MBURLConnection:gotParseError:) withObject:jsonErr];
			return;
		}

	}

	/* check the code field in the toplevel of the returned code
	 * if it contains "ok" then the server have succeded to give
	 * us the data we requested. Otherwise we just bail out
	 */
	NSString *node = [jsonDict objectForKey:@"code"];
	NSLog(@"Node = %@", node);
	if ([node isEqualToString:@"ok"]) {
		NSLog(@"Got OK code from JSON");
	} else {
		NSLog(@"Fail from server with reason %@", [jsonDict objectForKey:@"data"]);
		if ([_delegate respondsToSelector:@selector(MBURLConnection:gotServerError:)]) {
			/* TODO: do something meaningful with the NSError here */
			[_delegate performSelector:@selector(MBURLConnection:gotServerError:) withObject:[NSError alloc]];
			return;
		}
	}
	
	if (![_delegate respondsToSelector:_cbAction]) {
		NSLog(@"Delegate won't answer to that selector?");
		return;
	}
	[_delegate performSelector:_cbAction withObject:[jsonDict objectForKey:@"data"]];
}
								
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
	[_data appendData:data];
	NSLog(@"Added data %s", [data bytes]);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"Error from connection: %@", [error localizedDescription]);
}

-(void)dealloc
{
	[_data release];
	[super dealloc];
}

@end
