//
//  ViewController.h
//  SimpleChat
//
//  Created by Logan Wright on 3/17/14.
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChatController.h"

@interface GTMessageViewController : UIViewController <ChatControllerDelegate>

@property (strong, nonatomic) ChatController * chatController;

@end
