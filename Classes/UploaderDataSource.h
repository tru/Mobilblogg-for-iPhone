//
//  UploaderDataSource.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface UploaderImageCell : TTTableLinkedItemCell {
	TTImageView *_imageView2;
	CGSize _imageSize;
}

@property (retain, nonatomic, readonly) TTImageView *imageView2;

@end

@interface UploaderDataSource : TTListDataSource
@end
