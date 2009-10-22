//
//  MBStore.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MBStore : NSObject {
}

+ (NSString*)getUserName;
+ (BOOL)saveUserName:(NSString*) username;

@end
