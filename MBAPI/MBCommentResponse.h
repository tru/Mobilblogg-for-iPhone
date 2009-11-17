//
//  MBComments.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-15.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "MBConnectionRoot.h"
#import "MBComment.h"

@interface MBCommentResponse : NSObject<TTURLResponse> {
	NSMutableArray *_comments;
}

@property (nonatomic,retain) NSMutableArray *comments;

-(id)init;

@end
