//
//  MBComment.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-15.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "MBUser.h"

@interface MBComment : NSObject {
	NSString *_user;
	TTStyledText *_comment;
	NSString *_commentPlain;
	NSUInteger _photoId;
	NSDate *_date;
	NSString *_imageURL;
	NSString *_URL;
	UIEdgeInsets _padding;
}

@property (nonatomic, copy) NSString *commentPlain;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, retain) TTStyledText *comment;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic) NSUInteger photoId;
@property (nonatomic, copy) NSString *URL;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic) UIEdgeInsets padding;

@end
