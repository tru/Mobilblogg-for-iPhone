//
//  StartupScreenController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2010-03-01.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Three20/Three20.h>

#import "MBLogin.h"

@interface StartupScreenController : TTViewController {
	TTActivityLabel *_activity;
	MBLogin *_login;
}

-(void)animationDidStop;

@end
