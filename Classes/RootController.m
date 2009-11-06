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
	
	_activity = [[TTActivityLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 416)
												 style:TTActivityLabelStyleBlackBox
												  text:NSLocalizedString(@"Initializing", nil)];
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
	NSString *username, *password;
	
	username = [MBStore getUserName];
	password = [MBStore getPasswordForUsername:username];
	
	if (!username || !password) {
		[[TTNavigator navigator] openURL:@"mb://configure" animated:NO];
	} else {
		MBLogin *login = [MBLogin loginWithUsername:username andPassword:password];
		login.delegate = self;
		
		self.navigationItem.rightBarButtonItem.enabled = NO;
		[[self view] addSubview:_activity];
	}
}

-(void)loginDidSucceed
{
	[_activity removeFromSuperview];
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

-(void)loginDidFailWithError:(NSError *)err
{
	[_activity removeFromSuperview];
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	[MBStore removePasswordForUsername:[MBStore getUserName]];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login failed", nil)
													message:NSLocalizedString(@"Saved credentials are not valid", nil)
												   delegate:self
										  cancelButtonTitle:NSLocalizedString(@"Quit", nil)
										  otherButtonTitles:NSLocalizedString(@"Settings", nil),nil];

	[alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		
	} else {
		[[TTNavigator navigator] openURL:@"mb://configure" animated:YES];
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
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	} else {
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	
	[self presentModalViewController:picker animated:YES];
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
