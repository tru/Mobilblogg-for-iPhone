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

#import <Three20/Three20.h>

@implementation MBStore

+(void)removeAllData
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:@"favoriteUsers"];
	[defaults removeObjectForKey:@"hideCaption"];
	[defaults removeObjectForKey:@"secretWord"];
	[defaults synchronize];
}

+(void)removePassword
{
	[MBStore removePasswordForUsername:[MBStore getUserName]];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:@"username"];
	[defaults synchronize];
}

+(void)setObject:(id)object forKey:(NSString*)key
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:object forKey:key];
	[defaults synchronize];
}

+(void)setBool:(BOOL)booly forKey:(NSString*)key
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:booly forKey:key];
	[defaults synchronize];
}

+(BOOL)getBoolForKey:(NSString*)key
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults boolForKey:key];
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
		TTDINFO(@"Couldn't store password!");
	}
}

+(NSString*)getPasswordForUsername:(NSString*)username
{
	NSError *err;
	NSString *pass = [SFHFKeychainUtils getPasswordForUsername:username
												andServiceName:@"MobilBlogg"
														 error:&err];
	if (err) {
		TTDINFO(@"No password found or error");
	}
	
	return pass;
}

+(void)removePasswordForUsername:(NSString*)username
{
	NSError *err;
	[SFHFKeychainUtils deleteItemForUsername:username andServiceName:@"MobilBlogg" error:&err];
	if (err) {
		TTDINFO(@"RemovePassword failed!");
	}
}

@end
