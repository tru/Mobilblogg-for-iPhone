//
//  ConfigController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ConfigController : UIViewController {
	UITextField *username;
	UITextField *password;
}

@property (nonatomic,retain) IBOutlet UITextField *username;
@property (nonatomic,retain) IBOutlet UITextField *password;

@end
