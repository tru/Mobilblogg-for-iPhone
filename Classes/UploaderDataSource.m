//
//  UploaderDataSource.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "UploaderDataSource.h"
#import "UploaderImageCell.h"

@implementation UploaderDataSource

-(Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[UploaderImageItem class]]) {
		return [UploaderImageCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

@end

