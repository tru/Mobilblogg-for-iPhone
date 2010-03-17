//
//  UploaderViewController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "UploaderViewController.h"
#import "UploaderDataSource.h"
#import "UploaderSecretViewController.h"
#import "UploaderPermViewController.h"

#import "MBPhoto.h"
#import "MBStore.h"
#import "MBImageUtils.h"
#import "MBGlobal.h"

#import "UploaderImageCell.h"

#import "JSON.h"

#import "EXF.h"


#import <CoreLocation/CoreLocation.h>

#include <math.h>

@implementation UploadResponse

-(NSError*)request:(TTURLRequest *)request processResponse:(NSHTTPURLResponse *)response data:(id)data
{
	SBJSON *jsonParser = [[SBJSON alloc] init];
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSError *jsonErr = nil;
	NSArray *arr = [jsonParser objectWithString:responseBody error:&jsonErr];
	
//	TTDINFO("json reponse: %@", responseBody);
	
	[jsonParser release];
	[responseBody release];
	
	if (jsonErr) {
		TTDINFO(@"Error in JSON parsing!");
		return [jsonErr retain];
	}
	
	NSInteger i = [[[arr objectAtIndex:0] objectForKey:@"imgid"] intValue];
 	if (i == -1) {
		TTDINFO(@"We failed!");
		return [NSError errorWithDomain:MobilBloggErrorDomain 
								   code:MobilBloggErrorCodeServer
							   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
										 NSLocalizedString(@"Wrong secret word!", nil), NSLocalizedDescriptionKey,
										 nil]
				];
	} else if (i == -2) {
		TTDINFO(@"Error string from server");
		return [NSError errorWithDomain:MobilBloggErrorDomain
								   code:MobilBloggErrorCodeServer
							   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
										 [[arr objectAtIndex:0] objectForKey:@"error"], NSLocalizedDescriptionKey,
										 nil]
				];
	}
	
	return nil;
}

@end


@implementation UploaderViewController

-(id)initWithNavigatorURL:(NSURL*)url query:(NSDictionary*)dict
{
	self = [super init];
	_pool = [[NSAutoreleasePool alloc] init];
	TTDINFO("Upload photo init");
	UIImage *img = [dict objectForKey:@"image"];
	self.title = NSLocalizedString(@"Upload photo", nil);
	self.autoresizesForKeyboard = YES;
	self.variableHeightRows = YES;
	_uploading = NO;
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Upload", nil) 
																			   style:UIBarButtonItemStyleDone
																			  target:self
																			  action:@selector(upload)] autorelease];
	
	self.navigationItem.rightBarButtonItem.enabled = NO;
	

	CGFloat ax = self.tableView.bounds.size.height - 50;
	_activity = [[TTActivityLabel alloc] initWithFrame:CGRectMake(0, ax, self.tableView.bounds.size.width, 50)
												 style:TTActivityLabelStyleBlackBox
												  text:NSLocalizedString(@"Working...", nil)];
	_activity.smoothesProgress = NO;
	[self.view addSubview:_activity];
	_activity.alpha = 0.0;
	
	_imageItem = [[[UploaderImageItem alloc] init] autorelease];
	UIImage *defImg = TTIMAGE(@"bundle://Three20.bundle/images/empty.png");
	_imageItem.image = defImg;
	
	NSString *fromCamera = [dict objectForKey:@"fromCamera"];
	if ([fromCamera isEqualToString:@"yes"]) {
		UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
		_activity.text = NSLocalizedString(@"Saving image...", nil);
		_activity.alpha = 1.0;
	} else {
		[self image:img didFinishSavingWithError:nil contextInfo:nil];
	}
	
	
//	[[TTNavigator navigator].URLMap from:@"mb://_editimg" toObject:self selector:@selector(openIMG)];
			
	return self;
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)context
{
	if (image.size.width > 800) {
		NSOperationQueue *queue = [[NSOperationQueue alloc] init];
		MBImageScaleOperation *op = [[MBImageScaleOperation alloc] initWithImage:image andTargetSize:CGSizeMake(800, 640)];
		op.delegate = self;
		[queue addOperation:op];
		[queue release];
		[op release];
		_activity.text = NSLocalizedString(@"Resizing image...", nil);
		_activity.alpha = 1.0;
	} else {
		_imageItem.image = image;
		[self activityRemove];
	}

}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)imageResized:(UIImage*)img
{
	[self activityRemove];
	_imageItem.image = img;
	
	[self.tableView reloadData];
	
}

-(void)activityRemove
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:TT_FAST_TRANSITION_DURATION];
	_activity.alpha = 0.0;
	[UIView commitAnimations];
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: UploadViewController");
	[_pool drain];
	[_pool release];
	[_activity release];
	if (_locationManager) {
		[_locationManager release];
	}
	[super dealloc];
}


