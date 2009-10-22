//
//  MBAPI.h
//  mblogapi
//
//  Created by Tobias Rundström on 2009-10-20.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBURLConnection.h"

@interface MBAPI : NSObject<MBURLConnectionProtocol> {
	id _delegate;
	NSString *username;
	NSString *password;
	NSMutableDictionary *_connDict;
}

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

-(id)initWithDelegate:(id)delegate;
-(void)connectWithUsername:(NSString *)user andPassword:(NSString *)pass;
-(void)startPageList:(id)delegate andSelector:(SEL)action;
-(void)pictureInfo:(NSNumber *)identifier delegate:(id)delegate andSelector:(SEL)action;
-(void)listBlogg:(NSString *)blog delegate:(id)delegate andSelector:(SEL)action;

@end
