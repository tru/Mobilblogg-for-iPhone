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
	CGSize siz = [MBImageUtils imageSize:_image.size withAspect:CGSizeMake(800, 600)];
	UIImage *ret = [_image transformWidth:siz.width height:siz.height rotate:YES];
	TTDINFO(@"NSOperation is done with the image!");
	[_delegate performSelectorOnMainThread:@selector(imageResized:) withObject:ret waitUntilDone:YES];
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

@end
