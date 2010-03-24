//
//  ShowPictureController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import "MBPhoto.h"

@interface ShowPictureController : TTPhotoViewController {
	MBPhoto *_photo;
	UIImage *_commentImage;
}

@end
