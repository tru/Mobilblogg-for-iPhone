//
//  MBPhoto.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBPhoto.h"

@implementation MBPhoto

@synthesize photoSource = _photoSource, size = _size, index = _index, caption = _caption, user = _user, photoId = _photoId;
@synthesize thumbURL = _thumbURL, smallURL = _smallURL, URL = _URL;
@synthesize date = _date;

+(MBPhoto*)photoWithPhotoId:(NSUInteger)pId
{
	return [[[MBPhoto alloc] initWithPhotoId:pId] autorelease];
}

-(id)initWithPhotoId:(NSUInteger)pId
{
	self = [super init];
	self.photoId = pId;
	return self;
}

- (NSString*)URLForVersion:(TTPhotoVersion)version {
  if (version == TTPhotoVersionLarge) {
    return _URL;
  } else if (version == TTPhotoVersionMedium) {
    return _URL;
  } else if (version == TTPhotoVersionSmall) {
    return _smallURL;
  } else if (version == TTPhotoVersionThumbnail) {
    return _thumbURL;
  } else {
    return nil;
  }
}

-(void)dealloc
{
	NSLog(@"DEALLOC: MBPhoto %d", _photoId);
	[_thumbURL release];
	[_smallURL release];
	[_URL release];
	[_caption release];
	[_user release];
	[_date release];
	[super dealloc];
}

@end
