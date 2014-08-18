//
//  GTViewController.h
//  GoTogetherApp
//
//  Created by MSPiMac2 on 7/28/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTLoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfLogin;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
- (IBAction)doSignin:(id)sender;

@end
