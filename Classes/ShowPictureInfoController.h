//
//  ShowPictureInfoController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-09.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Three20/Three20.h>
#import "MBPhoto.h"
#import "MBUser.h"

#import <MapKit/MapKit.h>

@interface ShowPictureInfoController : TTTableViewController<MBUserDelegateProtocol,MKReverseGeocoderDelegate> {
	MBPhoto *_photo;
	TTTableImageItem *_userItem;
	TTTableLongTextItem *_positionItem;
}

@end
