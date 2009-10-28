//
//  PhotoSource.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "PhotoSource.h"
#import "MBPhoto.h"


@implementation PhotoSource

@synthesize title = _title;

-(id)initWithPhotos:(NSArray*)photos
{
	self = [super init];
	
	_items = [photos mutableCopy];
	int index = 0;
	for (MBPhoto *it in _items) {
		it.photoSource = self;
		it.index = index ++;
	}
	
	_isLoading = NO;
	return self;
}

#pragma mark TTModel
	 
- (NSMutableArray*)delegates {
	if (!_delegates) {
		_delegates = TTCreateNonRetainingArray();
	}	
	return _delegates;
}

- (id<TTModel>)model {
	return self;
}

- (BOOL)isLoading {
	return _isLoading;
}

- (BOOL)isLoadingMore {
   return NO;

}

- (BOOL)isLoaded {
	return !!_items;
}

- (BOOL)isEmpty {
	return !_items.count;
}

- (BOOL)isOutdated {
	return NO;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {}

- (void)dataFinishedLoad {
	_isLoading = NO;
	[_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
}

- (void)dataStartedLoad {
	_isLoading = YES;
	[_delegates perform:@selector(modelDidStartLoad:) withObject:self];
}

-(void)invalidate:(BOOL)erase
{
}

-(void)cancel
{
}

#pragma mark TTPhotoSource

- (NSInteger)numberOfPhotos {
	return _items.count;
}

- (NSInteger)maxPhotoIndex {
	return _items.count-1;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)index {
	if (index < _items.count) {
		id photo = [_items objectAtIndex:index];
		if (photo == [NSNull null]) {
			return nil;
		} else {
			return photo;
		}
	} else {
		return nil;
	}
}


@end
