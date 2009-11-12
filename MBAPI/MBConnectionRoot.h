//
//  MBConnectionRoot.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-12.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MBConnectionRoot;

@protocol MBConnectionRootDelegateProtocol

-(void)MBConnectionRoot:(MBConnectionRoot*)connection didFailWithError:(NSError*)err;
-(void)MBConnectionRoot:(MBConnectionRoot*)connection didFinishWithObject:(id)object;

@end


@interface MBConnectionRoot : NSObject {
	NSMutableData *_data;
	NSURL *_url;
	id _delegate;
}

-(id)initWithArguments:(NSDictionary *)arguments;

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) id<MBConnectionRootDelegateProtocol> delegate;

@end
