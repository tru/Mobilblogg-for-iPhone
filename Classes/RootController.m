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
					   NSLocalizedString(@"My pages", nil),
					   [TTTableTextItem itemWithText:NSLocalizedString(@"My Blog",nil) URL:[@"mb://listblog/" stringByAppendingString:[MBStore getUserName]]],
					   NSLocalizedString(@"MobilBlogg", nil),
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Go to User", nil) URL:@"mb://searchuser"],
					   [TTTableTextItem itemWithText:NSLocalizedString(@"First Page", nil) URL:@"mb://firstpage"],
					   NSLocalizedString(@"Settings", nil),
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Settings", @"Menu item") URL:@"mb://configure"],
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
	UIActionSheet *askPicture = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
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
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	if (buttonIndex == 0 &&
		[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[picker takePicture];
	} else {
		[self presentModalViewController:picker animated:YES];
	}
	
	[picker release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
	
	UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
	if (!img) {
		img = [info objectForKey:UIImagePickerControllerOriginalImage];
	}
	if (!img) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No image?", nil)
														message:NSLocalizedString(@"We have no image here, grave error", nil)
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"Ok, beem me up!", nil)
											  otherButtonTitles:nil];
		[img release];
		[alert release];
		return;
	}
	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissModalViewControllerAnimated:YES];
}

@end
