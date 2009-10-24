//
//  RootController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "RootController.h"
#import "MBStore.h"


@implementation RootController

- (id)init {
	self = [super init];
	
	self.title = @"MobilBlog.nu";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" 
																			  style:UIBarButtonItemStyleBordered 
																			 target:nil action:nil] autorelease];
	self.tableViewStyle = UITableViewStyleGrouped;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera 
																						   target:self 
																						   action:@selector(camera)];
	
	return self;
}


- (void)createModel
{
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
					   @"My pages",
					   [TTTableTextItem itemWithText:@"My Blog" URL:[@"mb://listblog/" stringByAppendingString:[MBStore getUserName]]],
					   @"MobilBlogg",
					   [TTTableTextItem itemWithText:@"Go to User" URL:@"mb://searchuser"],
					   @"Settings",
					   [TTTableTextItem itemWithText:@"Settings" URL:@"mb://configure"],
					   nil];
}

- (void)viewDidLoad {
	NSString *username = [MBStore getUserName];
	if (!username) {
		[[TTNavigator navigator] openURL:@"mb://configure" animated:NO];
	} else {
		NSLog(@"Have username %@", username);
	}
}

- (void)dealloc {
    [super dealloc];
}


#pragma mark Camera

- (void)camera
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissModalViewControllerAnimated:YES];
}

@end
