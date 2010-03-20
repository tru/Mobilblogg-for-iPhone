//
//  ShowMapController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2010-03-17.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import "ShowMapController.h"
#import "MBPhoto.h"
#import "MapAnnotationView.h"

@implementation ShowMapController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query
{
	self = [super init];
	
	if (self) {
		_photos = [query objectForKey:@"photos"];
		[_photos retain];
	}
	
	return self;
}

-(void)loadView
{
	[super loadView];
	_mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
	_mapView.delegate = self;
	[self.view addSubview:_mapView];
	
}

-(void)viewDidLoad
{
	CLLocationCoordinate2D centerCo;
	centerCo.longitude = 0.0;
	centerCo.latitude = 0.0;

	CLLocationDegrees maxlong = LONG_MIN, maxlat = LONG_MIN;
	CLLocationDegrees minlong = LONG_MAX, minlat = LONG_MAX;
	
	CGFloat annotations = 0.0;
	
	/* Add photos */
	for (MBPhoto *photo in _photos) {
		if (photo.location) {
			[_mapView addAnnotation:photo];
			
			CLLocationCoordinate2D photoCo = photo.coordinate;
			
			centerCo.longitude += photo.coordinate.longitude;
			centerCo.latitude += photo.coordinate.latitude;
			annotations += 1.0;
			
			if (photoCo.longitude > maxlong) {
				maxlong = photoCo.longitude;
			}
			
			if (photoCo.latitude > maxlat) {
				maxlat = photoCo.latitude;
			}
			
			if (photoCo.longitude < minlong) {
				minlong = photoCo.longitude;
			}
			
			if (photoCo.latitude < minlat) {
				minlat = photoCo.latitude;
			}
			
		}
	}
	
	centerCo.longitude = centerCo.longitude / annotations;
	centerCo.latitude = centerCo.latitude / annotations;
	
	MKCoordinateRegion region;
	region.center = centerCo;
	region.span.longitudeDelta = (maxlong - minlong) * 1.5;
	region.span.latitudeDelta = (maxlat - minlat) * 1.5;
		
	[_mapView setRegion:region animated:YES];
	
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	return [[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: ShowMapController");
	[_mapView release];
	[_photos release];
	[super dealloc];
}

@end
