//
//  MBPhotoItemCell.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "MBPhoto.h"
#import "CommentLabel.h"

@interface MBPhotoItemCell : TTTableLinkedItemCell {
	CommentLabel *_commentView;
	TTImageView *_imageView2;
	MBPhoto	*_photo;
}

@property(nonatomic,readonly,retain) UILabel* subtitleLabel;
@property(nonatomic,readonly,retain) TTImageView* imageView2;

@end
