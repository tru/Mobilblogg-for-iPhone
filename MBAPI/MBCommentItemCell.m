//
//  MBCommentItemCell.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-16.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBCommentItemCell.h"
#import "MBComment.h"

@implementation MBCommentItemCell

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

static const CGFloat kDefaultImageSize = 50;
static const CGFloat kDefaultMessageImageWidth = 34;
static const CGFloat kDefaultMessageImageHeight = 34;

+(CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	MBComment *item = object;
	
	if (!item.comment.font) {
		item.comment.font = TTSTYLEVAR(font);
	}
	
	item.comment.width = tableView.width - (kSmallMargin + kDefaultMessageImageHeight + kSmallMargin) - [tableView tableCellMargin] * 2;
  
	return 40 + item.comment.height;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {
		_titleLabel = nil;
		_timestampLabel = nil;
		_imageView2 = nil;
		_styledText = nil;
		
		self.textLabel.font = TTSTYLEVAR(font);
		self.textLabel.textColor = TTSTYLEVAR(textColor);
		self.textLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
		self.textLabel.textAlignment = UITextAlignmentLeft;
		self.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
		self.textLabel.adjustsFontSizeToFitWidth = YES;
		self.textLabel.contentMode = UIViewContentModeLeft;
		
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_titleLabel);
	TT_RELEASE_SAFELY(_timestampLabel);
	TT_RELEASE_SAFELY(_imageView2);
	TT_RELEASE_SAFELY(_styledText);
	[super dealloc];
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat left = 0;
	if (_imageView2) {
		_imageView2.frame = CGRectMake(kSmallMargin, kSmallMargin,
									   kDefaultMessageImageWidth, kDefaultMessageImageHeight);
		left += kSmallMargin + kDefaultMessageImageHeight + kSmallMargin;
	} else {
		left = kMargin;
	}
	
	CGFloat width = self.contentView.width - left;
	CGFloat top = kSmallMargin;
	
	if (_titleLabel.text.length) {
		_titleLabel.frame = CGRectMake(left, top, width, _titleLabel.font.ttLineHeight);
		top += _titleLabel.height;
	} else {
		_titleLabel.frame = CGRectZero;
	}
	
	if (self.styledText) {
		/* This line took me ~3 hours to figure out. I am stupid */
		_styledText.frame = CGRectMake(left, top, width, self.contentView.height - top);
	} else {
		_styledText.frame = CGRectZero;
	}
		

	if (_timestampLabel.text.length) {
		_timestampLabel.alpha = !self.showingDeleteConfirmation;
		[_timestampLabel sizeToFit];
		_timestampLabel.left = self.contentView.width - (_timestampLabel.width + kSmallMargin);
		_timestampLabel.top = _titleLabel.top;
		_titleLabel.width -= _timestampLabel.width + kSmallMargin*2;
	} else {
		_titleLabel.frame = CGRectZero;
	}
}

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	if (self.superview) {
		_imageView2.backgroundColor = self.backgroundColor;
		_titleLabel.backgroundColor = self.backgroundColor;
		_timestampLabel.backgroundColor = self.backgroundColor;
		_styledText.backgroundColor = self.backgroundColor;
	}
}

- (void)setObject:(id)object {
	if (_item != object) {
		[super setObject:object];
		
		MBComment* item = object;
		if (item.user.length) {
			self.titleLabel.text = item.user;
		}
		if (item.date) {
			self.timestampLabel.text = [item.date formatRelativeTime];
		}
		if (item.imageURL) {
			self.imageView2.URL = item.imageURL;
		}
		if (item.comment) {
			self.styledText.text = item.comment;
			//_styledText.contentInset = item.padding;
			[self setNeedsLayout];
		}
	}  
}

- (UILabel*)titleLabel {
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] init];
		_titleLabel.textColor = [UIColor blackColor];
		_titleLabel.highlightedTextColor = [UIColor whiteColor];
		_titleLabel.font = TTSTYLEVAR(tableFont);
		_titleLabel.contentMode = UIViewContentModeLeft;
		[self.contentView addSubview:_titleLabel];
	}
	return _titleLabel;
}

- (UILabel*)timestampLabel {
	if (!_timestampLabel) {
		_timestampLabel = [[UILabel alloc] init];
		_timestampLabel.font = TTSTYLEVAR(tableTimestampFont);
		_timestampLabel.textColor = TTSTYLEVAR(timestampTextColor);
		_timestampLabel.highlightedTextColor = [UIColor whiteColor];
		_timestampLabel.contentMode = UIViewContentModeLeft;
		[self.contentView addSubview:_timestampLabel];
	}
	return _timestampLabel;
}

- (TTImageView*)imageView2 {
	if (!_imageView2) {
		_imageView2 = [[TTImageView alloc] init];
		[self.contentView addSubview:_imageView2];
	}
	return _imageView2;
}

-(TTStyledTextLabel*)styledText
{
	if (!_styledText) {
		_styledText = [[TTStyledTextLabel alloc] init];
		_styledText.contentMode = UIViewContentModeLeft;
		[self.contentView addSubview:_styledText];
	}
	return _styledText;
}

@end
