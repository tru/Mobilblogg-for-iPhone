//
//  FavoritesDataSource.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-14.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

#import "MBUser.h"

@interface FavoriteUser : MBUser {
	TTTableImageItem *_item;
}

@property (nonatomic, retain) TTTableImageItem *userItem;

@end

@interface FavoritesDataSource : TTSectionedDataSource<MBUserDelegateProtocol> {
	id _delegate;
}

-(id)initWithInputField:(UIControl *)inputField andDelegate:(id)delegate;
-(void)goUser:(NSString*)user;
-(void)loadFavorites;

-(void)dataSourceUpdate;

@end
