//
//  GTRedisObject.h
//  GoTogetherApp
//
//  Created by MSPiMac2 on 7/30/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lib/redis/ObjCHiredis.h"

@interface GTRedisObject : ObjCHiredis

@property (nonatomic, readonly) ObjCHiredis *redis;


+ (GTRedisObject *)redisObject;

- (void)connect;
- (void)close;

- (BOOL)executeCommand:(NSString *)command result:(NSString **)result;

@end
