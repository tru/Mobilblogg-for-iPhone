//
//  BlogListDataSource.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-23.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface BlogListDataSource : TTListDataSource {
	TTTableViewController *_tableCtrl;
}

@property (nonatomic, retain) TTTableViewController *tableCtrl;

@end
