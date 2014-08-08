//
//  GTRegisterViewController.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 7/30/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTRegisterViewController.h"
#import "GTRedisObject.h"

@interface GTRegisterViewController ()

@end

@implementation GTRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doRegister:(UIBarButtonItem *)sender {

	//SET users:goku {race: 'sayan', power: 9001}

	NSString *command = [NSString stringWithFormat:@"SET users:%@ {firstName: \'%@\', lastName: \'%@\', password: \'%@\'}",
											 self.tfUserID.text,
											 self.tfFirstName.text,
											 self.tfLastName.text,
											 self.tfPassword.text];

	id retval = [REDIS.redis command:command];

	if ([retval isEqualToString:@"OK"]) {
    NSLog(@"User regaistered.");
	}
	else {
		NSLog(@"Error in registeration.");
	}
}
@end
