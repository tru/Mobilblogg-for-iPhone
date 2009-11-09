//
//  MBURLResponse.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface MBURLResponse : NSObject <TTURLResponse> {
	NSMutableArray *_entries;
}

@property (nonatomic,retain) NSMutableArray *entries;

-(id)init;

@end
