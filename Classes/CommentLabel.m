//
//  CommentLabel.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2010-03-15.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import "CommentLabel.h"


@implementation CommentLabel

-(id)initWithNumberOfComments:(NSUInteger)comments
{
	self = [super init];
	
	_image = [[TTImageView alloc] init];
	_image.urlPath = @"bundle://commentView.png";
	_image.autoresizesToImage = YES;
	
	_numbers = [[TTLabel alloc] init];
	self.numberOfComments = comments;
	
	return self;
}

-(void)layoutSubviews
{
	[self addSubview:_image];
	_image.userInteractionEnabled = NO;
	
	[self addSubview:_numbers];
	_numbers.frame = CGRectMake(25, 4, 75, 17);
	_numbers.backgroundColor = [UIColor clearColor];
	_numbers.style = [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
										  color:[UIColor blackColor]
								minimumFontSize:8
									shadowColor:nil
								   shadowOffset:CGSizeZero
								  textAlignment:UITextAlignmentCenter
							  verticalAlignment:UIControlContentVerticalAlignmentCenter
								  lineBreakMode:UILineBreakModeCharacterWrap
								  numberOfLines:1
										   next:nil];
	
	_numbers.userInteractionEnabled = NO;
	
	
}

-(void)setNumberOfComments:(NSUInteger)numComments
{
	if (numComments == 1) {
		_numbers.text = [NSString stringWithFormat:NSLocalizedString(@"%d comment", nil), numComments];
	} else if (numComments > 1) {
		_numbers.text = [NSString stringWithFormat:NSLocalizedString(@"%d comments", nil), numComments];
	} else {
		_numbers.text = NSLocalizedString(@"no comments", nil);
	}
	_numberOfComments = numComments;
}

@synthesize numberOfComments = _numberOfComments;

@end
