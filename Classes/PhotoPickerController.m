//
//  PhotoPickerController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2010-02-26.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import "PhotoPickerController.h"


@implementation PhotoPickerController

-(id)initWithCamera:(BOOL)camera
{
	self = [super init];
	if (self) {
		self.delegate = self;
		self.allowsImageEditing = NO;
	
		if (camera) {
			self.sourceType = UIImagePickerControllerSourceTypeCamera;
		} else {
			self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
			
	}
	return self;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
	if (!img) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No image?", nil)
														message:NSLocalizedString(@"We have no image here, grave error", nil)
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"Ok, beam me up!", nil)
											  otherButtonTitles:nil];
		[alert release];
		return;
	}
	
	TTURLAction *action = [TTURLAction actionWithURLPath:@"mb://upload"];
	[action applyAnimated:YES];
	[action applyQuery:[NSDictionary dictionaryWithObjectsAndKeys:img, @"image", nil]];
	[[TTNavigator navigator] openURLAction:action];
	//[self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

-(void)dealloc
{
	TTDINFO("DEALLOC: PhotoPickerController");
	[super dealloc];
}

@end
