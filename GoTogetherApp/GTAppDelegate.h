//
//  GTAppDelegate.h
//  GoTogetherApp
//
//  Created by MSPiMac2 on 7/28/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface GTAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) MBProgressHUD *hud;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableDictionary *gloabalDicti;

@end
