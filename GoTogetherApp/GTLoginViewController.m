//
//  GTViewController.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 7/28/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTLoginViewController.h"
#import "lib/hud/MBProgressHUD.h"
#import "GTRedisObject.h"

@interface GTLoginViewController ()

@end

@implementation GTLoginViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (IBAction)doSignin:(id)sender {
	[self processSignin];
}

- (void)processSignin {
	MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[HUD setLabelText:@"Signing In..."];
	[self.navigationController.view addSubview:HUD];

	__block BOOL isSuccessful = NO;

	[HUD showAnimated:YES whileExecutingBlock:^{
		NSString *userID = self.tfLogin.text;
		NSString *password = self.tfPassword.text;

		id retVal = [REDIS.redis command:[NSString stringWithFormat:@"HLEN %@", userID]];

		if ([retVal integerValue] <= 0) {
			NSLog(@"Not a valid user.");
		}
		else {
			retVal = [REDIS.redis command:[NSString stringWithFormat:@"HGET %@ pass", userID]];

			if ([retVal isEqualToString:password]) {
				isSuccessful = YES;
			}
			else {
				NSLog(@"Not a valid user and password.");
			}
		}
	} completionBlock:^{
		if (isSuccessful) {
			[self performSegueWithIdentifier: @"logintodashboard" sender: self];
		}
	}];
}
@end
