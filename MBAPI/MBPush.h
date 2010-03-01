//
//  MBPush.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2010-02-15.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBConnectionRoot.h"


@interface MBPush : NSObject<MBConnectionRootDelegateProtocol> {
	NSString *_token;
	NSString *_name;
	MBConnectionRoot *_conn;
}

-(id)initWithUsername:(NSString *)name andToken:(NSString *)token;

@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *name;

@end
