//
//  MBStore.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBStore.h"


@implementation MBStore

+ (NSString*)_getStoreOrCreate
{
	NSFileManager *mgr = [NSFileManager defaultManager];
	NSString *path = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	path = [path stringByAppendingPathComponent:@"mobilblog"];
	
	BOOL isDir;
	if (![mgr fileExistsAtPath:path isDirectory:&isDir] || !isDir) {
		[mgr createDirectoryAtPath:path attributes:nil];
	}

	NSString *archive = [path stringByAppendingPathComponent:@"store.archive"];

	return archive;
}

+ (NSDictionary*)_getStore
{
	NSFileManager *mgr = [NSFileManager defaultManager];
	NSString *archive = [self _getStoreOrCreate];
	NSDictionary *retdict;
	if (![mgr fileExistsAtPath:archive]) {
		retdict = [[NSDictionary alloc] init];
		[NSKeyedArchiver archiveRootObject:retdict toFile:archive];
		[retdict release];
	}
	retdict = [NSKeyedUnarchiver unarchiveObjectWithFile:archive];
	return retdict;
}

+ (BOOL)_saveStore:(NSDictionary*)dict
{
	NSString *archive = [self _getStoreOrCreate];
	return [NSKeyedArchiver archiveRootObject:dict toFile:archive];
}

+ (NSString*)getUserName
{
	NSDictionary *dict = [self _getStore];
	return [dict objectForKey:@"username"];
}

+ (BOOL)saveUserName:(NSString*)username
{
	NSLog(@"Saving username %@", username);
	NSMutableDictionary *dict = [[self _getStore] mutableCopy];
	[dict setObject:username forKey:@"username"];
	return [self _saveStore:dict];
}

@end
