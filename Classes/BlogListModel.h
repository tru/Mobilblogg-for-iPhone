//
//  BlogListModel.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "MBURLResponse.h"

@interface BlogListModel : TTURLRequestModel <TTURLRequestDelegate> {
	MBURLResponse *_response;
	NSUInteger _page;
	NSDictionary *_arguments;
}

-(id)initWithArguments:(NSDictionary *)arguments;
-(NSUInteger)totalResultsAvailableOnServer;
-(NSArray*)results;

@end

@protocol BlogListModelProtocol
-(NSArray*)results;
@end