//
//  MBUser.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-12.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBConnectionRoot.h"

@class MBUser;

@protocol MBUserDelegateProtocol

@optional
-(void)MBUserDidReceiveInfo:(MBUser*)user;
-(void)MBUser:(MBUser*)user didFailWithError:(NSError*)err;

@end

@interface MBUser : NSObject<MBConnectionRootDelegateProtocol> {
	NSString *_name;
	NSString *_avatarURL;
	NSString *_info;
	id _delegate;
	MBConnectionRoot *_conn;
	
}

-(id)initWithUserName:(NSString *)userName;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *avatarURL;
@property (nonatomic, copy, readonly) NSString *info;
@property (nonatomic, assign) id<MBUserDelegateProtocol> delegate;

@end
