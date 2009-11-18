//
//  PhotoViewController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-17.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "PhotoViewController.h"
#import "MBPhoto.h"

@implementation PhotoViewController

-(id)init
{
	self = [super init];
	_userCaption = nil;
	_userCaptionRight = nil;
	return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect screenBounds = TTScreenBounds();
	CGFloat textWidth = screenBounds.size.width;
	CGFloat rightUnderBar = (self.height/2)-(screenBounds.size.height/2) + TTBarsHeight();
	CGFloat left = (self.width/2)-(screenBounds.size.width/2);
	
	if (_userCaption.text.length) {
		CGSize captionSize = [_userCaption sizeThatFits:CGSizeMake(textWidth, 0)];
		_userCaption.frame = CGRectMake(left, rightUnderBar, textWidth, captionSize.height);

	} else {
		_userCaption.frame = CGRectZero;
	}
	if (_userCaptionRight.text.length) {
		CGSize captionSize = [_userCaptionRight sizeThatFits:CGSizeMake(textWidth, 0)];
		_userCaptionRight.frame = CGRectMake(left, rightUnderBar, textWidth, captionSize.height);

	} else {
		_userCaptionRight.frame = CGRectZero;
	}
	
}

-(TTStyle*)myPhotoCaption:(UITextAlignment)align andAlpha:(CGFloat)alph
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
	//[super setHidesExtras:hideExtras];
	_captionLabel.alpha = 1;
}

-(void)setHidesCaption:(BOOL)hidesCaption
{
	_hidesCaption = hidesCaption;
//	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationDelay:TT_FAST_TRANSITION_DURATION];
	if (hidesCaption) {
		CGRect r = _userCaption.frame;
		r.origin.y = floor((self.bounds.size.height / 2) - (TTScreenBounds().size.height/2));
		_userCaption.frame = r;
		_userCaptionRight.frame = r;
		
		r = _captionLabel.frame;
		r.origin.y = floor(self.bounds.size.height + ((TTScreenBounds().size.height/2)-(self.bounds.size.height/2)) - _captionLabel.frame.size.height);
		_captionLabel.frame = r;
	} else {
		CGRect r = _userCaption.frame;
		r.origin.y = (self.bounds.size.height / 2) - (TTScreenBounds().size.height/2) + TTBarsHeight();
		_userCaption.frame = r;
		_userCaptionRight.frame = r;
		
		r = _captionLabel.frame;
		r.origin.y = (self.bounds.size.height / 2) + floor(TTScreenBounds().size.height/2 - (_captionLabel.frame.size.height+TTToolbarHeight()));
		_captionLabel.frame = r;

	}
//	[UIView	commitAnimations];
}

-(void)showCaption:(NSString*)caption
{
	NSLog(@"Show caption called");
	[super showCaption:caption];
	if (!_userCaptionRight) {
		_userCaptionRight = [[TTLabel alloc] init];
		_userCaptionRight.opaque = NO;
		_userCaptionRight.style = [self myPhotoCaption:UITextAlignmentRight andAlpha:0];
//		_userCaptionRight.alpha = _hidesCaption ? 0 : 1;
		[self addSubview:_userCaptionRight];

	}
	if (!_userCaption) {
		_userCaption = [[TTLabel alloc] init];
		_userCaption.opaque = NO;
		_userCaption.style = [self myPhotoCaption:UITextAlignmentLeft andAlpha:0.5];
//		_userCaption.alpha = _hidesCaption ? 0 : 1;
		[self addSubview:_userCaption];
	}
	_captionLabel.alpha = 1;
	_userCaption.text = ((MBPhoto*)_photo).user;
	_userCaptionRight.text = [((MBPhoto*)_photo).date formatRelativeTime];
}

-(void)dealloc
{
	[_userCaption release];
	[_userCaptionRight release];
	[super dealloc];
}

@end
