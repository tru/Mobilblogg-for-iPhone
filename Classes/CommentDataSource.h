//
//  CommentPhotoSource.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-15.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "MBUser.h"

@interface CommentDataSource : TTListDataSource<MBUserDelegateProtocol> {
	id _delegate;
}

@property (nonatomic,retain) id delegate;

-(void)dataSourceUpdate;

@end
