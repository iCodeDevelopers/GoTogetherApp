//
//  GTSearchRideViewController.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 8/21/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTSearchRideViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GTAppDelegate.h"


@interface GTSearchRideViewController ()

@end

@implementation GTSearchRideViewController

- (void)awakeFromNib
{
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

-(void)selectedAddress:(NSDictionary *)addr forAddress:(int)tag
{
	[self.tfTo setText:[addr objectForKey:@"locality_desc"]];
	
	[APP_DELEGATE.gloabalDicti setObject:addr forKey:@"findride"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	[self.view endEditing:YES];
	
	if ([[segue.destinationViewController class] isSubclassOfClass:[GTMapViewController class]]) {
			GTMapViewController *map = segue.destinationViewController;
			map.delegate = self;
	}
	
}


@end
