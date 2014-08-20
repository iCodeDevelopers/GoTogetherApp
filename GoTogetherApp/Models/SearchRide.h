//
//  SearchRide.h
//  GoTogetherApp
//
//  Created by MSPiMac2 on 8/20/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface SearchRide : NSManagedObject

@property (nonatomic, retain) NSString * sRideID;
@property (nonatomic, retain) NSString * sRideFromLang;
@property (nonatomic, retain) NSString * sRideFromLat;
@property (nonatomic, retain) NSString * sRideToLat;
@property (nonatomic, retain) NSString * sRideToLang;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSSet *interestedUsers;
@end

@interface SearchRide (CoreDataGeneratedAccessors)

- (void)addInterestedUsersObject:(NSManagedObject *)value;
- (void)removeInterestedUsersObject:(NSManagedObject *)value;
- (void)addInterestedUsers:(NSSet *)values;
- (void)removeInterestedUsers:(NSSet *)values;

@end
