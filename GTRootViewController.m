//
//  GTRootViewController.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 8/7/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTRootViewController.h"

@interface GTRootViewController ()

@end

@implementation GTRootViewController

- (void)awakeFromNib
{
	self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
	self.contentViewShadowColor = [UIColor blackColor];
	self.contentViewShadowOffset = CGSizeMake(0, 0);
	self.contentViewShadowOpacity = 0.6;
	self.contentViewShadowRadius = 12;
	self.contentViewShadowEnabled = YES;

	self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
	self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mymenucontroller"];
	self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"drivemenucontroller"];
	self.view.backgroundColor = [UIColor colorWithRed:137/255.f green:183/255.f blue:226/255.f alpha:1.f];
	self.delegate = self;
}

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
	NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
	NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
	NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
	NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

@end
