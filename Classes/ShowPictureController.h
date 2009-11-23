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
#import "CommentIconView.h"

@interface ShowPictureController : TTPhotoViewController {
	MBPhoto *_photo;
	CommentIconView *_commentIcon;
}


@end
