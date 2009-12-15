//
//  UploaderViewController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

#import "UploaderPermViewController.h"

@interface UploadResponse : NSObject<TTURLResponse>
@end


@interface UploaderViewController : TTTableViewController<TTPostControllerDelegate, TTURLRequestDelegate> {
	TTTableImageItem *_imageItem;
	UITextField *_captionField;
	UITextField *_bodyField;
	UITextField *_permField;
	TTActivityLabel *_activity;
	UIImage *_image;
	NSString *_imageURL;
	NSString *_secretWord;
	NSOperationQueue *_queue;
	UploaderPermViewController *_permCtrl;
	BOOL _uploading;
}

-(id)initWithUIImage:(UIImage *)img;

@end
