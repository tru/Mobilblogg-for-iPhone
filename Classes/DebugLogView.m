//
//  DebugLogView.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2010-02-19.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import "DebugLogView.h"
#import "Three20/Three20.h"

@implementation DebugLogView

-(id)init
{
	self = [super init];
	_textView = [[UITextView alloc] init];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *logPath = [documentsDirectory
						 stringByAppendingPathComponent:@"console.log"];

	NSData *data = [[NSFileManager defaultManager] contentsAtPath:logPath];
	_textView.text = [NSString stringWithUTF8String:[data bytes]];
	TTDINFO("logtext = %@", _textView.text);
	_textView.frame = [self.view bounds];
	_textView.editable = NO;
	
	[self.view addSubview:_textView];
	
	return self;
}

@end
