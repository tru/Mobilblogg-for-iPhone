//
//  MBPhoto.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MBPhoto : NSObject {
	NSUInteger photoId;
	NSString *user;
	NSString *caption;
	NSUInteger x, y;
	NSURL *smallURL;
	NSURL *largeURL;
}

@property (nonatomic) NSUInteger photoId;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *caption;
@property (nonatomic) NSUInteger x;
@property (nonatomic) NSUInteger y;
@property (nonatomic, copy) NSURL *smallURL;
@property (nonatomic, copy) NSURL *largeURL;

@end
