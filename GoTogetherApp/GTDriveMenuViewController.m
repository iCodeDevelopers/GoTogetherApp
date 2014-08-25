//
//  GTDashboardViewController.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 7/30/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTDriveMenuViewController.h"
@interface MenuTableViewCell : UITableViewCell
@end

@implementation MenuTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.imageView.frame;
    rect.origin.x = CGRectGetWidth(self.contentView.bounds)-CGRectGetWidth(self.imageView.bounds) - 10;
    [self.imageView setFrame:rect];
    
    rect = self.textLabel.frame;
    rect.origin.x = CGRectGetWidth(self.contentView.bounds)-CGRectGetWidth(self.imageView.bounds)-CGRectGetWidth(self.textLabel.bounds) - 25;
    [self.textLabel setFrame:rect];
}

@end

@interface GTDriveMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation GTDriveMenuViewController

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
		case 0: //create ride 
			[self presentMenu:@"createride"];
			break;
		case 1: //Find Ride
			[self presentMenu:@"findride"];
			break;

		case 2: //inbox
			[self presentMenu:@"inbox"];
			break;
		case 3: //Cost
			break;
        case 4: //Cost
            [self presentMenu:@"search"];
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
	UINavigationController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:menu];
	[self.sideMenuViewController setContentViewController:viewController animated:YES ];
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
	return 5;
}

- (MenuTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";

	MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

	if (cell == nil) {
		cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.backgroundColor = [UIColor clearColor];
		cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
		cell.textLabel.textAlignment = NSTextAlignmentRight;
		cell.textLabel.textColor = MENU_TEXT_COLOR;
		cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
		cell.selectedBackgroundView = [[UIView alloc] init];
	}

	NSArray *titles = @[@"ADD", @"SEARCH", @"MESSAGES", @"COST", @"MAKE A RIDE"];
	NSArray *images = @[@"add", @"find", @"message", @"cost",@"make"];
	cell.textLabel.text = titles[indexPath.row];
	cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];

	return cell;
}

@end