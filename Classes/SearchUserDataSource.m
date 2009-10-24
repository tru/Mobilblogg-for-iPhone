//
//  SearchUserDataSource.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "SearchUserDataSource.h"

@implementation SearchUserDataSource

-(id)init
{
	self = [super init];
	
	_isLoading = NO;
	return self;
}

-(void)search:(NSString *)text
{
	if ([text length]) {
		[self dataStartedLoad];
		[self.items removeAllObjects];
		[self.items addObject:[TTTableTextItem itemWithText:[NSString stringWithFormat:@"Goto user: %@", text]
													URL:[@"mb://listblog/" stringByAppendingString:text]
						   ]
		 ];
		[self dataFinishedLoad];
	}
}
	 

#pragma mark TTModel
	 
- (NSMutableArray*)delegates {
	if (!_delegates) {
		_delegates = TTCreateNonRetainingArray();
	}	
	return _delegates;
}

- (id<TTModel>)model {
	return self;
}

- (BOOL)isLoading {
	return _isLoading;
}

- (BOOL)isLoadingMore {
   return NO;

}

- (BOOL)isLoaded {
	return !!_items;
}

- (BOOL)isEmpty {
	return !_items.count;
}

- (BOOL)isOutdated {
	return NO;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {}

- (void)dataFinishedLoad {
	_isLoading = NO;
	[_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
}

- (void)dataStartedLoad {
	_isLoading = YES;
	[_delegates perform:@selector(modelDidStartLoad:) withObject:self];
}

-(void)invalidate:(BOOL)erase
{
}

-(void)cancel
{
}

@end
