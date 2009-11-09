//
//  ShowPictureController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "ShowPictureController.h"
#import "MBPhoto.h"
#import "PhotoSource.h"

@implementation ShowPictureController

-(id)initWithNavigatorURL:(NSURL*)url query:(NSDictionary*)query
{
	self = [super init];
	
	NSArray *photoList = [query objectForKey:@"photoList"];
	for (MBPhoto *p in photoList) {
		NSUInteger myPID = [[query objectForKey:@"photoId"] intValue];
		if (p.photoId == myPID) {
			_photo = p;
			break;
		}
	}
	
	self.photoSource = [[[PhotoSource alloc] initWithPhotos:photoList] autorelease];
	self.centerPhoto = _photo;
	
	return self;
}

-(void)loadView
{
	[super loadView];
	UIBarItem* space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
						 UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	
	UIButton *infoUIButton = [[UIButton buttonWithType:UIButtonTypeInfoLight] autorelease];
	[infoUIButton addTarget:self action:@selector(photoInfo) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *info = [[UIBarButtonItem alloc] initWithCustomView:infoUIButton];
	
	NSArray *items = [NSArray arrayWithObjects:space, _previousButton, space, _nextButton, space, info, nil];
	
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
	[[TTNavigator navigator] openURL:[@"mb://comments/" stringByAppendingFormat:@"%d",_photo.photoId] animated:YES];
}

- (void)dealloc {
	NSLog(@"DEALLOC: ShowPictureController");
	[super dealloc];
}


@end
