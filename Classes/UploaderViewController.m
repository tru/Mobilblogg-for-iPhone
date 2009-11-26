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
#import "MBErrorCodes.h"

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
		NSLog(@"Error in JSON parsing!");
		return [jsonErr retain];
	}
	
	NSInteger i = [[[arr objectAtIndex:0] objectForKey:@"imgid"] intValue];
	if (i == -1) {
		NSLog(@"We failed!");
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
	_image = [img retain];
	self.tableViewStyle = UITableViewStyleGrouped;
	self.autoresizesForKeyboard = YES;
	self.variableHeightRows = YES;
	_uploading = NO;
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Upload", nil) 
																			   style:UIBarButtonItemStyleDone
																			  target:self
																			  action:@selector(upload)] autorelease];
	
	self.navigationItem.rightBarButtonItem.enabled = NO;
		
	TTLOGSIZE(_image.size);
	if (_image.size.width > 640) {
		UIImage *resizedImg = [MBImageUtils imageWithImage:_image scaledToSize:CGSizeMake(640, 480)];
		[_image release];
		_image = resizedImg;
	}
	
	_imageURL = [[TTURLCache sharedCache] storeTemporaryImage:_image toDisk:NO];

	[[TTNavigator navigator].URLMap from:@"mb://_editimg" toObject:self selector:@selector(openIMG)];
	
	CGFloat ax = self.tableView.bounds.size.height - 50;
	
	_activity = [[TTActivityLabel alloc] initWithFrame:CGRectMake(0, ax, self.tableView.bounds.size.width, 50)
												 style:TTActivityLabelStyleBlackBox
												  text:NSLocalizedString(@"Upload...", nil)];
	_activity.smoothesProgress = YES;
//	[self.view addSubview:_activity];
	
	return self;
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
	
	TTURLRequest *request = [TTURLRequest requestWithURL:@"http://www.mobilblogg.nu/o.o.i.s"
												delegate:self];
	//request.charsetForMultipart = NSISOLatin1StringEncoding;
	request.response = [[[UploadResponse alloc] init] autorelease];
	
	[request.parameters addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
												  @".api.t", @"template",
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
	
	[self.view addSubview:_activity];
	_activity.progress = 0.0;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	self.navigationItem.leftBarButtonItem.enabled = NO;
	_uploading = YES;
	
	if ([_captionField isFirstResponder]) {
		[_captionField resignFirstResponder];
	}
	
	if ([_bodyField isFirstResponder]) {
		[_captionField resignFirstResponder];
	}
}

-(void)upload
{
	_secretWord = [MBStore getObjectForKey:@"secretWord"];
	if (!_secretWord) {
		UINavigationController *navCtrl = [[[UINavigationController alloc] init] autorelease];
		UploaderSecretViewController *secretCtrl = [[UploaderSecretViewController alloc] init];
		secretCtrl.delegate = self;
		[navCtrl pushViewController:secretCtrl animated:NO];
		
		[self presentModalViewController:navCtrl animated:YES];
	} else {
		[self doUpload];
	}
}

-(void)SecrectControllerIsDone:(UploaderSecretViewController*)secretCtrl
{
	if ([secretCtrl.secretWord length] < 1) {
		[self dismissModalViewControllerAnimated:YES];
	}
	_secretWord = secretCtrl.secretWord;
	NSLog(@"Secret word = %@", _secretWord);

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
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ([alertView.message isEqualToString:NSLocalizedString(@"Most likely your secretword was rejected. Try again", nil)]) {
		_uploading = NO;
		self.navigationItem.rightBarButtonItem.enabled = YES;
		self.navigationItem.leftBarButtonItem.enabled = YES;
		[_activity removeFromSuperview];
		_secretWord = nil;
		[MBStore setObject:nil forKey:@"secretWord"];
	} else {
		[self dismissModalViewControllerAnimated:YES];
	}
}

-(void)requestDidUploadData:(TTURLRequest*)request
{
	NSLog(@"Uploaded %d", request.totalBytesLoaded);
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

	_imageItem.imageURL = _imageURL;

	
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

#define LOGRECT(r) NSLog(@"%f %f %f %f", r.origin.x, r.origin.y, r.size.width, r.size.height);

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
