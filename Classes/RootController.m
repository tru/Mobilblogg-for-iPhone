//
//  RootController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "RootController.h"
#import "MBStore.h"
#import "MBErrorCodes.h"

@implementation RootController

- (id)init {
	self = [super init];
	
	self.title = @"MobilBlogg.nu";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
																			  style:UIBarButtonItemStyleBordered 
																			 target:nil action:nil] autorelease];
	self.tableViewStyle = UITableViewStyleGrouped;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera 
																						   target:self 
																						   action:@selector(camera)];
	
	_activity = [[TTActivityLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 480)
												 style:TTActivityLabelStyleBlackBox
												  text:NSLocalizedString(@"Logging in...", nil)];
	return self;
}


- (void)createModel
{
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
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Settings", @"Menu item") URL:@"mb://userconfmodal/no"],
					   [TTTableTextItem itemWithText:NSLocalizedString(@"About", nil) URL:@"mb://about"],
					   nil];
}

- (void)viewDidLoad {
	NSString *username, *password;
	
	username = [MBStore getUserName];
	password = [MBStore getPasswordForUsername:username];
	
	if (!username || !password) {
		[[TTNavigator navigator] openURL:@"mb://userconfmodal/yes" animated:NO];
	} else {
		MBLogin *login = [[[MBLogin alloc] initWithUsername:username andPassword:password] autorelease];
		login.delegate = self;
		
		self.navigationItem.rightBarButtonItem.enabled = NO;
		[self.navigationController.view addSubview:_activity];
	}
}

-(void)loginDidSucceed
{
	[_activity removeFromSuperview];
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

-(void)loginDidFailWithError:(NSError *)err
{
	UIAlertView *alert;
	[_activity removeFromSuperview];
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	
	if ([[err domain] isEqualToString:MobilBloggErrorDomain] && [err code] == MobilBloggErrorCodeInvalidCredentials) {
		alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login failed", nil)
										   message:NSLocalizedString(@"Saved credentials are not valid", nil)
										  delegate:self
								 cancelButtonTitle:NSLocalizedString(@"Ok", nil)
								 otherButtonTitles:NSLocalizedString(@"Settings", nil),nil];
	} else {
		alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login failed", nil)
										   message:[err localizedDescription]
										  delegate:self
								 cancelButtonTitle:NSLocalizedString(@"Ok", nil)
								 otherButtonTitles:nil];

	}

	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		/*TODO: make something fancy here later */
	} else {
		[[TTNavigator navigator] openURL:@"mb://userconfmodal/yes" animated:YES];
	}
}

- (void)dealloc {
	[_activity release];
    [super dealloc];
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
