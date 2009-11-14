//
//  GotoUser.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-09.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "MBUser.h"

@interface GotoUserTextField : UITextField {
}
@end


@interface GotoUserController : TTTableViewController<UITextFieldDelegate, MBUserDelegateProtocol> {
	UITextField *_username;
	NSMutableDictionary *_users;
	BOOL _shouldEnd;
}

-(void)lookupUser;
-(void)gotoUser;

@end
