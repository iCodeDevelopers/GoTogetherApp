//
//  NSManagedObject+JSON.h
//  GoTogetherApp
//
//  Created by MSPiMac2 on 8/18/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (JSON)

- (NSString *)toJSONString;

+ (instancetype)createModelContext;
@end
