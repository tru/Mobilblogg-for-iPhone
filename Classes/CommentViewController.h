//
//  CommentViewController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface CommentPostController : TTPostController
@end

@interface CommentPostResponse : NSObject<TTURLResponse>
@end

@interface CommentViewController : TTTableViewController<TTPostControllerDelegate,TTURLRequestDelegate> {
	NSUInteger _photoId;
	CommentPostController *_postCtrl;
}
-(id)initWithId:(id)pId;

@end
