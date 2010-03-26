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
		_centerPhoto = [query objectForKey:@"centerPhoto"];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																								target:self
																								action:@selector(done)] autorelease];
		
		self.title = NSLocalizedString(@"Photos on map", nil);
		[_photos retain];
		[_centerPhoto retain];
	}
	
	return self;
}

-(void)done
{
	[self dismissModalViewControllerAnimated:YES];
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
	if (_centerPhoto) {
		region.center = _centerPhoto.coordinate;
		region.span.longitudeDelta = 0.1;
		region.span.latitudeDelta = 0.1;
	} else {
		region.center = centerCo;
		region.span.longitudeDelta = (maxlong - minlong) * 1.5;
		region.span.latitudeDelta = (maxlat - minlat) * 1.5;
	}
		
	[_mapView setRegion:region animated:YES];
}

-(void)mapView:(MKMapView*)mapView didAddAnnotationViews:(NSArray *)views
{
	for (MKAnnotationView *annView in views) {
		MBPhoto *p = (MBPhoto*)annView.annotation;
		if (_centerPhoto.photoId == p.photoId) {
			TTDINFO(@"Setting center photo");
			[mapView selectAnnotation:annView.annotation animated:NO];
		}
	}
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	TTDINFO("tapped!");
	MBPhoto *p = (MBPhoto*)[view annotation];
	TTURLAction *ac = [TTURLAction actionWithURLPath:@"mb://photoinfo"];
	[ac applyAnimated:YES];
	[ac applyQuery:[NSDictionary dictionaryWithObject:p forKey:@"photo"]];
	[[TTNavigator navigator] openURLAction:ac];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MBPhoto *p = (MBPhoto*)annotation;	
	NSString *ident = [NSString stringWithFormat:@"%d", p.photoId];
	
	TTDINFO(@"View for annotation %@", ident);
	
	MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:ident];
	if (!view) {
		view = [[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ident];
	}
		
	return view;
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: ShowMapController");
	[_mapView release];
	[_photos release];
	if (_centerPhoto) {
		[_centerPhoto release];
	}
	[super dealloc];
}

@end
