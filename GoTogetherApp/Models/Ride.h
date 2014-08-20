//
//  Ride.h
//  GoTogetherApp
//
//  Created by MSPiMac2 on 8/20/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Ride : NSManagedObject

@property (nonatomic, retain) NSString * rideID;
@property (nonatomic, retain) NSString * rideNumber;
@property (nonatomic, retain) NSString * rideName;
@property (nonatomic, retain) NSString * rideFromLat;
@property (nonatomic, retain) NSString * rideFromLang;
@property (nonatomic, retain) NSString * rideToLat;
@property (nonatomic, retain) NSString * rideToLang;
@property (nonatomic, retain) NSString * rideOption;
@property (nonatomic, retain) NSString * rideWhen;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSSet *interestedUsers;
@end

@interface Ride (CoreDataGeneratedAccessors)

- (void)addInterestedUsersObject:(NSManagedObject *)value;
- (void)removeInterestedUsersObject:(NSManagedObject *)value;
- (void)addInterestedUsers:(NSSet *)values;
- (void)removeInterestedUsers:(NSSet *)values;

@end
