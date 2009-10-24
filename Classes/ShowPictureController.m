//
//  ShowPictureController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "ShowPictureController.h"


@implementation ShowPictureController

-(id)initWithId:(id)pictureId
{
	self = [super init];
	NSLog(@"Show Picture %@", pictureId);
	return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
