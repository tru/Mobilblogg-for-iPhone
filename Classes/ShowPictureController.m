//
//  ShowPictureController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "ShowPictureController.h"
#import "MBPhoto.h"
#import "BlogListThumbsDataSource.h"
#import "BlogListModel.h"
#import "PhotoViewController.h"

@implementation ShowPictureController

-(id)init
{
	self = [super init];
	return self;
}

-(void)updateChrome
{
	[super updateChrome];
	self.navigationItem.rightBarButtonItem = nil;
}

/* we must set the model to our underlying model here,
   otherwise we have problems with the protocol within
   TTPhotoViewController */
-(void)setCenterPhoto:(id<TTPhoto>)photo
{
	[super setCenterPhoto:photo];
	_photo = photo;
	self.model = [((BlogListThumbsDataSource*)photo.photoSource) underlyingModel];
}

-(id)createPhotoView
{
	return [[PhotoViewController alloc] init];
}

-(void)loadView
{
	[super loadView];
	UIBarItem* space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
						 UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	
	UIButton *infoUIButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoUIButton addTarget:self action:@selector(photoInfo) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *info = [[[UIBarButtonItem alloc] initWithCustomView:infoUIButton] autorelease];
	UIBarButtonItem *comment = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(comments)] autorelease];
	
	NSArray *items = [NSArray arrayWithObjects:comment, space, _previousButton, space, _nextButton, space, info, nil];
	
	_toolbar.items = items;
}

-(void)photoInfo
{
	MBPhoto *currentPhoto = self.centerPhoto;
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:currentPhoto, @"photo", nil];
	[[TTNavigator navigator] openURL:@"mb://photoinfo" query:dict animated:YES];
}

-(void)comments
{
	MBPhoto *p = (MBPhoto*)_centerPhoto;
	[[TTNavigator navigator] openURL:[@"mb://comments/" stringByAppendingFormat:@"%d",p.photoId] animated:YES];
}

- (void)dealloc {
	NSLog(@"DEALLOC: ShowPictureController");
	[super dealloc];
}

@end
