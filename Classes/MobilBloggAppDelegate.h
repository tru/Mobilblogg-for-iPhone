//
//  MobilBloggAppDelegate.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright Purple Scout 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootController.h"
#import "MBLogin.h"

@interface MobilBloggStyleSheet : TTDefaultStyleSheet {
}
-(UIColor*)navigationBarTintColor;
@end


@interface MobilBloggAppDelegate : NSObject <UIApplicationDelegate,MBLoginDelegateProtocol> {
}

@end

