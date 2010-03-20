//
//  MBImageUtils.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBImageUtils.h"
#import <Three20/Three20.h>
#import "EXF.h"
#import "EXFUtils.h"

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
	if (_delegate) {
		[_delegate release];
	}
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

// Helper methods for location conversion 
+(NSMutableArray*)createLocArray:(double)val{ 
    val = fabs(val); 
    NSMutableArray* array = [[NSMutableArray alloc] init]; 
    double deg = (int)val; 
    [array addObject:[NSNumber numberWithDouble:deg]]; 
    val = val - deg; 
    val = val * 60; 
    double minutes = (int) val; 
    [array addObject:[NSNumber numberWithDouble:minutes]]; 
    val = val - minutes; 
    val = val * 60; 
    double seconds = val; 
    [array addObject:[NSNumber numberWithDouble:seconds]]; 
    return array; 
} 

+(void)populateGPS:(EXFGPSLoc*)gpsLoc andLocarray:(NSArray*)locArray{ 
    long numDenumArray[2]; 
    long* arrPtr = numDenumArray; 
    [EXFUtils convertRationalToFraction:&arrPtr :[locArray objectAtIndex:0]]; 
    EXFraction* fract = [[EXFraction alloc] initWith:numDenumArray[0]:numDenumArray[1]]; 
    gpsLoc.degrees = fract; 
    [fract release]; 
    [EXFUtils convertRationalToFraction:&arrPtr :[locArray objectAtIndex:1]]; 
    fract = [[EXFraction alloc] initWith:numDenumArray[0] :numDenumArray[1]]; 
    gpsLoc.minutes = fract; 
    [fract release]; 
    [EXFUtils convertRationalToFraction:&arrPtr :[locArray objectAtIndex:2]]; 
    fract = [[EXFraction alloc] initWith:numDenumArray[0] :numDenumArray[1]]; 
    gpsLoc.seconds = fract; 
    [fract release];
}

+(NSData*) geotagImage:(UIImage*)image withLocation:(CLLocation*)imageLocation {
    NSData* jpegData =  UIImageJPEGRepresentation(image, 0.8);
    EXFJpeg* jpegScanner = [[EXFJpeg alloc] init];
    [jpegScanner scanImageData: jpegData];
    EXFMetaData* exifMetaData = jpegScanner.exifMetaData;
    // end of helper methods 
    // adding GPS data to the Exif object 
    NSMutableArray* locArray = [self createLocArray:imageLocation.coordinate.latitude]; 
    EXFGPSLoc* gpsLoc = [[EXFGPSLoc alloc] init]; 
    [self populateGPS:gpsLoc andLocarray:locArray]; 
    [exifMetaData addTagValue:gpsLoc forKey:[NSNumber numberWithInt:EXIF_GPSLatitude] ]; 
    [gpsLoc release]; 
    [locArray release]; 
    locArray = [self createLocArray:imageLocation.coordinate.longitude]; 
    gpsLoc = [[EXFGPSLoc alloc] init]; 
    [self populateGPS:gpsLoc andLocarray:locArray]; 
    [exifMetaData addTagValue:gpsLoc forKey:[NSNumber numberWithInt:EXIF_GPSLongitude] ]; 
    [gpsLoc release]; 
    [locArray release];
    NSString* ref;
    if (imageLocation.coordinate.latitude <0.0)
        ref = @"S"; 
    else
        ref =@"N"; 
    [exifMetaData addTagValue: ref forKey:[NSNumber numberWithInt:EXIF_GPSLatitudeRef] ]; 
    if (imageLocation.coordinate.longitude <0.0)
        ref = @"W"; 
    else
        ref =@"E"; 
    [exifMetaData addTagValue: ref forKey:[NSNumber numberWithInt:EXIF_GPSLongitudeRef] ]; 
    NSMutableData* taggedJpegData = [[NSMutableData alloc] init];
    [jpegScanner populateImageData:taggedJpegData];
    [jpegScanner release];
    return [taggedJpegData autorelease];
}



@end
