//
//  MBPhoto.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBPhoto.h"
#import "NSString+MBAPI.h"

@implementation MBPhoto

@synthesize photoSource = _photoSource, size = _size, index = _index, caption = _caption, user = _user, photoId = _photoId;
@synthesize thumbURL = _thumbURL, smallURL = _smallURL, URL = _URL;
@synthesize date = _date, body = _body, numcomments = _numcomments;
@synthesize location = _location;

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

/*
-(NSString*)URLValueWithName:(NSString*)name
{
	TTDINFO(@"URLValueWithName");
	if ([name isEqualToString:@"TTPhotoViewController"]) {
		return [NSString stringWithFormat:@"mb://picture/%d", self.photoId];
	}
	return nil;
}
*/

-(CLLocationCoordinate2D)coordinate
{
	if (_location) {
		return _location.coordinate;
	} else {
		CLLocationCoordinate2D ret;
		ret.longitude = -122.030731;
		ret.latitude = 37.331688;
		return ret;
	}
}

-(NSString*)title
{
	if (self.caption.length) {
		return [self.caption wordWrapToLength:23];
	} else {
		return @"";
	}
}

-(NSString*)subtitle
{
	if (self.user.length) {
		NSMutableString *subtitle = [NSMutableString stringWithFormat:@"By: %@", self.user];
		if (self.date) {
			[subtitle appendFormat:@" - %@", [self.date formatRelativeTime]];
		}
		
		return subtitle;
	} else {
		return NSLocalizedString(@"No user", nil);
	}
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: MBPhoto %d", _photoId);
	[_thumbURL release];
	[_smallURL release];
	[_URL release];
	[_caption release];
	[_user release];
	[_date release];
	[_body release];
	if (_location) {
		[_location release];
	}
	[super dealloc];
}

@end
