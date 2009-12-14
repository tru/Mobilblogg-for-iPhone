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

#import "MBPhoto.h"
#import "MBStore.h"
#import "MBImageUtils.h"
#import "MBGlobal.h"

#import "JSON.h"

#include <math.h>

@implementation UploadResponse

-(NSError*)request:(TTURLRequest *)request processResponse:(NSHTTPURLResponse *)response data:(id)data
{
	SBJSON *jsonParser = [[SBJSON alloc] init];
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSError *jsonErr = nil;
	NSArray *arr = [jsonParser objectWithString:responseBody error:&jsonErr];
	
	[jsonParser release];
	[responseBody release];
	
	if (jsonErr) {
		TTDINFO(@"Error in JSON parsing!");
		return [jsonErr retain];
	}
	
	NSInteger i = [[[arr objectAtIndex:0] objectForKey:@"imgid"] intValue];
	if (i == -1) {
		TTDINFO(@"We failed!");
		return [NSError errorWithDomain:MobilBloggErrorDomain code:MobilBloggErrorCodeServer userInfo:nil];
	}
	
	return nil;
}

@end


@implementation UploaderViewController

-(id)initWithUIImage:(UIImage*)img
{
	self = [super init];
	self.title = NSLocalizedString(@"Upload photo", nil);
	self.tableViewStyle = UITableViewStyleGrouped;
	self.autoresizesForKeyboard = YES;
	self.variableHeightRows = YES;
	_uploading = NO;
	_queue = [[NSOperationQueue alloc] init];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Upload", nil) 
																			   style:UIBarButtonItemStyleDone
																			  target:self
																			  action:@selector(upload)] autorelease];
	
	self.navigationItem.rightBarButtonItem.enabled = NO;
	

	CGFloat ax = self.tableView.bounds.size.height - 50;
	_activity = [[TTActivityLabel alloc] initWithFrame:CGRectMake(0, ax, self.tableView.bounds.size.width, 50)
												 style:TTActivityLabelStyleBlackBox
												  text:NSLocalizedString(@"Resizing image...", nil)];
	_activity.smoothesProgress = YES;
	[self.view addSubview:_activity];
	_activity.alpha = 0.0;

	
	if (img.size.width > 800) {
		MBImageScaleOperation *op = [[MBImageScaleOperation alloc] initWithImage:img andTargetSize:CGSizeMake(800, 640)];
		op.delegate = self;
		[_queue addOperation:op];
		[op release];
		_activity.alpha = 1.0;
	} else {
		_imageURL = [[TTURLCache sharedCache] storeTemporaryImage:img toDisk:NO];
	}
	
	[[TTNavigator navigator].URLMap from:@"mb://_editimg" toObject:self selector:@selector(openIMG)];
	
	_image = [img retain];
	
	return self;
}

-(void)imageResized:(UIImage*)img
{
	TTDINFO(@"Image resized!");
	[_image release];
	_image = [img retain];

	
	_imageURL = [[TTURLCache sharedCache] storeTemporaryImage:img toDisk:NO];
	_imageItem.imageURL = _imageURL;
	[self.tableView reloadData];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:TT_FAST_TRANSITION_DURATION];
	_activity.alpha = 0.0;
	[UIView commitAnimations];
	
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: UploadViewController");
	[_image release];
	[_activity release];
	[_captionField release];
	[_bodyField release];
	[_secretWord release];
	[_imageURL release];
	[_queue release];
	[[TTNavigator navigator].URLMap removeURL:@"mb://_editimg"];
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
	
	TTURLRequest *request = [TTURLRequest requestWithURL:[NSString stringWithFormat:@"%@%@", kMobilBloggHTTPProtocol, kMobilBloggHTTPBasePath]
												delegate:self];
	//request.charsetForMultipart = NSISOLatin1StringEncoding;
	request.response = [[[UploadResponse alloc] init] autorelease];
	
	[request.parameters addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
												  kMobilBloggTemplateName, @"template",
												  @"upload", @"func",
												  _captionField.text, @"header",
												  body, @"text",
												  _secretWord, @"secretword",
												  [@"/files/" stringByAppendingString:[MBStore getUserName]], @"path",
												  @"ladda_upp", @"wtd",
												  _image, @"image",
												  nil]];
	
	request.httpMethod = @"POST";
	[request send];
	
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
		UINavigationController *navCtrl = [[[UINavigationController alloc] init] autorelease];
		UploaderSecretViewController *secretCtrl = [[[UploaderSecretViewController alloc] init] autorelease];
		secretCtrl.delegate = self;
		[navCtrl pushViewController:secretCtrl animated:NO];
		
		[self presentModalViewController:navCtrl animated:YES];
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
	TTDINFO(@"Secret word = %@", _secretWord);

	[self doUpload];
}

