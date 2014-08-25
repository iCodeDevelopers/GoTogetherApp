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
	if ([input count] < 6) {
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
				 @"HMSET user:%@ devicetoken \"%@\" userid \"%@\" password %@ firstname \"%@\" lastname \"%@\" gender \"%@\"",
				 userIDKey,
				 [input objectForKey:@"devicetoken"],
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

+ (NSArray *)getRides
{
	NSString *userIDKey = [APP_DELEGATE.gloabalDicti objectForKey:@"useridkey"]; // set the userid key
	
	// Get the new ride token
	NSArray *rides = [REDIS executeCommand:[NSString stringWithFormat:@"SMEMBERS rides:%@", userIDKey]];
	
	NSMutableArray *list = [NSMutableArray new];
	
	if (rides) {
		
		
		for (NSString *key in rides) {
			NSString *command =
			[NSString stringWithFormat:
			 @"HMGET ride:%@ name number fromlat fromlang tolat tolang rideoption ridewhen", key];
			
			NSArray *values = [REDIS executeCommand:command];
			
			if ([values count] == 8) {
				NSDictionary *dicti =
				@{@"name" : [values objectAtIndex:0],
					@"number" : [values objectAtIndex:1],
					@"fromlat" : [values objectAtIndex:2],
					@"fromlang" : [values objectAtIndex:3],
					@"tolat" : [values objectAtIndex:4],
					@"tolang" : [values objectAtIndex:5],
					@"rideoption" : [values objectAtIndex:6],
					@"ridewhen" : [values objectAtIndex:7]};
				
				[list addObject:dicti];
			}
		}
	}
	else {
		return nil;
	}
	
	return list;
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
		NSString *keyInRedis = [NSString stringWithFormat:@"rides:%@", nextRideID];
		// set the the ride
//		NSString *command =
//		[NSString stringWithFormat:
//		 @"HMSET ride:%@ name \"%@\" number \"%@\" fromlat \"%@\" fromlang \"%@\" tolat \"%@\" tolang \"%@\" rideoption \"%@\" ridewhen \"%@\"",
//		 nextRideID,
//		 [input objectForKey:@"name"],
//		 [input objectForKey:@"number"],
//		 [input objectForKey:@"fromlat"],
//		 [input objectForKey:@"fromlang"],
//		 [input objectForKey:@"tolat"],
//		 [input objectForKey:@"tolang"],
//		 [input objectForKey:@"rideoption"],
//		 [input objectForKey:@"ridewhen"]];
    
    NSMutableArray *commands = [NSMutableArray new];
    [commands addObject:@"HMSET"];
    [commands addObject:keyInRedis];
    
    for (NSString *key in [input keyEnumerator]) {
      [commands addObject:key];
      [commands addObject:[input objectForKey:key]];
    }
		
		id retVal = [REDIS executeCommandList:[NSArray arrayWithArray:commands]];
		
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

+ (BOOL)doCreateASearch:(NSDictionary *)input
{
	if ([input count] < 2) {
		NSLog(@"Less Inputs..");
		return NO;
	}
	
	NSString *userIDKey = [APP_DELEGATE.gloabalDicti objectForKey:@"useridkey"]; // set the userid key
	
	// Get the new ride token
	NSString *nextSearchRideID = [REDIS executeCommand:@"INCR global:nextsearchrideid"];
	
	if (nextSearchRideID) {
		//			// set the userID and key map for the login
		
		// set the the ride
		NSString *command =
		[NSString stringWithFormat:
		 @"HMSET searchride:%@ tolat %@  tolang %@",
		 nextSearchRideID,
		 [input objectForKey:@"tolat"],
		 [input objectForKey:@"tolang"]];
		
		id retVal = [REDIS executeCommand:command];
		
		if (retVal) {
			retVal = [REDIS executeCommand:[NSString stringWithFormat:@"SADD searchrides:%@ %@", userIDKey, nextSearchRideID]];
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
