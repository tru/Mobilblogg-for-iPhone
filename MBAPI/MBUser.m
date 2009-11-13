//
//  MBUser.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-12.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBUser.h"
#import "GTMNSDictionary+URLArguments.h"

@implementation MBUser
@synthesize name = _name, info = _info, avatarURL = _avatarURL, delegate = _delegate;

-(id)initWithUserName:(NSString*)userName
{
	self = [super init];
	_name = userName;
	
	NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"profile", @"func",
						  _name, @"user",
						  nil];
	
	_conn = [[MBConnectionRoot alloc] initWithArguments:args];
	_conn.delegate = self;

	NSLog(@"MBUser inited %@", _name);
	return self;
}

-(void)MBConnectionRoot:(MBConnectionRoot *)connection didFailWithError:(NSError *)err
{
	[_delegate MBUser:self didFailWithError:err];
}

-(void)MBConnectionRoot:(MBConnectionRoot *)connection didFinishWithObject:(id)object
{
	NSDictionary *dict = [object objectAtIndex:0];
	_info = [[dict objectForKey:@"description"] copy];
	_avatarURL = [[dict objectForKey:@"avatar"] copy];
	if ([_avatarURL isEqualToString:@"http://www.mobilblogg.nuno avatar"]) {
		_avatarURL = @"http://mobilblogg.nu/cache/ttf/011086f0e011367f52.gif";
	}
	[_delegate MBUserDidReceiveInfo:self];
}

-(void)dealloc
{
	NSLog(@"DEALLOC: MBUser");
	[_name release];
	[_info release];
	[_avatarURL release];
	[_conn release];
	[super dealloc];
}

@end