-(void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error;
{
	UIAlertView *alert = [[UIAlertView alloc] init];
	alert.title = NSLocalizedString(@"Upload failed!", nil);
	if ([error.domain isEqualToString:MobilBloggErrorDomain]) {
		alert.message = NSLocalizedString(@"Most likely your secretword was rejected. Try again", nil);
		[alert addButtonWithTitle:NSLocalizedString(@"Ok!", nil)];
	} else {
		alert.message = [error localizedDescription];
		[alert addButtonWithTitle:[error localizedRecoverySuggestion]];
	}
	alert.delegate = self;
	[alert show];
	[alert release];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ([alertView.message isEqualToString:NSLocalizedString(@"Most likely your secretword was rejected. Try again", nil)]) {
		_uploading = NO;
		self.navigationItem.rightBarButtonItem.enabled = YES;
		self.navigationItem.leftBarButtonItem.enabled = YES;
		_secretWord = nil;
		[MBStore setObject:nil forKey:@"secretWord"];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelay:TT_FAST_TRANSITION_DURATION];
		_activity.alpha = 0.0;
		[UIView commitAnimations];
	} else {
		[self dismissModalViewControllerAnimated:YES];
	}
}

-(void)requestDidUploadData:(TTURLRequest*)request
{
	TTDINFO(@"Uploaded %d", request.totalBytesLoaded);
	_activity.progress = request.totalBytesLoaded / request.totalBytesExpected;
}

-(void)requestDidFinishLoad:(TTURLRequest*)request;
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(id)openIMG
{
	return nil;
}

-(void)createModel
{
	_imageItem = [TTTableImageItem itemWithText:nil];
//	_imageItem.URL = @"mb://_editimg";
	_imageItem.imageStyle = [TTImageStyle styleWithImageURL:nil
											   defaultImage:nil
												contentMode:UIViewContentModeScaleAspectFill
													   size:[MBImageUtils imageSize:_image.size withAspect:CGSizeMake(150.0, 150.0)]
													   next:TTSTYLE(rounded)];

	if (_imageURL) {
		_imageItem.imageURL = _imageURL;
	} else {
		_imageItem.imageURL = @"bundle://Three20.bundle/images/empty.png";
	}

	
	_captionField = [[UITextField alloc] init];
	_captionField.placeholder = NSLocalizedString(@"Caption", nil);
	_captionField.enabled = NO;
	
	_bodyField = [[UITextField alloc] init];
	_bodyField.enabled = NO;
	_bodyField.placeholder = NSLocalizedString(@"Body text", nil);
	_bodyField.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 160);
	
	self.dataSource = [UploaderDataSource dataSourceWithObjects:
					   _captionField,
					   _imageItem,
					   _bodyField,
					   nil];
					   
}

#define LOGRECT(r) TTDINFO(@"%f %f %f %f", r.origin.x, r.origin.y, r.size.width, r.size.height);

-(void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
	if (_uploading) {
		return;
	}
	
	CGRect r = [self.tableView rectForRowAtIndexPath:indexPath];
	CGRect trans = [self.navigationController.view convertRect:r fromView:self.tableView];
	NSString *text;
	NSDictionary *dict;

	if (object == _captionField) {
		text = _captionField.text ? _captionField.text : @"";
		
		dict = [NSDictionary dictionaryWithObjectsAndKeys:
				NSLocalizedString(@"Add caption", nil), @"title",
				[NSValue valueWithCGRect:trans], @"originRect",
				text, @"text",
				nil];
						  
	} else if (object == _bodyField) {
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
	[post showInView:self.navigationController.view animated:YES];

}

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
	return YES;
}

-(CGRect)postController:(TTPostController*)postController willAnimateTowards:(CGRect)rect
{
//	CGRect r = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//	CGRect trans = [self.navigationController.view convertRect:r fromView:self.tableView];

	return rect;
	
}

@end
