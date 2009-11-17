//
//  MBCommentItemCell.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-16.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface MBCommentItemCell : TTTableLinkedItemCell {
	UILabel* _titleLabel;
	UILabel* _timestampLabel;
	TTImageView* _imageView2;
	TTStyledTextLabel *_styledText;
}

@property (nonatomic, readonly, retain) UILabel *titleLabel;
@property (nonatomic, readonly, retain) UILabel *timestampLabel;
@property (nonatomic, readonly, retain) TTImageView *imageView2;
@property (nonatomic, readonly, retain) TTStyledTextLabel *styledText;

@end
