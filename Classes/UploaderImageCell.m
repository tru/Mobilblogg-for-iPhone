//
//  MBPhotoItemCell.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "UploaderImageCell.h"
#import "MBImageUtils.h"

static const CGFloat kHPadding = 10;
static const CGFloat kVPadding = 10;
static const CGFloat kMargin = 10;
static const CGFloat kSmallMargin = 6;
static const CGFloat kSpacing = 8;
static const CGFloat kControlPadding = 8;
static const CGFloat kDefaultTextViewLines = 5;
static const CGFloat kMoreButtonMargin = 40;

static const CGFloat kKeySpacing = 12;
static const CGFloat kKeyWidth = 75;
static const CGFloat kMaxLabelHeight = 2000;
static const CGFloat kDisclosureIndicatorWidth = 23;

static const NSInteger kMessageTextLineCount = 2;


@implementation UploaderImageItem

@synthesize image = _image;

-(void)dealloc
{
	[_image release];
	[super dealloc];
}

@end


@implementation UploaderImageCell

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell class public

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	UploaderImageItem *item = object;
	if (item.image) {
		return [MBImageUtils imageSize:item.image.size withAspect:CGSizeMake(200, 200)].height + (kHPadding * 2);
	} else {
		return kHPadding * 2;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {
		_imgView = nil;
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_imgView);
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGSize siz = [MBImageUtils imageSize:_imgView.image.size withAspect:CGSizeMake(200, 200)];
	
	CGFloat left = kSmallMargin + ((self.contentView.width/2) - (siz.width/2));
	
	_imgView.frame = CGRectMake(left, kHPadding, siz.width, siz.height);
//	TTLOGRECT(_imgView.frame);
	left = _imgView.right + kSmallMargin;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (void)setObject:(id)object {
	if (_item != object) {
		[_item release];
		_item = [object retain];
		
		
//		TTDINFO("Setting image!");
		
		UIImage *image = ((UploaderImageItem*)object).image;
//		TTLOGSIZE(image.size);
		if (!_imgView) {
			_imgView = [[UIImageView alloc] initWithImage:image];
			[self addSubview:_imgView];
		} else {
			_imgView.image = image;
		}
	}
}

@end
