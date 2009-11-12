//
//  BlogListThumbsDataSource.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-12.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "BlogListModel.h"

@interface BlogListThumbsDataSource : NSObject <TTPhotoSource> {
    BlogListModel *model;
    
    // Backing storage for TTPhotoSource properties.
    NSString *albumTitle;
    int totalNumberOfPhotos;
}
-(id)initWithModel:(BlogListModel *)theModel;
- (id<TTModel>)underlyingModel;

@end
