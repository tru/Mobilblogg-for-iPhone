//
//  MBPhotoItemCell.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBPhotoItemCell.h"
#import "NSString+MBAPI.h"

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

@implementation MBPhotoItemCell


///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell class public

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	MBPhoto* item = object;
	
	CGFloat height = TTSTYLEVAR(tableFont).ttLineHeight + kVPadding*2;
	if (item.user) {
		height += TTSTYLEVAR(font).ttLineHeight;
	}
	
	return height;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {
		_imageView2 = nil;
		
		self.textLabel.font = TTSTYLEVAR(tableFont);
		self.textLabel.textColor = TTSTYLEVAR(textColor);
		self.textLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
		self.textLabel.textAlignment = UITextAlignmentLeft;
		self.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
		self.textLabel.adjustsFontSizeToFitWidth = YES;
		
		self.detailTextLabel.font = TTSTYLEVAR(font);
		self.detailTextLabel.textColor = TTSTYLEVAR(tableSubTextColor);
		self.detailTextLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
		self.detailTextLabel.textAlignment = UITextAlignmentLeft;
		self.detailTextLabel.contentMode = UIViewContentModeTop;
		self.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
		self.detailTextLabel.numberOfLines = kMessageTextLineCount;
		
		_commentView = [[CommentIconView alloc] initWithNumComments:0 andColorBlack:YES];
		[self addSubview:_commentView];
		[_commentView addTarget:self action:@selector(gotoComments) forControlEvents:UIControlEventTouchUpInside];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateComments:) name:@"commentSentForPhotoId" object:nil];
	}
	return self;
}

-(void)updateComments:(NSNotification*)notif
{
	NSInteger photoId = [[[notif userInfo] objectForKey:@"photoId"] intValue];
	if (photoId == _photo.photoId) {
		_commentView.numberComments += 1;
		_photo.numcomments += 1;
	}
}

-(void)gotoComments
{
	NSString *url = [NSString stringWithFormat:@"mb://comments/%d", ((MBPhoto*)_item).photoId];
	TTOpenURL(url);
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_imageView2);
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
	[super layoutSubviews];
    
	CGFloat height = self.contentView.height;
	CGFloat width = self.contentView.width - (height + kSmallMargin);
	CGFloat left = 0;
	
	if (_imageView2) {
		_imageView2.frame = CGRectMake(0, 0, height, height);
		left = _imageView2.right + kSmallMargin;
	} else {
		left = kHPadding;
	}
	
	if (self.detailTextLabel.text.length) {
		CGFloat textHeight = self.textLabel.font.ttLineHeight;
		CGFloat subtitleHeight = self.detailTextLabel.font.ttLineHeight;
		CGFloat paddingY = floor((height - (textHeight + subtitleHeight))/2);
		
		self.textLabel.frame = CGRectMake(left, paddingY, width, textHeight);
		self.detailTextLabel.frame = CGRectMake(left, self.textLabel.bottom, width, subtitleHeight);
	} else {
		self.textLabel.frame = CGRectMake(_imageView2.right + kSmallMargin, 0, width, height);
		self.detailTextLabel.frame = CGRectZero;
	}
	
	_commentView.frame = CGRectMake(width+20+(kSmallMargin*2), (height/2)-9, 20, 18);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (void)setObject:(id)object {
	if (_item != object) {
		[_item release];
		_item = [object retain];
		
		MBPhoto* photo = object;
		if (photo.caption.length) {
			self.textLabel.text = [photo.caption wordWrapToLength:23];
		} else {
			self.textLabel.text = @"";
		}
		
		if (photo.user.length) {
			NSMutableString *subtitle = [NSMutableString stringWithFormat:@"By: %@", photo.user];
			if (photo.date) {
				[subtitle appendFormat:@" - %@", [photo.date formatRelativeTime]];
			}
			
			self.detailTextLabel.text = subtitle;
		} else {
			self.detailTextLabel.text = NSLocalizedString(@"No user", nil);
		}
		self.imageView2.defaultImage = TTIMAGE(@"bundle://Three20.bundle/images/empty.png");
		if (photo.URL) {
			self.imageView2.URL = photo.URL;
		}
		_commentView.numberComments = photo.numcomments;
		_photo = photo;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (UILabel*)subtitleLabel {
	return self.detailTextLabel;
}

- (TTImageView*)imageView2 {
	if (!_imageView2) {
		_imageView2 = [[TTImageView alloc] init];
		//    _imageView2.defaultImage = TTSTYLEVAR(personImageSmall);
		//    _imageView2.style = TTSTYLE(threadActorIcon);
		[self.contentView addSubview:_imageView2];
	}
	return _imageView2;
}

@end
