//
//  MBSalt.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-12-14.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBConnectionRoot.h"
#import <Three20/Three20.h>

@protocol MBSaltDelegateProtocol

-(void)saltDidFailWithError:(NSError*)err;
-(void)saltDidSucceed:(NSString*)salt;

@end

@interface MBSalt : NSObject<MBConnectionRootDelegateProtocol> {
	id _delegate;
	MBConnectionRoot *_connRoot;
}

-(id)initWithUsername:(NSString *)username;

@property (nonatomic,retain) id<MBSaltDelegateProtocol> delegate;

@end
