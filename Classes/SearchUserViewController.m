//
//  SearchUserViewController.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "SearchUserViewController.h"
#import "SearchUserDataSource.h"

@implementation SearchUserViewController

-(id)init
{
	self = [super init];
		
	self.title = @"Search User";
	self.dataSource = [TTListDataSource dataSourceWithItems:nil];
	
	return self;
}

-(void)viewDidLoad
{
	TTTableViewController *searchCtrl = [[TTTableViewController alloc] init];
	searchCtrl.dataSource = [[SearchUserDataSource alloc] init];
	self.searchViewController = searchCtrl;
	self.tableView.tableHeaderView = _searchController.searchBar;
}


- (void)dealloc {
    [super dealloc];
}


@end
