//
//  MBSalt.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-12-14.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBSalt.h"
#import "MBGlobal.h"

@implementation MBSalt

@synthesize delegate = _delegate;

-(id)initWithUsername:(NSString *)username
{
	self = [super init];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"getSalt", @"func",
						  username, @"user",
						  nil];
	
	_connRoot = [[MBConnectionRoot alloc] initWithArguments:dict];
	_connRoot.delegate = self;
	
	TTDINFO(@"MBSalt inited");
	return self;
}

-(void)MBConnectionRoot:(MBConnectionRoot *)connection didFailWithError:(NSError *)err
{
	[_delegate saltDidFailWithError:err];
}

-(void)MBConnectionRoot:(MBConnectionRoot *)connection didFinishWithObject:(id)object
{
	NSDictionary *dict = [object objectAtIndex:0];
	if ([dict objectForKey:@"salt"]) {
		[_delegate saltDidSucceed:[dict objectForKey:@"salt"]];
	} else {
		NSDictionary *errDict = [NSDictionary dictionaryWithObjectsAndKeys:
								 NSLocalizedString(@"No salt", nil), NSLocalizedDescriptionKey,
								 nil];
		NSError *err = [NSError errorWithDomain:MobilBloggErrorDomain code:MobilBloggErrorCodeInvalidSalt userInfo:errDict];
		[_delegate saltDidFailWithError:err];
	}
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: MBSalt");
	[super dealloc];
}

@end
