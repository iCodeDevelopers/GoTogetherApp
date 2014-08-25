//
//  GTRideMatchTableViewController.m
//  GoTogetherApp
//
//  Created by MSP_MacBookPro on 24/08/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTRideMatchTableViewController.h"
#import "GTAppDelegate.h"
#import "GTRedisObject.h"
#import "GTSearchRideTableViewCell.h"
#import "GTVerifyCarViewController.h"

@interface GTRideMatchTableViewController () <UIAlertViewDelegate>
@property (nonatomic,retain) NSArray *data;
@property (nonatomic,retain) NSDictionary *selectUser;
@end

@implementation GTRideMatchTableViewController

- (void)awakeFromNib
{
	[self.tableView setBackgroundColor:DASHBOARD_BG_COLOR];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Search" ofType:@"plist"];
    self.data =[[NSArray alloc] initWithContentsOfFile:plistPath];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectUser = self.data[indexPath.row];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please Confirm your interest!"
																											message:@""
																										 delegate:self
																						cancelButtonTitle:@"OK"
																						otherButtonTitles:nil];
	[alertView show];
}


#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"cellActive";
    
	GTSearchRideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary *temp =  self.data[indexPath.row];
    
    cell.lblName.text = [temp valueForKey:@"name"];
    cell.lblDate.text = [temp valueForKey:@"date"];
    cell.lblVehicleNo.text = [temp valueForKey:@"number"];
    cell.btnVerify.tag = indexPath.row;
    cell.backgroundColor = [UIColor clearColor];

	return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Traffic"])
    {
        GTVerifyCarViewController *vc = segue.destinationViewController;
        UIButton *btn = (UIButton *)sender;
        self.selectUser = self.data[btn.tag];

        vc.no = [self.selectUser valueForKey:@"number"];
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[APP_DELEGATE.hud setLabelText:@"Posting Notification..."];
	
	__block BOOL isSuccessful = NO;
	
	[APP_DELEGATE.hud showAnimated:YES whileExecutingBlock:^{
		NSArray *array = @[@"1001", @"1002", @"1003"];
		id retValue = [REDIS.redis command:[NSString stringWithFormat:@"HMGET ride:%@ devicetoken", array[buttonIndex/3]]];
		
		if (retValue) {
			retValue = [REDIS.redis command:[NSString stringWithFormat:@"PUBLISH broadcast %@", @"1001"]];
			
			if (retValue) {
				NSLog(@"Posted.");
				isSuccessful = YES;
			}
		}
	} completionBlock:^{
		if (isSuccessful) {
			[self.navigationController dismissViewControllerAnimated:YES completion:^{
			}];
		}
	}];

}

@end
