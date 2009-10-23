//
//  BlogListController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface BlogListController : TTTableViewController {
	NSString *name;
}
@property (nonatomic, copy) NSString *name;

-(id)initWithName:(NSString *)nameStr;

@end
