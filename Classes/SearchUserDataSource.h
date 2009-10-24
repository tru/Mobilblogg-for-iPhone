//
//  SearchUserDataSource.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Three20/Three20.h>

@interface SearchUserDataSource : TTListDataSource<TTModel> {
	NSMutableArray *_delegates;
	BOOL _isLoading;
}

-(void)dataFinishedLoad;
-(void)dataStartedLoad;

@end
