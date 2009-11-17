//
//  CommentModel.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-15.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "MBCommentResponse.h"

@interface CommentModel : TTURLRequestModel<TTURLRequestDelegate> {
	NSUInteger _photoId;
	MBCommentResponse *_response;
}

-(id)initWithPhotoId:(NSUInteger)photoId;
-(NSArray *)results;

@end
