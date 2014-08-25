//
//  GTDashboardViewController.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 7/30/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTDashboardViewController.h"
#import "GTAppDelegate.h"
#import "GTRedisObject.h"
#import "UserWorker.h"

@interface GTDashboardViewController ()

@property (nonatomic,retain) NSArray *ridesData;

@end

@implementation GTDashboardViewController

- (void)awakeFromNib
{
	//[self.view setBackgroundColor:DASHBOARD_BG_COLOR];
	//[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidAppear:(BOOL)animated
{
	[APP_DELEGATE.hud setLabelText:@"Connecting..."];
  
	__block BOOL isLoginRequired = NO;
  __block NSString *command = nil;
	[APP_DELEGATE.hud showAnimated:YES whileExecutingBlock:^{
		[REDIS connect];
    
		NSString *userIDkey = [APP_DELEGATE.gloabalDicti objectForKey:@"useridkey"];
    
		isLoginRequired = userIDkey == nil;
    
		if (!isLoginRequired) { // If user is availaiable
			self.ridesData = [UserWorker getRides];
		}
	} completionBlock:^{
		if (isLoginRequired) {
			dispatch_async(dispatch_get_main_queue(), ^(void){
				[self performSegueWithIdentifier:@"showLogin" sender:self];
			});
		}
    
    [self.tableView reloadData];
    
	}];
  
  
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	return self.ridesData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"cellActive";
  
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		[cell setBackgroundColor:[UIColor clearColor]];
	}
	
  NSDictionary *temp =  self.ridesData[indexPath.row];
  cell.textLabel.text = [NSString stringWithFormat:@"%@ on %@",[temp valueForKey:@"name"],[temp valueForKey:@"ridewhen"]];
  
	return cell;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	switch (indexPath.row) {
		case 0: //Dashboard
			break;
		default:
			break;
	}
}

@end
