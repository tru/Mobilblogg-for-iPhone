//
//  MapAnnotationView.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2010-03-20.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import "MapAnnotationView.h"
#import "MBPhoto.h"

@implementation MapAnnotationView

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self) {
		TTDINFO(@"MapAnnotationView");
		self.canShowCallout = YES;
	}
	return self;
}

-(UIView*)leftCalloutAccessoryView
{
	TTImageView *imgView = [[TTImageView alloc] init];
	
	imgView.frame = CGRectMake(0, 0, 30, 30);
	imgView.autoresizesToImage = NO;
	imgView.defaultImage = TTIMAGE(@"bundle://empty.png");
	
	MBPhoto *p = (MBPhoto*)self.annotation;
	imgView.urlPath = p.thumbURL;
	
	return [imgView autorelease];
}

@end
