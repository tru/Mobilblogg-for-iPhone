//
//  MBUser.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-12.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBUser.h"
#import "GTMNSDictionary+URLArguments.h"
#import "MBGlobal.h"
#import <Three20/Three20.h>

@implementation MBUser
@synthesize name = _name, info = _info, avatarURL = _avatarURL, delegate = _delegate;

-(id)initWithUserName:(NSString*)userName
{
	self = [super init];
	_name = [userName copy];
	
	NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"profile", @"func",
						  _name, @"user",
						  nil];
	
	_conn = [[MBConnectionRoot alloc] initWithArguments:args];
	_conn.delegate = self;
	[_conn release];

	TTDINFO(@"MBUser inited %@", _name);
	return self;
}

-(void)MBConnectionRoot:(MBConnectionRoot *)connection didFailWithError:(NSError *)err
{
	[_delegate MBUser:self didFailWithError:err];
}

-(void)MBConnectionRoot:(MBConnectionRoot *)connection didFinishWithObject:(id)object
{
	NSDictionary *dict = [object objectAtIndex:0];
	NSString *err = [dict objectForKey:@"error"];
	if (err && [err isEqualToString:@"user not found"]) {
		if ([_delegate respondsToSelector:@selector(MBUser:didFailWithError:)]) {
			NSError *err = [NSError errorWithDomain:MobilBloggErrorDomain code:MobilBloggErrorCodeNoSuchUser 
										   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
													 NSLocalizedString(@"No such user", nil), NSLocalizedDescriptionKey, nil]];
			[_delegate MBUser:self didFailWithError:err];
		}
		return;
	} else if (err) {
		if ([_delegate respondsToSelector:@selector(MBUser:didFailWithError:)]) {
			NSError *reterr = [NSError errorWithDomain:MobilBloggErrorDomain code:MobilBloggErrorCodeServer 
											  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
														err, NSLocalizedDescriptionKey,
														nil]];
			[_delegate MBUser:self didFailWithError:reterr];
		}
		return;
	}

	_info = [[dict objectForKey:@"description"] copy];
	_avatarURL = [[dict objectForKey:@"avatar"] copy];
	[_delegate MBUserDidReceiveInfo:self];
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: MBUser");
	[_name release];
	[_info release];
	[_avatarURL release];
	if (_delegate) {
		[_delegate release];
	}
	[super dealloc];
}

@end
