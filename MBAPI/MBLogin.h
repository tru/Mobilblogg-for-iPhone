//
//  MBLogin.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-06.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBConnectionRoot.h"
#import "MBSalt.h"

@protocol MBLoginDelegateProtocol

-(void)loginDidFailWithError:(NSError*)err;
-(void)loginDidSucceed;

@end

@interface MBLogin : NSObject<MBConnectionRootDelegateProtocol,MBSaltDelegateProtocol> {
	id _delegate;
	MBConnectionRoot *_connRoot;
	NSString *_password;
	NSString *_username;
	NSString *_passwordHash;
}

-(id)initWithUsername:(NSString *)username andPassword:(NSString *)password;
-(void)doLogin;

@property (nonatomic,retain) id<MBLoginDelegateProtocol> delegate;

@end