-(void)doUpload
{
	NSString *body = @"";
	
	if (![_bodyField.text isEqualToString:NSLocalizedString(@"Body text", nil)]) {
		body = _bodyField.text;
	}
	
	if (!body) {
		body = @"";
	}
	
	if (!_imageItem.image || _imageItem.image.size.width < 1) {
		UIAlertView *alert = [[UIAlertView alloc] init];
		alert.title = NSLocalizedString(@"No image found!!", nil);
		alert.message = NSLocalizedString(@"This is a fatal error and you need to report it to the developer!", nil);
		[alert addButtonWithTitle:NSLocalizedString(@"Ok!", nil)];
//		alert.delegate = self;
		[alert show];
		[alert release];
		return;
	}
	
	NSData *imageData = nil;
	
	if (_locationField.on && _locationManager && _locationManager.location) {		
		imageData = [MBImageUtils geotagImage:_imageItem.image withLocation:_locationManager.location];
	} else {
		imageData = UIImageJPEGRepresentation(_imageItem.image, 1.0);
	}
	
	TTURLRequest *request = [TTURLRequest requestWithURL:[NSString stringWithFormat:@"%@%@", kMobilBloggHTTPProtocol, kMobilBloggHTTPBasePath]
												delegate:self];
	//request.charsetForMultipart = NSISOLatin1StringEncoding;
	request.response = [[[UploadResponse alloc] init] autorelease];
	
	[request.parameters addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
												  kMobilBloggTemplateName, @"template",
												  @"upload", @"func",
												  _captionField.text, @"header",
												  body, @"text",
												  _secretWord ? _secretWord : @"", @"secretword",
												  [@"/files/" stringByAppendingString:[MBStore getUserName]], @"path",
												  @"ladda_upp", @"wtd",
												  [UploaderPermViewController getCurrentPermValue], @"rights",
												  nil]];
	
	[request addFile:imageData mimeType:@"image/jpeg" fileName:@"image.jpg"];
	
	request.httpMethod = @"POST";
	[request send];
//	TTDINFO("Sent request %d", request.totalBytesExpected);
	
	self.navigationItem.rightBarButtonItem.enabled = NO;
	self.navigationItem.leftBarButtonItem.enabled = NO;
	_uploading = YES;
	
	if ([_captionField isFirstResponder]) {
		[_captionField resignFirstResponder];
	}
	
	if ([_bodyField isFirstResponder]) {
		[_captionField resignFirstResponder];
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:TT_FAST_TRANSITION_DURATION];
	[self.view addSubview:_activity];
	_activity.text = NSLocalizedString(@"Uploading image...", nil);
	_activity.progress = 0.0;
	_activity.alpha = 1.0;
	[UIView commitAnimations];

}

-(void)upload
{
	_secretWord = [MBStore getObjectForKey:@"secretWord"];
	if (!_secretWord) {
		UINavigationController *navCtrl = [[UINavigationController alloc] init];
		UploaderSecretViewController *secretCtrl = [[UploaderSecretViewController alloc] init];
		secretCtrl.delegate = self;
		[navCtrl pushViewController:secretCtrl animated:NO];
		[secretCtrl release];
		
		[self presentModalViewController:navCtrl animated:YES];
		[navCtrl release];
	} else {
		[self doUpload];
	}
}

-(void)SecretControllerIsDone:(UploaderSecretViewController*)secretCtrl
{
	if ([secretCtrl.secretWord length] < 1) {
		[self dismissModalViewControllerAnimated:YES];
	}
	_secretWord = secretCtrl.secretWord;
//	TTDINFO(@"Secret word = %@", _secretWord);

	[self doUpload];
}

-(void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error;
{
	UIAlertView *alert = [[UIAlertView alloc] init];
	alert.title = NSLocalizedString(@"Upload failed!", nil);
	alert.message = [error localizedDescription];
	[alert addButtonWithTitle:NSLocalizedString(@"Ok!", nil)];
	alert.delegate = self;
	[alert show];
	[alert release];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self activityRemove];
	if ([alertView.message isEqualToString:NSLocalizedString(@"Wrong secret word!", nil)]) {
		_uploading = NO;
		self.navigationItem.rightBarButtonItem.enabled = YES;
		self.navigationItem.leftBarButtonItem.enabled = YES;
		_secretWord = nil;
		[MBStore setObject:nil forKey:@"secretWord"];
		
	} else {
		TTDINFO("Closing window");
		[self.navigationController popViewControllerAnimated:YES];
	}
}

-(void)requestDidUploadData:(TTURLRequest*)request
{
//	TTDINFO(@"Uploaded %d", request.totalBytesLoaded);
	_activity.progress = request.totalBytesLoaded / request.totalBytesExpected;
	if (_activity.progress == 1) {
		_activity.text = NSLocalizedString(@"Waiting for server response...", nil);
	}
}

-(void)requestDidFinishLoad:(TTURLRequest*)request;
{
	TTDINFO("done with upload! %d", request.totalBytesLoaded);
	[self dismissModalViewControllerAnimated:YES];
}

