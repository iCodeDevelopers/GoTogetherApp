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

+ (BOOL)doRegisteration:(NSDictionary *)input
{
	if ([input count] < 5) {
		NSLog(@"Less Inputs..");
		return NO;
	}

	// if user is present
	NSString *userIDKey = [REDIS executeCommand:[NSString stringWithFormat:@"GET user:%@", [input objectForKey:@"user"]]];

	if (!userIDKey) {
		// Get the user token
		userIDKey = [REDIS executeCommand:@"INCR global:nextuserid"];

		if (userIDKey) {
			// set the userID and key map for the login
			id retVal = [REDIS executeCommand:[NSString stringWithFormat:@"SET user:%@ %@", [input objectForKey:@"user"], userIDKey]];

			if (retVal) {
				// set the user profile.
				NSString *command =
				[NSString stringWithFormat:
				 @"HMSET user:%@ userid %@  password %@  firstname %@ lastname %@ gender %@",
				 userIDKey,
				 [input objectForKey:@"user"],
				 [input objectForKey:@"password"],
				 [input objectForKey:@"firstname"],
				 [input objectForKey:@"lastname"],
				 [input objectForKey:@"gender"]];

				retVal = [REDIS executeCommand:command];

				return retVal != nil;
			}
		}
		else {
			NSLog(@"Does not have a valid token.");
			return NO;
		}
	}
	else {
		NSLog(@"User already exist.");
		return NO;
	}

	return NO;
}

+ (void)doLogin:(NSArray *)inputs
{
	if ([inputs count] < 2) {
		NSLog(@"Less Inputs..");
		return;
	}

}

+ (BOOL)doCreateANewRide:(NSDictionary *)input
{
	if ([input count] < 8) {
		NSLog(@"Less Inputs..");
		return NO;
	}

	NSString *userIDKey = [APP_DELEGATE.gloabalDicti objectForKey:@"useridkey"]; // set the userid key

	// Get the new ride token
	NSString *nextRideID = [REDIS executeCommand:@"INCR global:nextrideid"];

	if (nextRideID) {
		//			// set the userID and key map for the login

		// set the the ride
		NSString *command =
		[NSString stringWithFormat:
		 @"HMSET ride:%@ name %@  number %@  fromlat %@ fromlang %@ tolat %@ tolang %@ rideoption %@ ridewhen %@",
		 nextRideID,
		 [input objectForKey:@"name"],
		 [input objectForKey:@"number"],
		 [input objectForKey:@"fromlat"],
		 [input objectForKey:@"fromlang"],
		 [input objectForKey:@"tolat"],
		 [input objectForKey:@"tolang"],
		 [input objectForKey:@"rideoption"],
		 [input objectForKey:@"ridewhen"]];

		id retVal = [REDIS executeCommand:command];

		if (retVal) {
			retVal = [REDIS executeCommand:[NSString stringWithFormat:@"SADD rides:%@ %@", userIDKey, nextRideID]];
			return retVal!=nil;
		}
	}
	else {
		NSLog(@"Could not get a new token.");
		return NO;
	}
	
	return NO;
}

@end
