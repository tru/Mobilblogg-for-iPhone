//
//  NewConfigController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-09.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Three20/Three20.h>
#import "MBLogin.h"

@interface UserConfigController : TTTableViewController<UITextFieldDelegate,MBLoginDelegateProtocol> {
	TTActivityLabel *_activity;
	UITextField *_username;
	UITextField *_password;
	UISwitch *_alwaysShowCaptionSwitch;
	UISwitch *_savePhoto;
	BOOL _fromConfig;
}

-(void)saveSettings;

@end
