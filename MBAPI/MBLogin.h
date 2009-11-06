//
//  MBLogin.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-06.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MBLoginDelegateProtocol

-(void)loginDidFailWithError:(NSError*)err;
-(void)loginDidSucceed;

@end

@interface MBLogin : NSObject {
	id _delegate;
	NSMutableData *_responseData;

}

+(id)loginWithUsername:(NSString *)username andPassword:(NSString *)password;

@property (nonatomic,retain) id<MBLoginDelegateProtocol> delegate;

@end
