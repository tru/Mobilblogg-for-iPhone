//
//  MBPush.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2010-02-15.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import "MBPush.h"
#import <Three20/Three20.h>

@implementation MBPush

@synthesize name = _name, token = _token;

-(id)initWithUsername:(NSString*)name andToken:(NSString*)token
{
	self = [super init];
	_token = token;
	_name = name;
	
	NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"setToken", @"func",
						  _name, @"user",
						  _token, @"token",
						  nil];
	
	_conn = [[MBConnectionRoot alloc] initWithArguments:args];
	_conn.delegate = self;

	TTDINFO(@"MBPush inited %@", _name);
	return self;
}

-(void)MBConnectionRoot:(MBConnectionRoot *)connection didFailWithError:(NSError *)err
{
	TTDINFO("Couldn't register token with server");
}

-(void)MBConnectionRoot:(MBConnectionRoot *)connection didFinishWithObject:(id)object
{
	NSDictionary *dict = [object objectAtIndex:0];
	NSString *err = [dict objectForKey:@"error"];
	if (err) {
		TTDINFO(@"Error from server: %@", err);
	}
	TTDINFO("Done with token @ server");
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: MBToken");
	[_name release];
	[_token release];
	[super dealloc];
}


@end
