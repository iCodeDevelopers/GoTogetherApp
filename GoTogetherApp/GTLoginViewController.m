//
//  GTViewController.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 7/28/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTLoginViewController.h"
#import "GTAppDelegate.h"
#import "GTRedisObject.h"

@interface GTLoginViewController ()

@end

@implementation GTLoginViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self.navigationItem setHidesBackButton:YES];
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
	[APP_DELEGATE.hud setLabelText:@"Signing In..."];

	__block BOOL isSuccessful = NO;

	[APP_DELEGATE.hud showAnimated:YES whileExecutingBlock:^{
		NSString *userID = self.tfLogin.text;
		NSString *password = self.tfPassword.text;

		NSString *userIDKey = [REDIS.redis command:[NSString stringWithFormat:@"GET user:%@", userID]];

		if (!userIDKey) {
			NSLog(@"Not a valid user.");
		}
		else {
			NSString *retVal = [REDIS.redis command:[NSString stringWithFormat:@"HGET user:%@ password", userIDKey]];

			if ([retVal isEqualToString:password]) {
				isSuccessful = YES;
			}
			else {
				NSLog(@"Not a valid user and password.");
			}
		}
	} completionBlock:^{
		if (isSuccessful) {
			NSLog(@"This is fine go ahead.");
		}
	}];
}
@end
