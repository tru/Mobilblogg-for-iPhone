//
//  MBPhoto.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBPhoto.h"


@implementation MBPhoto

@synthesize photoId, caption, user, smallURL, largeURL, x, y;

-(id)initWithPhotoId:(NSUInteger)pId
{
	self = [super init];
	self.photoId = pId;
	return self;
}

@end
