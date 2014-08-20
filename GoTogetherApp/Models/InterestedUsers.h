//
//  InterestedUsers.h
//  GoTogetherApp
//
//  Created by MSPiMac2 on 8/20/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InterestedUsers : NSManagedObject

@property (nonatomic, retain) NSString * iUserID;
@property (nonatomic, retain) NSString * iUserStatus;

@end
