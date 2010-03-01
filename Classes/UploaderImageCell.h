//
//  MBPhotoItemCell.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface UploaderImageItem : TTTableLinkedItem
{
	UIImage *_image;
}

@property(nonatomic, retain) UIImage *image;

@end


@interface UploaderImageCell : TTTableLinkedItemCell {
	UIImageView *_imgView;
}

@end
