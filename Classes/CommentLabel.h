//
//  CommentLabel.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2010-03-15.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import <Three20/Three20.h>


@interface CommentLabel : UIControl {
	NSUInteger _numberOfComments;
	TTImageView *_image;
	TTLabel *_numbers;
}

-(id)initWithNumberOfComments:(NSUInteger)comments;

@property (nonatomic, assign) NSUInteger numberOfComments;

@end
