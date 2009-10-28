//
//  MBPhoto.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Three20/Three20.h>

@interface MBPhoto : NSObject<TTPhoto> {
	id<TTPhotoSource> _photoSource;
	NSUInteger _photoId;
	NSString *_thumbURL;
	NSString *_smallURL;
	NSString *_URL;
	CGSize _size;
	NSInteger _index;
	NSString *_caption;
	NSString *_user;
}

@property (nonatomic, copy) NSString *user;
@property (nonatomic) NSUInteger photoId;
@property (nonatomic, copy) NSString *smallURL;
@property (nonatomic, copy) NSString *thumbURL;
@property (nonatomic, copy) NSString *URL;

+(MBPhoto*)getPhotoById:(NSUInteger)pId;
+(void)storePhoto:(MBPhoto*)photo;
-(id)initWithPhotoId:(NSUInteger)pId;
+(NSArray*)getCurrentBlogList;
+(NSArray*)setCurrentBlogList:(NSArray *)blogList;


@end