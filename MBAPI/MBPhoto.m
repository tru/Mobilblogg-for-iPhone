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

static NSMutableDictionary *_photoStore = NULL;
static NSArray *_currentBlogList = NULL;

+(NSArray *)getCurrentBlogListCopy
{
	NSArray *ret;
	@synchronized(_currentBlogList)
	{
		ret = [_currentBlogList copy];
	}
	return ret;
}

+(void)setCurrentBlogList:(NSArray*)blogList
{
	@synchronized(_currentBlogList) {
		if (_currentBlogList) {
			NSLog(@"We have a curent blog that we are releasing now!");
			for (MBPhoto *p in _currentBlogList) {
				[MBPhoto removePhoto:p];
				[p release];
			}
			[_currentBlogList release];
		}
		_currentBlogList = [blogList copy];
	}
}

+(MBPhoto *)getPhotoById:(NSUInteger) pId
{
	MBPhoto *ret;
	@synchronized(_photoStore) {
		if (!_photoStore) {
			_photoStore = [[NSMutableDictionary alloc] init];
		}
	
		ret = [_photoStore objectForKey:[NSNumber numberWithUnsignedInt:pId]];
	}
	return ret;
}

+(void)removePhoto:(MBPhoto *)photo
{
	@synchronized(_photoStore) {
		[_photoStore removeObjectForKey:[NSNumber numberWithUnsignedInt:photo.photoId]];
	}
}

+(void)storePhoto:(MBPhoto *)photo
{
	@synchronized(_photoStore) {
		if (!_photoStore) {
			_photoStore = [[NSMutableDictionary alloc] init];
		}
	
		[_photoStore setObject:photo forKey:[NSNumber numberWithUnsignedInt:photo.photoId]];
	}
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
	NSLog(@"Destroying MBPhoto %d", _photoId);
	[_thumbURL release];
	[_smallURL release];
	[_URL release];
	[_caption release];
	[_user release];
	[_date release];
	[super dealloc];
}

@end
