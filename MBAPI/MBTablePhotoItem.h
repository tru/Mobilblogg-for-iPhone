//
//  MBTablePhotoItem.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-12.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "MBPhoto.h"

@interface MBTablePhotoItem : TTTableSubtitleItem {
	MBPhoto *_photo;
}

@property (readonly, retain, nonatomic) MBPhoto *photo;

-(id)initWithMBPhoto:(MBPhoto*)photo;

@end
