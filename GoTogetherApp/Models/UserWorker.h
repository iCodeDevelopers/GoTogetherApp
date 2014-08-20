//
//  UserWorker.h
//  GoTogetherApp
//
//  Created by MSPiMac2 on 8/13/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserWorker : NSObject

+ (BOOL)doRegisteration:(NSDictionary *)inputs;

+ (BOOL)doCreateANewRide:(NSArray *)inputs;

+ (void)doLogin:(NSArray *)inputs;

@end
