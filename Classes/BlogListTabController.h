//
//  BlogListTabController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-11.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "BlogListModel.h"
#import "BlogListController.h"
#import "BlogListThumbsController.h"

@interface BlogListTabController : UITabBarController<UITabBarControllerDelegate> {
	NSAutoreleasePool *_pool;
	BlogListController *_list;
	BlogListThumbsController *_photos;
}
-(id)initWithArguments:(NSDictionary*)arguments;
-(id)initWithBloggName:(NSString*)bloggName;
-(id)initWithFunction:(NSString*)functionName;

@end
