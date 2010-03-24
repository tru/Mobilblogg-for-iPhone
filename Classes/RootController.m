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
#import "MBUser.h"
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
//	self.tableViewStyle = UITableViewStyleGrouped;
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera 
																						   target:self 
																						   action:@selector(camera)] autorelease];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", nil)
																			 style:UIBarButtonItemStylePlain target:self
																			action:@selector(logout)] autorelease];

	self.navigationBarTintColor = [UIColor mbColor];
	
	_doneFirstTime = NO;

	return self;
}

- (void)createModel
{
	MBUser *user = [[MBUser alloc] initWithUserName:[MBStore getUserName]];
	user.delegate = self;
	[user release];
	
	TTImageStyle *style = [TTImageStyle styleWithImageURL:nil
											 defaultImage:nil
											  contentMode:UIViewContentModeScaleAspectFill
													 size:CGSizeMake(25, 25)
													 next:TTSTYLE(rounded)];

	_startpage = [TTTableImageItem itemWithText:NSLocalizedString(@"My Start Page", nil)
									   imageURL:@"http://mobilblogg.nu/cache/ttf/011086f0e011367f52.gif"
								   defaultImage:nil
									 imageStyle:style
											URL:@"mb://listfunction/listStartpage"];
	
	_myblog = [TTTableImageItem itemWithText:NSLocalizedString(@"My Blog", nil)
									imageURL:@"http://mobilblogg.nu/cache/ttf/011086f0e011367f52.gif"
								defaultImage:nil
								  imageStyle:style
										 URL:[@"mb://listblog/" stringByAppendingString:[MBStore getUserName]]];
	
	TTDINFO("createModel called from RootController");
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
					   NSLocalizedString(@"My pages", nil),
					   _startpage,
					   _myblog,
					   NSLocalizedString(@"MobilBlogg", nil),
					   [TTTableImageItem itemWithText:NSLocalizedString(@"Go to User", nil)
											 imageURL:@"bundle://Icon.png"
										 defaultImage:nil
										   imageStyle:style
												  URL:@"mb://gotouser"],
					   [TTTableImageItem itemWithText:NSLocalizedString(@"First Page", nil)
											 imageURL:@"bundle://Icon.png"
										 defaultImage:nil
										   imageStyle:style
												  URL:@"mb://listfunction/listFirstpage"],

/*					   NSLocalizedString(@"Application", nil),
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Settings", @"Menu item") URL:@"mb://configuration"],
					   [TTTableTextItem itemWithText:NSLocalizedString(@"About", nil) URL:@"mb://about"],*/
					   nil];
}

-(void)loadView
{
	[super loadView];
	if (!_doneFirstTime) {
		self.navigationController.view.alpha = 0.0;
	}
}

-(void)viewWillAppear:(BOOL)animated
{
	if (!_doneFirstTime) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelay:0.2];
		[UIView setAnimationDuration:0.8];
		self.navigationController.view.alpha = 1.0;
		[UIView	commitAnimations];
		_doneFirstTime = YES;
	}
	
	[super viewWillAppear:animated];
}

-(void)MBUserDidReceiveInfo:(MBUser*)user
{
	_myblog.imageURL = user.avatarURL;
	_startpage.imageURL = user.avatarURL;
	[self.tableView reloadData];
}

-(void)MBUser:(MBUser *)user didFailWithError:(NSError *)err
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
	TTDINFO(@"DEALLOC: RootController");
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

#if 0
- (void)didReceiveMemoryWarning
{
	/* default here is to dealloc the table, I don't want that so
	 * let's just ignore the signal */
	TTDINFO(@"RootController got memoryWarning");
}
#endif

@end
