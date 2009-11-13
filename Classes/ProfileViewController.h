//
//  ProfileViewController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-13.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBUser.h"
#import <Three20/Three20.h>

@interface ProfileViewController : TTTableViewController<MBUserDelegateProtocol> {
	MBUser *_user;
	TTTableImageItem *_userImageItem;
	TTTableStyledTextItem *_userTextItem;
	TTActivityLabel *_activity;
}

-(id)initWithUserName:(NSString*)userName;

@end
