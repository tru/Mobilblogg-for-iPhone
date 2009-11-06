//
//  ConfigController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBLogin.h"


@interface ConfigController : UIViewController<MBLoginDelegateProtocol> {
	UITextField *username;
	UITextField *password;
	UIActivityIndicatorView *_activity;
}

@property (nonatomic,retain) IBOutlet UITextField *username;
@property (nonatomic,retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;

@end
