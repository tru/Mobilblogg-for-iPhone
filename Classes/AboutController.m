//
//  AboutController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-09.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "AboutController.h"



@implementation AboutController

-(id)init
{
	self = [super init];
	self.tableViewStyle = UITableViewStyleGrouped;
	return self;
}

-(void)createModel
{
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
					   NSLocalizedString(@"MobilBlogg.nu for iPhone",nil),
					   [TTTableTextItem itemWithText:[NSString stringWithFormat:@"Version: %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]] 
																			URL:@"http://opensource.purplescout.se/projects/roadmap/mbiphone"],
					   NSLocalizedString(@"Developed by:", nil),
					   [TTTableTextItem itemWithText:@"Tobias Rundström" URL:@"mb://listblog/tru"],
					   [TTTableTextItem itemWithText:@"PurpleScout AB" URL:@"http://www.purplescout.com/"],
					   NSLocalizedString(@"Server side code by:", nil),
					   [TTTableTextItem itemWithText:@"Henrik Öhman" URL:@"mb://listblog/fivestar"],
					   NSLocalizedString(@"Application Icon:", nil),
					   [TTTableTextItem itemWithText:@"Fredrik Johansson" URL:@"mb://listblog/jolt"],
					   NSLocalizedString(@"Third party code:", nil),
					   [TTTableTextItem itemWithText:@"Three20 by Facebook" URL:@"http://github.com/facebook/three20"],
					   [TTTableTextItem itemWithText:@"SBJSON by Stig Brautaset" URL:@"http://code.google.com/p/json-framework/"],
					   [TTTableTextItem itemWithText:@"SFHFKeychainUtils by Buzz Andersen" URL:@"http://github.com/ldandersen/scifihifi-iphone"],
					   [TTTableTextItem itemWithText:@"Google Mac Toolbox by Google Inc" URL:@"http://code.google.com/p/google-toolbox-for-mac/"],
					   nil];

}

@end
