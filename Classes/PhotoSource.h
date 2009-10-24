//
//  PhotoSource.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Three20/Three20.h>

@interface PhotoSource : TTListDataSource<TTPhotoSource> {
	NSMutableArray *_delegates;
	BOOL _isLoading;
	NSString *_title;
}

-(id)initWithPhotos:(NSArray *)photos;
-(void)dataFinishedLoad;
-(void)dataStartedLoad;

@end
