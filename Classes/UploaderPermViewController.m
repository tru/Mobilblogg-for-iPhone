//
//  UploaderPermViewController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-12-14.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "UploaderPermViewController.h"
#import "MBStore.h"

@implementation UploaderPermItemCell

- (void)setObject:(id)object {
	[super setObject:object];
	UploaderPermItem *item = object;
	if (item.checkMark) {
		self.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		self.accessoryType = UITableViewCellAccessoryNone;
	}
}

@end

@implementation UploaderPermItem

@synthesize value = _value;

+(id)itemWithText:(NSString*)text andValue:(NSString*)value
{
	UploaderPermItem *itm = [super itemWithText:text];
	itm.value = value;
	itm.URL = @"mb://foobar";
	return itm;
}

@synthesize checkMark = _checkMark;

@end


@implementation UploaderPermDataSource

@synthesize currentItem = _currentItem;

-(Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[UploaderPermItem class]]) {
		return [UploaderPermItemCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

-(void)setCheckMark:(NSUInteger)pos
{
	UploaderPermItem *item = [self.items objectAtIndex:pos];
	if (item == _currentItem)
		return;
	
	item.checkMark = YES;
	if (_currentItem) {
		_currentItem.checkMark = NO;
	}
	
	_currentItem = item;
}

@end


@implementation UploaderPermViewController

@synthesize delegate = _delegate;

-(id)init
{
	self = [super init];
	self.title = NSLocalizedString(@"Photo visible to:", nil);
	self.tableViewStyle = UITableViewStyleGrouped;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						   target:self action:@selector(cancel)] autorelease];

	self.dataSource = [UploaderPermDataSource dataSourceWithObjects:
					   [UploaderPermItem itemWithText:NSLocalizedString(@"All", nil) andValue:@""],
					   [UploaderPermItem itemWithText:NSLocalizedString(@"All (excluded from first page)", nil) andValue:@"blog"],
					   [UploaderPermItem itemWithText:NSLocalizedString(@"Members", nil) andValue:@"members"],
					   [UploaderPermItem itemWithText:NSLocalizedString(@"Friends", nil) andValue:@"friends"],
					   [UploaderPermItem itemWithText:NSLocalizedString(@"Private (only me)", nil) andValue:@"private"],
					   nil
					   ];
	NSString *selValue = [MBStore getObjectForKey:@"permissionValue"];
	TTDINFO(@"selValue = %@", selValue);
	if (!selValue) {
		[((UploaderPermDataSource*)self.dataSource) setCheckMark:0];
	} else if ([selValue isEqualToString:@"blog"]) {
		[((UploaderPermDataSource*)self.dataSource) setCheckMark:1];
	} else if ([selValue isEqualToString:@"members"]) {
		[((UploaderPermDataSource*)self.dataSource) setCheckMark:2];
	} else if ([selValue isEqualToString:@"friends"]) {
		[((UploaderPermDataSource*)self.dataSource) setCheckMark:3];
	} else if ([selValue isEqualToString:@"private"]) {
		[((UploaderPermDataSource*)self.dataSource) setCheckMark:4];
	} else {
		TTDWARNING(@"permissionValue was set to something wierd!");
		[((UploaderPermDataSource*)self.dataSource) setCheckMark:0];
	}
	
	return self;
}

-(void)timeOut
{
	[self.tableView reloadData];

	[self dismissModalViewControllerAnimated:YES];

	if ([_delegate respondsToSelector:@selector(didSelectPermValue:)]) {
		[_delegate performSelector:@selector(didSelectPermValue:) withObject:self];
	}
	
}

-(void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
	[((UploaderPermDataSource*)self.dataSource) setCheckMark:indexPath.row];
	NSTimer *tm = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:tm forMode:NSDefaultRunLoopMode];
}

-(BOOL)shouldOpenURL:(NSString *)URL
{
	if ([URL isEqualToString:@"mb://foobar"]) {
		return NO;
	}
	
	return YES;
}

-(NSString*)selectedValue
{
	return ((UploaderPermDataSource*)self.dataSource).currentItem.value;
}

-(NSString*)selectedName
{
	return ((UploaderPermDataSource*)self.dataSource).currentItem.text;
}

-(void)cancel
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
