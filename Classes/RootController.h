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


@interface RootController : TTTableViewController<UIActionSheetDelegate,
												  UINavigationControllerDelegate,
												  UIImagePickerControllerDelegate,
												  MBLoginDelegateProtocol>{
	TTActivityLabel *_activity;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
