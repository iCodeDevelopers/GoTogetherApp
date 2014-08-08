//
//  GTDashboardViewController.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 7/30/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTDashboardViewController.h"

@interface GTDashboardViewController ()

@end

@implementation GTDashboardViewController

- (void)awakeFromNib
{
	[self.view setBackgroundColor:DASHBOARD_BG_COLOR];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.backgroundColor = [UIColor clearColor];
		cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
		cell.textLabel.textColor = [UIColor whiteColor];
		cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
		cell.selectedBackgroundView = [[UIView alloc] init];
	}

	NSArray *titles = @[@"Dashboard", @"Profile", @"Settings", @"Log Out"];
	NSArray *images = @[@"dashboard", @"profile", @"settings", @"logout"];
	cell.textLabel.text = titles[indexPath.row];
	cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];

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
