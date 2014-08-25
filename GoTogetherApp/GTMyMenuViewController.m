//
//  GTDashboardViewController.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 7/30/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTMyMenuViewController.h"

@interface GTMyMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation GTMyMenuViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
	self.tableView = ({
		UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
		tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		tableView.delegate = self;
		tableView.dataSource = self;
		tableView.opaque = NO;
		tableView.backgroundColor = [UIColor clearColor];
		tableView.backgroundView = nil;
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		tableView.bounces = NO;
		tableView.scrollsToTop = NO;
		tableView;
	});
	[self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	switch (indexPath.row) {
		case 0: //Dashboard
			[self presentMenu:@"dashboard"];
			break;
		case 1: //Profile
			[self presentMenu:@"profile"];
			break;

		case 2: //Settings
			[self presentMenu:@"settings"];
			break;
		case 3: //Logout
            [self presentMenu:@"RegisterNav"];
			break;
		default:
			break;
	}

	[self.sideMenuViewController hideMenuViewController];
}

- (void)presentMenu:(NSString *)menu
{
	if (!menu) {
		return;
	}

	UINavigationController *navController =  [self.storyboard instantiateViewControllerWithIdentifier:menu];
	[self.sideMenuViewController setContentViewController:navController animated:YES ];
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
		cell.textLabel.textColor = MENU_TEXT_COLOR;
		cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
		cell.selectedBackgroundView = [[UIView alloc] init];
	}

	NSArray *titles = @[@"MY RIDES", @"ME", @"SETTINGS", @"LOG OUT"];
	NSArray *images = @[@"dashboard", @"profile", @"settings", @"logout"];
	cell.textLabel.text = titles[indexPath.row];
    
    if([cell.textLabel.text isEqualToString:@"ME"])
        cell.userInteractionEnabled = NO;
    
	cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];

	return cell;
}

@end
