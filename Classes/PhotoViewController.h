//
//  PhotoViewController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-17.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface PhotoViewController : TTPhotoView {
	TTLabel *_userCaption;
	TTLabel *_userCaptionRight;
}

@end
