//
//  CommentIconView.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "CommentIconView.h"


@implementation CommentIconView

@synthesize numberComments = _numberComments;

-(id)initWithNumComments:(NSUInteger)numberComments andColorBlack:(BOOL)black
{
	self = [super init];
	self.numberComments = numberComments;
	_image = [[TTImageView alloc] init];
	if (black) {
		_image.image = TTIMAGE(@"bundle://08-chatblack.png");
	} else {
		_image.image = TTIMAGE(@"bundle://08-chat.png");
	}
	_image.autoresizesToImage = YES;
	_image.userInteractionEnabled = NO;
	_commentLabel = [[TTLabel alloc] initWithText:[NSString stringWithFormat:@"%d", numberComments]];
	_commentLabel.backgroundColor = [UIColor clearColor];
	
	UIColor *col;
	if (black) {
		col = [UIColor whiteColor];
	} else {
		col = [UIColor blackColor];
	}
	
	_commentLabel.style = [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:10]
											   color:col
									 minimumFontSize:0
										 shadowColor:nil
										shadowOffset:CGSizeMake(0,0)
									   textAlignment:UITextAlignmentCenter
								   verticalAlignment:UIControlContentVerticalAlignmentCenter
									   lineBreakMode:UILineBreakModeCharacterWrap
									   numberOfLines:1
												next:nil];
	_commentLabel.userInteractionEnabled = NO;
	self.frame = _image.bounds;
	_commentLabel.frame = CGRectMake(2, 2, 16, 9);

	return self;
}

-(id)initWithNumComments:(NSUInteger)numberComments
{
	return [self initWithNumComments:numberComments andColorBlack:NO];
}

-(void)setNumberComments:(NSUInteger)numb
{
	_commentLabel.text = [NSString stringWithFormat:@"%d", numb];
	_numberComments = numb;
}

-(void)layoutSubviews
{
	[self addSubview:_image];
	[self addSubview:_commentLabel];
}

-(void)dealloc
{
	[_image release];
	[_commentLabel release];
	[super dealloc];
}

@end
