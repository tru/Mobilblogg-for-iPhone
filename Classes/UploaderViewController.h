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
#import "UploaderImageCell.h"

@interface UploadResponse : NSObject<TTURLResponse>
@end


@interface UploaderViewController : TTTableViewController<TTPostControllerDelegate, TTURLRequestDelegate> {
	UploaderImageItem *_imageItem;
	UITextField *_captionField;
	UITextField *_bodyField;
	UITextField *_permField;
	TTActivityLabel *_activity;
	BOOL _uploading;
	BOOL _showingPostCtrl;
	NSAutoreleasePool *_pool;
	NSString *_secretWord;
}

-(id)initWithNavigatorURL:(NSURL *)url query:(NSDictionary *)dict;
-(void)didSelectPermValue:(NSString *)permText;

@end
