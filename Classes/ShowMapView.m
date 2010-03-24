//
//  ShowMapView.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2010-03-20.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import "ShowMapView.h"
#import "MapAnnotationView.h"
#import <Three20/Three20.h>

@implementation ShowMapView

-(MKAnnotationView *)viewForAnnotation:(id <MKAnnotation>)annotation
{
	TTDINFO(@"viewForAnnotation!");
	return [[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation title]];
}

@end
