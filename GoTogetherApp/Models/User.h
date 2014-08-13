//
//  User.h
//  GoTogetherApp
//
//  Created by MSPiMac2 on 8/13/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSString * userBaseKey;
@property (nonatomic, retain) NSString * userID;

@end
