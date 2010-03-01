//
//  RootController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "RootController.h"
#import "MBStore.h"
#import "MBGlobal.h"
#import "UploaderViewController.h"
#import "PhotoPickerController.h"

@implementation RootController

- (id)init {
	self = [super init];
	TTDINFO(@"ALLOC: RootController");
	
	self.title = @"MobilBlogg.nu";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
																			  style:UIBarButtonItemStyleBordered 
																			 target:nil action:nil] autorelease];
	self.tableViewStyle = UITableViewStyleGrouped;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera 
																						   target:self 
																						   action:@selector(camera)];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", nil)
																			 style:UIBarButtonItemStylePlain target:self
																			action:@selector(logout)];
	
	_activity = [[TTActivityLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 480)
												 style:TTActivityLabelStyleBlackBox
												  text:NSLocalizedString(@"Logging in...", nil)];
	_activity.alpha = 0.0;
	return self;
}

- (void)createModel
{
	TTDINFO("createModel called from RootController");
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
					   NSLocalizedString(@"My pages", nil),
					   [TTTableTextItem itemWithText:NSLocalizedString(@"My Start Page", nil)
												 URL:@"mb://listfunction/listStartpage"],
					   [TTTableTextItem itemWithText:NSLocalizedString(@"My Blog",nil) 
												 URL:[@"mb://listblog/" stringByAppendingString:[MBStore getUserName]]],
					   NSLocalizedString(@"MobilBlogg", nil),
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Go to User", nil) URL:@"mb://gotouser"],
					   [TTTableTextItem itemWithText:NSLocalizedString(@"First Page", nil) URL:@"mb://listfunction/listFirstpage"],
					   NSLocalizedString(@"Application", nil),
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Settings", @"Menu item") URL:@"mb://configuration"],
					   [TTTableTextItem itemWithText:NSLocalizedString(@"About", nil) URL:@"mb://about"],
					   nil];
}

- (void)viewDidLoad
{
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ([alertView.title isEqualToString:NSLocalizedString(@"Logout?", nil)]) {
		if (buttonIndex != 0) {
			[MBStore removePassword];
			TTOpenURL(@"mb://userconfmodal/yes");
		}
		
		return;
	}
	if (buttonIndex == 0) {
		/*TODO: make something fancy here later */
	} else {
		TTOpenURL(@"mb://userconfmodal/yes");
	}
}

- (void)dealloc {
	[_activity release];
    [super dealloc];
}

-(void)logout
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Logout?", nil)
													message:NSLocalizedString(@"Do you really want to logout?", nil)
												   delegate:self
										  cancelButtonTitle:NSLocalizedString(@"Forget it", nil)
										  otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
	[alert show];
	[alert release];
}


#pragma mark Camera

- (void)camera
{
	UIActionSheet *askPicture = [[UIActionSheet alloc] initWithTitle:nil 
															delegate:self
												   cancelButtonTitle:nil
											  destructiveButtonTitle:nil
												   otherButtonTitles:nil];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[askPicture addButtonWithTitle:NSLocalizedString(@"Take Picture with Camera", nil)];
	}
	[askPicture addButtonWithTitle:NSLocalizedString(@"Choose from Library", nil)];
	[askPicture addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
	if ([askPicture numberOfButtons] == 3) {
		[askPicture setCancelButtonIndex:2];
	} else {
		[askPicture setCancelButtonIndex:1];
	}
	[askPicture showInView:[self view]];
	
	[askPicture release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[actionSheet dismissAsKeyboard:YES];
	
	if ([actionSheet numberOfButtons] == 3 && buttonIndex == 2)
		return;
	if ([actionSheet numberOfButtons] == 2 && buttonIndex == 1)
		return;

	TTURLAction *action = [TTURLAction actionWithURLPath:@""];
	[action applyAnimated:YES];

	BOOL camera = NO;
	
	if (buttonIndex == 0 &&
		[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		camera = YES;
	} else {
		camera = NO;
	}
	
	PhotoPickerController *pickCtrl = [[PhotoPickerController alloc] initWithCamera:camera];
	[self presentModalViewController:pickCtrl animated:YES];
	[pickCtrl release];
	
}


- (void)didReceiveMemoryWarning
{
	/* default here is to dealloc the table, I don't want that so
	 * let's just ignore the signal */
	TTDINFO(@"RootController got memoryWarning");
}

@end
