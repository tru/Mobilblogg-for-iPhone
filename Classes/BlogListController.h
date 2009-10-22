//
//  BlogListController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "MBAPI.h"

@interface BlogListController : TTTableViewController {
	NSString *name;
	MBAPI *mbapi;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) MBAPI *mbapi;

-(id)initWithName:(NSString *)nameStr;

@end
