//
//  MBPhoto.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Three20/Three20.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MBPhoto : NSObject<TTPhoto,MKAnnotation> {
	id<TTPhotoSource> _photoSource;
	NSUInteger _photoId;
	NSString *_thumbURL;
	NSString *_smallURL;
	NSString *_URL;
	CGSize _size;
	NSInteger _index;
	NSString *_caption;
	NSString *_user;
	NSDate *_date;
	NSUInteger _numcomments;
	NSString *_body;
	CLLocation *_location;
}

@property (nonatomic, copy) NSString *user;
@property (nonatomic) NSUInteger photoId;
@property (nonatomic, copy) NSString *smallURL;
@property (nonatomic, copy) NSString *thumbURL;
@property (nonatomic, copy) NSString *URL;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *body;
@property (nonatomic) NSUInteger numcomments;
@property (nonatomic, retain) CLLocation *location;

#pragma mark MKAnnotation
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(NSString*)title;
-(NSString*)subtitle;

-(id)initWithPhotoId:(NSUInteger)pId;
+(MBPhoto*)photoWithPhotoId:(NSUInteger)pId;

@end
