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

	NSString* userIDI = [inputs objectAtIndex:0];
	NSString* passwordI = [inputs objectAtIndex:1];
	NSString* firstNameI = [inputs objectAtIndex:2];
	NSString* lastNameI = [inputs objectAtIndex:3];
	NSString* genderI = @"Male";


	NSString *userIDE = nil;
	// if user is not present
	BOOL isOK = [REDIS executeCommand:[NSString stringWithFormat:@"GET user:%@", userIDI] result:&userIDE];

	if (!userIDE) {
		NSString *nextUserID = nil;
		// Get the user token
		isOK = [REDIS executeCommand:@"INCR global:nextuserid" result:&nextUserID];
		if (isOK && nextUserID) {
			NSString *result = nil;
			// set the userID and key map for the login
			isOK = [REDIS executeCommand:[NSString stringWithFormat:@"SET user:%@ \"%@\"", userIDI, nextUserID]  result:&result];

			if (isOK) {
				// set the user profile.
				NSString *command =
				[NSString stringWithFormat:
				 @"HMSET user:%@ userid \"%@\"  password \"%@\"  firstname \"%@\" lastname \"%@\" gender \"%@\"",
				 nextUserID,
				 userIDI,
				 passwordI,
				 firstNameI,
				 lastNameI,
				 genderI];

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
