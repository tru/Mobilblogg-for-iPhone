//
//  MBImageUtils.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol MBImageScaleOperationDelegateProtocol

-(void)imageResized:(UIImage*)img;

@end


@interface MBImageScaleOperation : NSOperation {
	id _delegate;
	UIImage *_image;
	CGSize _size;
}

-(id)initWithImage:(UIImage*)image andTargetSize:(CGSize)targetSize;

@property (nonatomic, assign) id delegate;

@end


@interface MBImageUtils : NSObject

+(CGSize)imageSize:(CGSize)currentSize withAspect:(CGSize)targetSize;
+(NSData*)geotagImage:(UIImage *)image withLocation:(CLLocation*)imageLlocation;

@end
