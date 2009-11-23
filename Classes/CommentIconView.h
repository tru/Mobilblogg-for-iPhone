//
//  CommentIconView.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface CommentIconView : UIControl {
	TTImageView *_image;
	NSUInteger _numberComments;
	TTLabel *_commentLabel;
}

-(id)initWithNumComments:(NSUInteger)numberComments;
-(id)initWithNumComments:(NSUInteger)numberComments andColorBlack:(BOOL)black;

@property (nonatomic) NSUInteger numberComments;

@end
