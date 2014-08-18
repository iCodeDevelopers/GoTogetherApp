//
//  GTRedisObject.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 7/30/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTRedisObject.h"

@interface GTRedisObject ()

@property (nonatomic, strong) ObjCHiredis *redis;

@end

@implementation GTRedisObject

+ (GTRedisObject *)redisObject
{
	static GTRedisObject *redisObject = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		redisObject = [[self alloc] init];
	});

	return redisObject;
}

- (void)connect
{
	if (self.redis) {
    return;
	}

	id retVal = [self.redis command:@"PING"];

	if ([retVal isEqualToString:@"PONG"]) {
		return;
	}
	else {
		[self.redis close];
		self.redis = nil;
	}
	
	self.redis = [ObjCHiredis redis:@"pub-redis-10303.us-east-1-1.2.ec2.garantiadata.com"
																				on:[NSNumber numberWithInteger:10303]];

	retVal = [self.redis command:@"AUTH loveme1234"];

	if ([retVal isEqualToString:@"OK"]) {
		NSLog(@"Connected to redis server.");
	}
	else {
		NSLog(@"Could not connect to redis server.");
	}
}

- (void)close
{
	[self.redis close];
	self.redis = nil;
}

- (BOOL)executeCommand:(NSString *)command result:(NSString *__autoreleasing *)result
{
	BOOL successfull = YES;

	id 	retVal = [self.redis command:command];

	successfull = (retVal != nil);

	if (successfull && result != NULL) {
		*result = [NSString stringWithFormat:@"%@", retVal];
	}
	else {
		*result = nil;
	}

	return successfull;
}
@end
