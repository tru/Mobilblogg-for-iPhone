//
//  MBStore.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-10-22.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "MBStore.h"
#import <Security/Security.h>
#import "SFHFKeychainUtils.h"

@implementation MBStore

+(void)setObject:(id)object forKey:(NSString*)key
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:object forKey:key];
}

+(id)getObjectForKey:(NSString*)key
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:key];
}

+(NSString*)getUserName
{
	return [self getObjectForKey:@"username"];
}

+(void)saveUserName:(NSString *)username
{
	return [self setObject:username	forKey:@"username"];
}

+(void)savePassword:(NSString *)password forUsername:(NSString*)username
{
	NSError *err;
	
	[SFHFKeychainUtils storeUsername:username
						 andPassword:password
					  forServiceName:@"MobilBlogg"
					  updateExisting:YES
							   error:&err];
	
	if (err) {
		NSLog(@"Couldn't store password!");
	}
}

+(NSString*)getPasswordForUsername:(NSString*)username
{
	NSError *err;
	NSString *pass = [SFHFKeychainUtils getPasswordForUsername:username
												andServiceName:@"MobilBlogg"
														 error:&err];
	if (err) {
		NSLog(@"No password found or error");
	}
	
	return pass;
}

+(void)removePasswordForUsername:(NSString*)username
{
	NSError *err;
	[SFHFKeychainUtils deleteItemForUsername:username andServiceName:@"MobilBlogg" error:&err];
	if (err) {
		NSLog(@"RemovePassword failed!");
	}
}

@end
