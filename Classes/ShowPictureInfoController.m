//
//  ShowPictureInfoController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-09.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "ShowPictureInfoController.h"


@implementation ShowPictureInfoController

-(id)initWithNavigatorURL:(NSURL*)url query:(NSDictionary*)query
{
	self = [super init];
	_photo = [query objectForKey:@"photo"];
	[_photo retain];
	self.title = _photo.caption;
	self.variableHeightRows = YES;
	self.tableViewStyle = UITableViewStyleGrouped;
	
	MBUser *user = [[MBUser alloc] initWithUserName:_photo.user];
	user.delegate = self;
	
	[user release];
	
	return self;
}

-(void)createModel
{
	_userItem = [TTTableImageItem itemWithText:_photo.user];
	_userItem.imageURL = @"http://mobilblogg.nu/cache/ttf/011086f0e011367f52.gif";
	
	_userItem.imageStyle = [TTImageStyle styleWithImageURL:nil
											  defaultImage:TTIMAGE(@"bundle://Three20.bundle/images/empty.png")
											   contentMode:UIViewContentModeScaleAspectFill
													  size:CGSizeMake(60, 60) next:TTSTYLE(rounded)];
	
	TTTableImageItem *image = [TTTableImageItem itemWithText:_photo.caption];
	image.imageURL = _photo.URL;
	image.imageStyle = [TTImageStyle styleWithImageURL:nil
										  defaultImage:TTIMAGE(@"bundle://Three20.bundle/images/empty.png")
										   contentMode:UIViewContentModeScaleAspectFill
												  size:CGSizeMake(120, 120) next:TTSTYLE(rounded)];
	
	NSMutableArray *items = [NSMutableArray arrayWithObject:image];
	
	if (_photo.body.length) {
		TTTableStyledTextItem *bodyItem = nil;
		NSString *body = [_photo.body stringByReplacingOccurrencesOfString:@"<br>" withString:@"<br/>"];
		bodyItem = [TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:body]];
		[items addObject:bodyItem];
	}
	
	if (_photo.date) {
		[items addObject:[TTTableLongTextItem itemWithText:[NSString stringWithFormat:NSLocalizedString(@"Taken at %@", nil), [_photo.date formatDateTime]]]];
	}
	
	if (_photo.location) {
		_positionItem = [TTTableLongTextItem itemWithText:NSLocalizedString(@"Image position: ", nil)];
														   
		[items addObject:_positionItem];
		
		MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:_photo.location.coordinate];
		geocoder.delegate = self;
		[geocoder start];
//		[geocoder release];
		
	}
	
	NSArray *author = [NSArray arrayWithObjects:
								_userItem,
								[TTTableTextItem itemWithText:@"User photos" URL:[NSString stringWithFormat:@"mb://listblog/%@", _photo.user]],
								[TTTableTextItem itemWithText:@"User profile" URL:[NSString stringWithFormat:@"mb://profile/%@", _photo.user]],
								nil];

	
	self.dataSource = [TTSectionedDataSource dataSourceWithArrays:@"Photo", items, @"Author", author, nil];
}

-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	TTDINFO(@"Did find placemark!");
	
	NSString *locality;
	
	if (placemark.thoroughfare) {
		locality = placemark.thoroughfare;
	} else if (placemark.locality) {
		locality = placemark.locality;
	} else if (placemark.administrativeArea) {
		locality = placemark.administrativeArea;
	} else {
		locality = NSLocalizedString(@"Somewhere", nil);
	}
	
	_positionItem.text = [NSString stringWithFormat:NSLocalizedString(@"Image position: %@, %@", nil), locality, placemark.country];
	[self.tableView reloadData];
}

-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	TTDINFO(@"Did NOT find placemark!");
	_positionItem.text = NSLocalizedString(@"Image position: unknown", nil);
	[self.tableView reloadData];
}

-(void)MBUserDidReceiveInfo:(MBUser *)user
{
	TTDINFO(@"User info! %@", user.avatarURL);
	_userItem.imageURL = user.avatarURL;
	[self.tableView reloadData];
}

-(void)MBUser:(MBUser *)user didFailWithError:(NSError *)err
{
	TTDINFO(@"MBUser fail!");
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: ShowPictureInfoController");
	[_photo release];
	[super dealloc];
}

@end
