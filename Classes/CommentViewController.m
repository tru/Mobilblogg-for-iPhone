//
//  CommentViewController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentModel.h"
#import "CommentDataSource.h"
#import "JSON.h"
#import "MBGlobal.h"

@implementation CommentPostResponse

-(NSError*)request:(TTURLRequest *)request processResponse:(NSHTTPURLResponse *)response data:(id)data
{
	SBJSON *jsonParser = [[SBJSON alloc] init];
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSError *jsonErr = nil;
	NSArray *arr = [jsonParser objectWithString:responseBody error:&jsonErr];

	TTDINFO(@"response = %@", responseBody);
	
	[jsonParser release];
	[responseBody release];
	
	if (jsonErr) {
		TTDINFO(@"Error in JSON parsing!");
		return [jsonErr retain];
	}
	
	if ([[[arr objectAtIndex:0] objectForKey:@"Status"] intValue] != 1) {
		return [NSError errorWithDomain:MobilBloggErrorDomain code:MobilBloggErrorCodeServer userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:
				 NSLocalizedString(@"Failed to comment on photo", nil), NSLocalizedDescriptionKey,
				 nil]];
	}
		
	return nil;
}

@end

@implementation CommentPostController

-(NSString*)titleForActivity
{
	return NSLocalizedString(@"Posting ...", nil);
}

-(NSString*)titleForError:(NSError*)error
{
	return [NSString stringWithFormat:NSLocalizedString(@"Error occured: %@ ...", nil), [error localizedDescription]];
}

@end


@implementation CommentViewController
//@synthesize photoId = _photoId;

-(id)initWithId:(id)pId
{
	self = [super init];
	self.title = NSLocalizedString(@"Comments", nil);
	self.variableHeightRows = YES;
	
	_photoId = [pId intValue];
	
	id<TTTableViewDataSource> ds = [CommentDataSource dataSourceWithItems:nil];
	ds.model = [[[CommentModel alloc] initWithPhotoId:[pId intValue]] autorelease];
	((CommentDataSource*)ds).delegate = self;
	self.dataSource = ds;
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
																						   target:self 
																						   action:@selector(writeComment)];
	return self;
}

-(void)dataSourceUpdate
{
	[self.tableView	reloadData];
}

-(void)writeComment
{
	CGRect origin = CGRectMake(320-30, TTBarsHeight()-20, 20, 20);
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  [NSValue valueWithCGRect:origin], @"originRect",
						  NSLocalizedString(@"Add comment", nil), @"title",
						  nil];
						  
	
	_postCtrl = [[CommentPostController alloc] initWithNavigatorURL:nil query:dict];
	_postCtrl.delegate = self;
	self.popupViewController = _postCtrl;
	_postCtrl.superController = self;
	
	[_postCtrl showInView:self.tableView animated:YES];
}

-(BOOL)postController:(TTPostController*)postController willPostText:(NSString*)text
{
	TTURLRequest *request = [TTURLRequest requestWithURL:[NSString stringWithFormat:@"%@%@", kMobilBloggHTTPProtocol, kMobilBloggHTTPBasePath]
												delegate:self];
	//request.charsetForMultipart = NSISOLatin1StringEncoding;
	request.response = [[[CommentPostResponse alloc] init] autorelease];
	
	[request.parameters addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
												  kMobilBloggTemplateName, @"template",
												  @"writeComment", @"func",
												  @"comment", @"wtd",
												  [NSString stringWithFormat:@"%d", _photoId], @"imgid",
												  text, @"message",
												  nil]];
	
	request.httpMethod = @"POST";
	[request send];

	return NO;
}

-(void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error
{
	[_postCtrl failWithError:error];
}

-(void)requestDidFinishLoad:(TTURLRequest *)request
{
	[self reload];
	
	TTDINFO("Posting notification");
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"commentSentForPhotoId" 
														object:nil 
													  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
																[NSString stringWithFormat:@"%d", _photoId], @"photoId",
																nil]
	 ];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return TTIsSupportedOrientation(toInterfaceOrientation);
}

-(void)didLoadModel:(BOOL)firstTime
{
	[super didLoadModel:firstTime];
	if (_postCtrl) {
		[_postCtrl dismissWithResult:nil animated:YES];
	}
	[_postCtrl release];
	_postCtrl = nil;
}

@end
