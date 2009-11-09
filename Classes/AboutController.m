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
					   NSLocalizedString(@"MobilBlogg.nu for iPhone by:",nil),
					   [TTTableTextItem itemWithText:@"Tobias Rundström" URL:@"mb://listblog/tru"],
					   NSLocalizedString(@"Server side code by:", nil),
					   [TTTableTextItem itemWithText:@"Henrik Öhman" URL:@"mb://listblog/fivestar"],
					   NSLocalizedString(@"BETA testers:", nil),
					   [TTTableTextItem itemWithText:@"Tester1"],
					   NSLocalizedString(@"Third party code:", nil),
					   [TTTableTextItem itemWithText:@"Three20 by Joe Hewitt" URL:@"http://github.com/joehewitt/three20"],
					   [TTTableTextItem itemWithText:@"SBJSON by Stig Brautaset" URL:@"http://code.google.com/p/json-framework/"],
					   [TTTableTextItem itemWithText:@"SFHFKeychainUtils by Buzz Andersen" URL:@"http://github.com/ldandersen/scifihifi-iphone"],
					   [TTTableTextItem itemWithText:@"Google Mac Toolbox by Google Inc" URL:@"http://code.google.com/p/google-toolbox-for-mac/"],
					   nil];

}

@end
