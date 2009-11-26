//
//  MBImageUtils.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBImageUtils.h"
#import <Three20/Three20.h>

#include <math.h>

@implementation MBImageScaleOperation

@synthesize delegate = _delegate;

-(id)initWithImage:(UIImage *)image andTargetSize:(CGSize)targetSize
{
	self = [super init];
	_image = [image retain];
	_size = targetSize;
	return self;
}

-(void)main
{
	UIImage *ret = [MBImageUtils image:_image scaledToSize:_size];
	[_delegate performSelectorOnMainThread:@selector(imageResized:) withObject:ret waitUntilDone:YES];
	[ret release];
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: MBImageScaleOperation");
	[_image release];
	[super dealloc];
}

@end


@implementation MBImageUtils

+(CGSize)imageSize:(CGSize)currentSize withAspect:(CGSize)targetSize
{
	float hfactor = currentSize.width / targetSize.width;
	float vfactor = currentSize.height / targetSize.height;
	
	float factor = MAX(hfactor, vfactor);
	
	float newWidth = currentSize.width / factor;
	float newHeight = currentSize.height / factor;
	
	return CGSizeMake(newWidth, newHeight);
}

static inline double radians (double degrees) {return degrees * M_PI/180;}

+(UIImage*)image:(UIImage*)image scaledToSize:(CGSize)newSize
{
	CGSize targetSize = [MBImageUtils imageSize:image.size withAspect:newSize];
	
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	CGImageRef imageRef = [image CGImage];
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
	
	if (bitmapInfo == kCGImageAlphaNone) {
		bitmapInfo = kCGImageAlphaNoneSkipLast;
	}
	
	CGContextRef bitmap;
	
	if (image.imageOrientation == UIImageOrientationUp || image.imageOrientation == UIImageOrientationDown) {
		bitmap = CGBitmapContextCreate(NULL,
									   targetWidth,
									   targetHeight,
									   CGImageGetBitsPerComponent(imageRef),
									   CGImageGetBytesPerRow(imageRef),
									   colorSpaceInfo,
									   bitmapInfo);
		
	} else {
		bitmap = CGBitmapContextCreate(NULL,
									   targetHeight,
									   targetWidth,
									   CGImageGetBitsPerComponent(imageRef),
									   CGImageGetBytesPerRow(imageRef),
									   colorSpaceInfo,
									   bitmapInfo);
		
	}       
	
	if (image.imageOrientation == UIImageOrientationLeft) {
		CGContextRotateCTM (bitmap, radians(90));
		CGContextTranslateCTM (bitmap, 0, -targetHeight);
		
	} else if (image.imageOrientation == UIImageOrientationRight) {
		CGContextRotateCTM (bitmap, radians(-90));
		CGContextTranslateCTM (bitmap, -targetWidth, 0);
		
	} else if (image.imageOrientation == UIImageOrientationUp) {
		// NOTHING
	} else if (image.imageOrientation == UIImageOrientationDown) {
		CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
		CGContextRotateCTM (bitmap, radians(-180.));
	}
	
	CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage* newImage = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return newImage; 
}

#if 0
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
	CGSize calcSize = [MBImageUtils imageSize:image.size withAspect:newSize];
		
	// Create a graphics image context
	UIGraphicsBeginImageContext(calcSize);
	
	// Tell the old image to draw in this new context, with the desired
	// new size
	[image drawInRect:CGRectMake(0,0,calcSize.width,calcSize.height)];
	
	// Get the new image from the context
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End the context
	UIGraphicsEndImageContext();
	
	// Return the new image.
	return newImage;
}
#endif

@end
