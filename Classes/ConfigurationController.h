//
//  ConfigurationController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-12-19.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface ConfigurationController : TTTableViewController {
	UISwitch *_alwaysShowCaptionSwitch;
	UISwitch *_savePhoto;
}

-(id)init;

@end
