//
//  BlogListController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "BlogListController.h"
#import "BlogListModel.h"
#import "BlogListDataSource.h"
#import "MBPhoto.h"
#import "ShowPictureController.h"
#import "BlogListThumbsDataSource.h"

@implementation BlogListController

-(id)initWithBloggName:(NSString*)bloggName
{
	NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
							   bloggName, @"user",
							   @"listBlogg", @"func",
							   nil];
	
	self.title = [NSString stringWithFormat:NSLocalizedString(@"Photos by %@", nil), bloggName];
	
	return [self initWithArguments:arguments];
}

-(id)initWithFunction:(NSString*)functionName
{
	NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
							   functionName, @"func",
							   nil];
	
	if ([functionName isEqualToString:@"listFirstpage"]) {
		self.title = NSLocalizedString(@"First Page", nil);
	} else if ([functionName isEqualToString:@"listStartpage"]) {
		self.title = NSLocalizedString(@"My Start Page", nil);
	}
	
	return [self initWithArguments:arguments];
}


-(id)initWithArguments:(NSDictionary*)arguments
{
	self = [super init];
	self.title = NSLocalizedString(@"List view", nil);
	self.variableHeightRows = YES;
	
	id<TTTableViewDataSource> ds = [BlogListDataSource dataSourceWithItems:nil];
	ds.model = [[[BlogListModel alloc] initWithArguments:arguments] autorelease];
	self.dataSource = ds;
	
	self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:TTIMAGE(@"bundle://41-picture-frame.png") tag:0];

	return self;
}

-(void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath
{
	if ([object isKindOfClass:[MBPhoto class]]) {
		MBPhoto *photo = ((MBPhoto*)object);
		ShowPictureController *ctrl = [[[ShowPictureController alloc] init] autorelease];
		photo.photoSource = [[[BlogListThumbsDataSource alloc] initWithModel:(BlogListModel*)self.dataSource.model] autorelease];
		ctrl.centerPhoto = photo;
		[self.navigationController pushViewController:ctrl animated:YES];
	} else {
		[super didSelectObject:object atIndexPath:indexPath];
	}
}

/* Since we have our own object MBTablePhotoItem and pop in our
 * own ShowPictureController when they are selected we need to
 * tell the controller not to open the dummy URL we have for these
 * items.
 */
-(BOOL)shouldOpenURL:(NSString *)URL
{
	if ([URL isEqualToString:@"mb://foobar"]) {
		return NO;
	}
	
	return YES;
}

-(void)refresh
{
	TTDINFO(@"Refreshing");
	[self reload];
}

-(void)dealloc
{
	TTDINFO(@"DEALLOC: BlogListController");
	[super dealloc];
}

@end
