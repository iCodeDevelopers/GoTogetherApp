//
//  UserWorker.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 8/13/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "UserWorker.h"
#import "User.h"
#import "GTAppDelegate.h"
#import "GTRedisObject.h"

@implementation UserWorker

+ (BOOL)doRegisteration:(NSArray *)inputs
{
	if ([inputs count] < 5) {
		NSLog(@"Less Inputs..");
		return NO;
	}

	User *user = [User createModelContext];

	[user setUserID:[inputs objectAtIndex:0]];
	[user setPassword:[inputs objectAtIndex:1]];
	[user setFirstName:[inputs objectAtIndex:2]];
	[user setLastName:[inputs objectAtIndex:3]];
	[user setGender:@"Male"];


	NSString *userID = nil;
	// if user is not present
	BOOL isOK = [REDIS executeCommand:[NSString stringWithFormat:@"GET user:%@", user.userID] result:&userID];

	if (!userID) {
		NSString *nextUserID = nil;
		// Get the user token
		isOK = [REDIS executeCommand:@"INCR global:nextuserid" result:&nextUserID];
		if (isOK && nextUserID) {
			NSString *result = nil;
			// set the userID and key map for the login
			isOK = [REDIS executeCommand:[NSString stringWithFormat:@"SET user:%@ \"%@\"", user.userID, nextUserID]  result:&result];

			if (isOK) {
				// set the user profile.
				NSString *command = [NSString stringWithFormat:@"HMSET user:%@ userid \"%@\"  password \"%@\"  firstname \"%@\" lastname \"%@\" gender \"%@\"",
									 nextUserID,
									 user.userID,
									 user.password,
									 user.firstName,
									 user.lastName,
									 user.gender];
				isOK = [REDIS executeCommand:command result:&result];
			}
		}
		else {
			NSLog(@"Does not have a valid token.");
			isOK = NO;
		}
	}
	else {
		NSLog(@"User already exist.");
		isOK = NO;
	}


	return isOK;
}

+ (void)doLogin:(NSArray *)inputs
{
	if ([inputs count] < 2) {
		NSLog(@"Less Inputs..");
		return;
	}

}

@end
