//
//  FavoritesDataSource.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-14.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "FavoritesDataSource.h"
#import "MBStore.h"
#import "MBErrorCodes.h"


@implementation FavoriteUser

@synthesize userItem = _item;

@end


@implementation FavoritesDataSource

-(id)initWithInputField:(UIControl*)inputField andDelegate:(id)delegate
{
	self = [super init];
	_delegate = delegate;
	_sections = [[NSMutableArray alloc] init];
	_items = [[NSMutableArray alloc] init];
	
	[_sections addObject:NSLocalizedString(@"Goto user", nil)];
	[_items addObject:[NSArray arrayWithObject:inputField]];
	_itemStyle = [TTImageStyle styleWithImageURL:nil
									defaultImage:nil
									 contentMode:UIViewContentModeScaleAspectFill
											size:CGSizeMake(40, 40)
											next:TTSTYLE(rounded)];

	
	[self loadFavorites];
	
	return self;
}

-(TTTableImageItem*)favoriteItem:(NSString*)user
{
	TTTableImageItem *item = [TTTableImageItem itemWithText:user];
	item.imageStyle = _itemStyle;
	item.imageURL = @"http://mobilblogg.nu/cache/ttf/011086f0e011367f52.gif";
	item.URL = [NSString stringWithFormat:@"mb://profile/%@", user];
	
	FavoriteUser *fuser = [[FavoriteUser alloc] initWithUserName:user];
	fuser.userItem = item;
	fuser.delegate = self;
	
	return item;
}

-(void)MBUserDidReceiveInfo:(MBUser *)user
{
	((FavoriteUser*)user).userItem.imageURL = user.avatarURL;
	[_delegate dataSourceUpdate];
	
}

-(void)MBUser:(MBUser *)user didFailWithError:(NSError *)err
{
	if ([err domain] == MobilBloggErrorDomain && [err code] == MobilBloggErrorCodeNoSuchUser) {
		NSLog(@"No user %@", user.name);
	}
}

-(void)loadFavorites
{
	NSArray *favorites = [MBStore getObjectForKey:@"favoriteUsers"];
	
	NSMutableArray *favoritesList = [[NSMutableArray alloc] init];
	
	/* Add section header */
	if (!favorites || ([favorites count] < 1))
		return;
		
	if ([_sections count] < 2) {
		[_sections addObject:NSLocalizedString(@"Favorite users", nil)];
	}
	
	for (NSString *user in favorites) {
		[favoritesList addObject:[self favoriteItem:user]];
	}
	
	[_items addObject:favoritesList];
	
	[favoritesList release];
}

-(void)goUser:(NSString *)user
{
	NSMutableArray *favorites = [[MBStore getObjectForKey:@"favoriteUsers"] mutableCopy];
	
	/* put the current user first */
	NSMutableArray *newlist = [NSMutableArray arrayWithObject:user];
	for (NSString *fav in favorites) {
		if (![fav isEqualToString:user] && ([newlist count] < 5)) {
			[newlist addObject:fav];
		}
	}
	
	[MBStore setObject:newlist forKey:@"favoriteUsers"];
	[favorites release];
	
	if ([_items count] == 2) {
		[_items removeObjectAtIndex:1];
	}
	[self loadFavorites];
	
	[_delegate dataSourceUpdate];
}

-(void)dataSourceUpdate
{
}

@end
