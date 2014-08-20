//
//  GTDashboardViewController.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 7/30/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTCreateRideViewController.h"
#import "GTAppDelegate.h"
#import "GTRedisObject.h"
#import "UserWorker.h"

@interface GTCreateRideViewController ()

- (IBAction)doShowRoute:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *tfRideName;
@property (weak, nonatomic) IBOutlet UITextField *tfRideNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfRideFrom;
@property (weak, nonatomic) IBOutlet UITextField *tfRideTo;
@property (weak, nonatomic) IBOutlet UITextField *tfRideNumberOfSeats;
@property (weak, nonatomic) IBOutlet UITextField *tfRideWhen;

@end

@implementation GTCreateRideViewController

- (void)awakeFromNib
{
	[self.view setBackgroundColor:DASHBOARD_BG_COLOR];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (IBAction)doShowRoute:(id)sender
{
	[APP_DELEGATE.gloabalDicti setObject:@{@"name ": self.tfRideName.text,
										   @"name ": self.tfRideName.text,
										   @"number ": self.tfRideNumber.text,
										   @"fromlat ": @"6.78787",
										   @"fromlang ": @"6.78787",
										   @"tolat ": @"6.78787",
										   @"tolang ": @"6.78787",
										   @"rideoption ": @"Single",
										   @"ridewhen ": @"jsdghfjhdj",
										   }
								  forKey:@"rideinfo"];
	
	[self performSegueWithIdentifier:@"showroute" sender:self];
}
@end
