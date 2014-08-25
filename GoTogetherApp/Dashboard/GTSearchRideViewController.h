//
//  GTSearchRideViewController.h
//  GoTogetherApp
//
//  Created by MSPiMac2 on 8/21/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMapViewController.h"

@interface GTSearchRideViewController : UIViewController <LocationDelegate>

@property (nonatomic, weak) IBOutlet UITextField *tfTo;

@end
