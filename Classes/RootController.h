//
//  RootController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import "MBLogin.h"
#import "MBUser.h"


@interface RootController : TTTableViewController<UIActionSheetDelegate,
												  UINavigationControllerDelegate,
												  MBUserDelegateProtocol>{
	TTActivityLabel *_activity;
	TTTableImageItem *_myblog;
	TTTableImageItem *_startpage;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
