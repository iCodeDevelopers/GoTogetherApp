//
//  GTRegisterViewController.h
//  GoTogetherApp
//
//  Created by MSPiMac2 on 7/30/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTRegisterViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *tfUserID;
@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfConfirmPassword;

@property (weak, nonatomic) IBOutlet UIImageView *photoView;

- (IBAction)doRegister:(UIBarButtonItem *)sender;
- (IBAction)doUploadClicked:(id)sender;

@end
