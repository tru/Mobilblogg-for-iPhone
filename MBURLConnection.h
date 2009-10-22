//
//  MBURLConnection.h
//  mblogapi
//
//  Created by Tobias Rundström on 2009-10-21.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSON.h"

@interface MBURLConnection : NSURLConnection {
	NSMutableData *_data;
	SEL _cbAction;
	id _delegate;
	SBJSON *_json;
}

-(id)initWithRequest:(NSURLRequest*)request delegate:(id)target andAction:(SEL)action;

@end

@protocol MBURLConnectionProtocol
-(void)MBURLConnection:(MBURLConnection*)conn gotWrongCredentials:(NSError*)error;
-(void)MBURLConnection:(MBURLConnection*)conn gotParseError:(NSError*)error;
-(void)MBURLConnection:(MBURLConnection*)conn gotServerError:(NSError*)error;
@end