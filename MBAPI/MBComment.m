//
//  MBComment.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-15.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBComment.h"

@implementation MBComment

@synthesize comment = _comment;
@synthesize user = _user;
@synthesize photoId = _photoId;
@synthesize date = _date;
@synthesize URL = _URL;
@synthesize imageURL = _imageURL;
@synthesize padding = _padding;
@synthesize commentPlain = _commentPlain;

-(id)initWithUserName:(NSString*)userName
{
	self = [super init];
	_padding = UIEdgeInsetsMake(6, 6, 6, 6);
	_user = [userName copy];
	_imageURL = @"http://mobilblogg.nu/cache/ttf/011086f0e011367f52.gif";
	return self;
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: MBComment");
	[_comment release];
	[_user release];
	[_date release];
	[_URL release];
	[_imageURL release];
	[super dealloc];
}

@end