-(void)createModel
{
	_captionField = [[UITextField alloc] init];
	_captionField.enabled = NO;
	
	_bodyField = [[UITextField alloc] init];
	_bodyField.enabled = NO;
	
	_permField = [[UITextField alloc] init];
	_permField.text = [UploaderPermViewController getCurrentPermValueText];
	_permField.enabled = NO;
	
	_locationField = [UISwitch new];
	_locationField.on = [MBStore getBoolForKey:@"useLocation"];
	[_locationField addTarget:self action:@selector(switchLocation) forControlEvents:UIControlEventValueChanged];
	
	TTTableControlItem *cf = [TTTableControlItem itemWithCaption:NSLocalizedString(@"Caption:", nil) control:_captionField];
	TTTableControlItem *bf = [TTTableControlItem itemWithCaption:NSLocalizedString(@"Body text:", nil) control:_bodyField];
	TTTableControlItem *pf = [TTTableControlItem itemWithCaption:NSLocalizedString(@"Visible to:", nil) control:_permField];
	TTTableControlItem *lf = [TTTableControlItem itemWithCaption:NSLocalizedString(@"Add location", nil) control:_locationField];
	
	[_captionField release];
	[_bodyField release];
	[_permField release];
	[_locationField release];
	
	self.dataSource = [UploaderDataSource dataSourceWithObjects:
					   _imageItem,
					   cf,
					   bf,
					   pf,
					   lf,
					   nil];
	
/*	[cf release];
	[bf release];
	[pf release];
	[lf release];*/
	
	if (_locationField.on) {
		[self resolveLocation];
	}
					   
}

-(void)switchLocation
{
	TTDINFO("switchLocation!");
	[MBStore setBool:_locationField.on forKey:@"useLocation"];
	if (_locationField.on) {
		[self resolveLocation];
	} else {
		if (_locationManager) {
			[_locationManager stopUpdatingLocation];
		}
	}
}

#pragma mark CCLocation

-(void)resolveLocation
{
	if (!_locationManager) {
		_locationManager = [CLLocationManager new];
		_locationManager.delegate = self;
		_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	}
		
	[_locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSLog(@"New location ... %@", [newLocation description]);
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	if ([error code] == kCLErrorDenied) {
		/* denied access by the user */
		[_locationField setOn:NO animated:YES];
	}
	[MBStore setBool:_locationField.on forKey:@"useLocation"];
}

-(void)didSelectPermValue:(NSString*)permText
{
	_permField.text = permText;
}

-(void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
	if (_uploading) {
		return;
	}
	
	if (![object isKindOfClass:[TTTableControlItem class]]) {
		return;
	}
	
	id control = ((TTTableControlItem*)object).control;
	
	
	if (control == _permField) {
		UploaderPermViewController *permCtrl = [[UploaderPermViewController alloc] init];
		permCtrl.delegate = self;
		UINavigationController *navCtrl = [[UINavigationController alloc] init];
		[navCtrl pushViewController:permCtrl animated:NO];
		[permCtrl release];

		[self presentModalViewController:navCtrl animated:YES];
		[navCtrl release];
		
		return;
	}
	
	CGRect r = [self.tableView rectForRowAtIndexPath:indexPath];
	CGRect trans = [self.navigationController.view convertRect:r fromView:self.tableView];
	NSString *text;
	NSDictionary *dict;

	if (control == _captionField) {
		text = _captionField.text ? _captionField.text : @"";
		
		dict = [NSDictionary dictionaryWithObjectsAndKeys:
				NSLocalizedString(@"Add caption", nil), @"title",
				[NSValue valueWithCGRect:trans], @"originRect",
				text, @"text",
				nil];
						  
	} else if (control == _bodyField) {
		text = _bodyField.text ? _bodyField.text : @"";
		
		dict = [NSDictionary dictionaryWithObjectsAndKeys:
				NSLocalizedString(@"Add body", nil), @"title",
				[NSValue valueWithCGRect:trans], @"originRect",
				text, @"text",
				nil];

	} else {
		return;
	}

	
	TTPostController *post = [[TTPostController alloc] initWithNavigatorURL:nil query:dict];
	post.delegate = self;
	self.popupViewController = post;
	post.superController = self;
	[post showInView:self.view animated:YES];
	[post release];
	_showingPostCtrl = YES;
}

/*
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	TTDINFO("shouldAutorotate?");
	if (_showingPostCtrl) {
		return YES;
	} else {
		return NO;
	}
}*/

-(BOOL)postController:(TTPostController*)postController willPostText:(NSString*)text
{
	/* wow, the matching here is butt ugly */
	if ([postController.navigationItem.title isEqualToString:NSLocalizedString(@"Add caption", nil)]) {
		_captionField.text = text;
		if ([text length] > 0) {
			self.navigationItem.rightBarButtonItem.enabled = YES;
		}
	} else if ([postController.navigationItem.title isEqualToString:NSLocalizedString(@"Add body", nil)]) {
		_bodyField.text = text;
	}
	_showingPostCtrl = NO;
	return YES;
}

-(CGRect)postController:(TTPostController*)postController willAnimateTowards:(CGRect)rect
{
//	CGRect r = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//	CGRect trans = [self.navigationController.view convertRect:r fromView:self.tableView];

	return rect;
	
}

@end
