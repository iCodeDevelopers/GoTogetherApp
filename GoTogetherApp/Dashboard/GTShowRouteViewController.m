//
//  GTShowRouteViewController.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 8/20/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTShowRouteViewController.h"
#import "GTAppDelegate.h"

@interface GTShowRouteViewController ()

@property (nonatomic, strong) NSMutableDictionary *rideInfo;

@end

@implementation GTShowRouteViewController

- (void)awakeFromNib
{
	[self.view setBackgroundColor:DASHBOARD_BG_COLOR];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	self.rideInfo = [NSMutableDictionary dictionaryWithDictionary:[APP_DELEGATE.gloabalDicti objectForKey:@"rideinfo"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
