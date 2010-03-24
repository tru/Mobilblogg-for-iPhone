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
#import "MBImageUtils.h"

@implementation ShowPictureController

-(id)init
{
	self = [super init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotNotification:) name:@"commentSentForPhotoId" object:nil];
	
	
	return self;
}

-(void)showMap
{
	TTURLAction *ac = [TTURLAction actionWithURLPath:@"mb://map"];
	BlogListModel *model = (BlogListModel*)self.model;
	NSArray *photos = [model results];
	[ac applyQuery:[NSDictionary dictionaryWithObjectsAndKeys:photos, @"photos", _photo, @"centerPhoto", nil]];
	[ac applyAnimated:YES];
	[[TTNavigator navigator] openURLAction:ac];
}

- (void)gotNotification:(NSNotification*)notif
{
	NSDictionary *dict = [notif userInfo];
	NSInteger photoId = [[dict objectForKey:@"photoId"] intValue];
	
	TTDINFO("Got notification for photoId %d, my is %d", photoId, _photo.photoId);
	if (photoId != _photo.photoId)
	{
		return;
	}
	
	NSUInteger num = _photo.numcomments;
	TTDINFO("Setting number of comments to %d", num);
	
	/* kind of sheer luck this works :) */
	
	/* TODO: when we have the number of comments in the toolbar again */
}

-(void)updateChrome
{
	[super updateChrome];
	//self.navigationItem.rightBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Show map", nil)
																			   style:UIBarButtonItemStyleBordered
																			  target:self
																			  action:@selector(showMap)] autorelease];
}

/* we must set the model to our underlying model here,
   otherwise we have problems with the protocol within
   TTPhotoViewController */
-(void)setCenterPhoto:(id<TTPhoto>)photo
{
	[super setCenterPhoto:photo];
	_photo = (MBPhoto*)photo;
	self.model = [((BlogListThumbsDataSource*)photo.photoSource) underlyingModel];
}

-(id)createPhotoView
{
	return [[[PhotoViewController alloc] init] autorelease];
}

-(void)didMoveToPhoto:(id<TTPhoto>)photo fromPhoto:(id<TTPhoto>)fromPhoto
{
	MBPhoto *p = (MBPhoto*)photo;
	_photo = p;
}

-(void)loadView
{
	[super loadView];
	
	UIBarItem* space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
						 UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	
	UIButton *infoUIButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoUIButton addTarget:self action:@selector(photoInfo) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *info = [[[UIBarButtonItem alloc] initWithCustomView:infoUIButton] autorelease];
	UIBarButtonItem *cmt = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"08-chat.png"]
															 style:UIBarButtonItemStylePlain
															target:self
															action:@selector(comments)] autorelease];

	NSArray *items = [NSArray arrayWithObjects:cmt, space, _previousButton, space, _nextButton, space, info, nil];
	
	_toolbar.items = items;
}

-(void)photoInfo
{
	MBPhoto *currentPhoto = (MBPhoto*)self.centerPhoto;
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:currentPhoto, @"photo", nil];
	TTURLAction *action = [TTURLAction actionWithURLPath:@"mb://photoinfo"];
	[action applyAnimated:YES];
	[action setQuery:dict];
	[[TTNavigator navigator] openURLAction:action];
}

-(void)comments
{
	MBPhoto *p = (MBPhoto*)_centerPhoto;
	TTOpenURL([@"mb://comments/" stringByAppendingFormat:@"%d",p.photoId]);
}

- (void)dealloc {
	TTDINFO(@"DEALLOC: ShowPictureController");
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

@end
