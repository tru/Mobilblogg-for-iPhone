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

-(id)initWithId:(id)pictureId
{
	self = [super init];
	
	_photo = [MBPhoto getPhotoById:[pictureId intValue]];
	if (!_photo) {
		NSLog(@"Ouch no photo in the global store...");
		return nil;
	}
	self.photoSource = [[PhotoSource alloc] initWithPhotos:[NSArray arrayWithObject:_photo]];
	
	return self;
}

-(void)loadView
{
	[super loadView];
	UIBarItem* space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
						 UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	UIBarButtonItem *comments = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(comments)];
	NSArray *items = [NSArray arrayWithObjects:space, _previousButton, space, _nextButton, space, comments, nil];
	_toolbar.items = items;
}

-(void)comments
{
	[[TTNavigator navigator] openURL:[@"mb://comments/" stringByAppendingFormat:@"%d",_photo.photoId] animated:YES];
}

- (void)dealloc {
    [super dealloc];
}


@end
