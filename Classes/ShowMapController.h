//
//  ShowMapController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2010-03-17.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Three20/Three20.h>
#import "ShowMapView.h"
#import "MBPhoto.h"


@interface ShowMapController : TTViewController<MKMapViewDelegate> {
	MKMapView *_mapView;
	NSArray *_photos;
	MBPhoto *_centerPhoto;
}

@end
