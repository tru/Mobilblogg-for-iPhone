//
//  PhotoViewController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-17.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "PhotoViewController.h"
#import "MBPhoto.h"
#import "MBStore.h"

@implementation PhotoViewController

-(id)init
{
	self = [super init];
	_userCaption = nil;
	_userCaptionRight = nil;
	return self;
}

-(void)moveCaptions
{
	CGRect screenBounds = TTScreenBounds();
	CGFloat textWidth = screenBounds.size.width;
	CGFloat rightUnderBar = (self.height/2)-(screenBounds.size.height/2) + TTBarsHeight();
	CGFloat left = (self.width/2)-(screenBounds.size.width/2);
	
	
	CGFloat userCaptionY;
	
	if (_hidesCaption) {
		userCaptionY = rightUnderBar - TTBarsHeight();
	} else {
		userCaptionY = rightUnderBar;
	}
		
	if (_userCaption.text.length) {
		CGSize captionSize = [_userCaption sizeThatFits:CGSizeMake(textWidth, 0)];
		_userCaption.frame = CGRectMake(left, userCaptionY, textWidth, captionSize.height);
	} else {
		_userCaption.frame = CGRectZero;
	}
	
	if (_userCaptionRight.text.length) {
		CGSize captionSize = [_userCaptionRight sizeThatFits:CGSizeMake(textWidth, 0)];
		_userCaptionRight.frame = CGRectMake(left, userCaptionY, textWidth, captionSize.height);
	} else {
		_userCaptionRight.frame = CGRectZero;
	}
	
	CGRect r;
	
	if (_hidesCaption) {
		r = _captionLabel.frame;
		r.origin.y = floor(self.bounds.size.height + ((TTScreenBounds().size.height/2)-(self.bounds.size.height/2)) - _captionLabel.frame.size.height);
		_captionLabel.frame = r;
	} else {
		r = _captionLabel.frame;
		r.origin.y = (self.bounds.size.height / 2) + floor(TTScreenBounds().size.height/2 - (_captionLabel.frame.size.height+TTToolbarHeight()));
		_captionLabel.frame = r;
	}

	
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	[self moveCaptions];
}


-(TTStyle*)userCaptionStyle:(UITextAlignment)align andAlpha:(CGFloat)alph
{
  return
    [TTSolidFillStyle styleWithColor:[UIColor colorWithWhite:0 alpha:alph] next:
    [TTFourBorderStyle styleWithTop:RGBACOLOR(0, 0, 0, alph) width:1 next:
    [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(8, 8, 8, 8) next:
    [TTTextStyle styleWithFont:TTSTYLEVAR(photoCaptionFont) color:TTSTYLEVAR(photoCaptionTextColor)
                 minimumFontSize:0 shadowColor:[UIColor colorWithWhite:0 alpha:0.9]
                 shadowOffset:CGSizeMake(0, 1) textAlignment:align
                 verticalAlignment:UIControlContentVerticalAlignmentCenter
                 lineBreakMode:UILineBreakModeTailTruncation numberOfLines:6 next:nil]]]];
}

-(void)setHidesExtras:(BOOL)hidesExtras
{
	if (!hidesExtras) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:TT_FAST_TRANSITION_DURATION];
	}
	_hidesExtras = hidesExtras;
	_statusSpinner.alpha = _hidesExtras ? 0 : 1;
	_statusLabel.alpha = _hidesExtras ? 0 : 1;
	_captionLabel.alpha = _hidesExtras ? 0 : 1;
	_userCaption.alpha = _hidesExtras ? 0 : 1;
	_userCaptionRight.alpha = _hidesExtras ? 0 : 1;
	if (!hidesExtras) {
		[UIView commitAnimations];
	}
	
}

-(void)setHidesCaption:(BOOL)hidesCaption
{
	_hidesCaption = hidesCaption;
	
	if ([MBStore getBoolForKey:@"hideCaptions"] && _hidesCaption) {
		_captionLabel.alpha = 0;
		_userCaption.alpha = 0;
		_userCaptionRight.alpha = 0;
	} else {
		_captionLabel.alpha = 1;
		_userCaption.alpha = 1;
		_userCaptionRight.alpha = 1;
		[self moveCaptions];
	}
}

-(void)showCaption:(NSString*)caption
{
	[super showCaption:caption];

	if (!_userCaption) {
		_userCaption = [[TTLabel alloc] init];
		_userCaption.opaque = NO;
		_userCaption.style = [self userCaptionStyle:UITextAlignmentLeft andAlpha:0.5];
		[self addSubview:_userCaption];
	}

	if (!_userCaptionRight) {
		_userCaptionRight = [[TTLabel alloc] init];
		_userCaptionRight.opaque = NO;
		_userCaptionRight.style = [self userCaptionStyle:UITextAlignmentRight andAlpha:0];
		[self addSubview:_userCaptionRight];

	}

	_userCaption.text = ((MBPhoto*)_photo).user;
	_userCaptionRight.text = [((MBPhoto*)_photo).date formatRelativeTime];
	
	if ([MBStore getBoolForKey:@"hideCaptions"] && _hidesCaption) {
		_captionLabel.alpha = 0;
		_userCaption.alpha = 0;
		_userCaptionRight.alpha = 0;
	} else {
		_captionLabel.alpha = 1;
	}
}

-(void)dealloc
{
	[_userCaption release];
	[_userCaptionRight release];
	[super dealloc];
}

@end
