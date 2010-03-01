//
//  UploaderSecretViewController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-26.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "UploaderSecretViewController.h"
#import "MBStore.h"

@implementation UploaderSecretViewController

@synthesize delegate = _delegate;
@synthesize secretWord = _secWord;

-(id)init
{
	self = [super init];
	self.tableViewStyle = UITableViewStyleGrouped;
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																							target:self
																							action:@selector(done)]
											  autorelease];
	return self;
}

-(void)done
{
	_secWord = _secretWord.text;
	if (_save.on == YES) {
		[MBStore setObject:_secretWord.text forKey:@"secretWord"];
	}
	[self dismissModalViewControllerAnimated:YES];
	if ([_delegate respondsToSelector:@selector(SecretControllerIsDone:)]) {
		[_delegate SecretControllerIsDone:self];
	}
}

-(void)createModel
{
	_secretWord = [[UITextField alloc] init];
	_secretWord.placeholder = @"Secret word";
	_secretWord.secureTextEntry = YES;
	_secretWord.clearsOnBeginEditing = YES;
	_secretWord.keyboardType = UIKeyboardTypeEmailAddress;
	_secretWord.autocorrectionType = UITextAutocorrectionTypeNo;
	_secretWord.autocapitalizationType = UITextAutocapitalizationTypeNone;
	
	_save = [[UISwitch alloc] init];
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
					   NSLocalizedString(@"You need to enter your secret word in order to upload photos.", nil),
					   _secretWord,
					   [TTTableControlItem itemWithCaption:NSLocalizedString(@"Save secret word?", nil) control:_save],
					   nil];
					   
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: UploaderSecretViewController");
	[_secretWord release];
	[_save release];
	[super dealloc];
}

-(void)SecretControllerIsDone:(UploaderSecretViewController *)secretCtrl
{
}

@end
