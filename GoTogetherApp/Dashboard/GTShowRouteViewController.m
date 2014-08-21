//
//  GTShowRouteViewController.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 8/20/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTShowRouteViewController.h"
#import "GTAppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>


@interface GTShowRouteViewController ()

@property (nonatomic, strong) NSMutableDictionary *rideInfo;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end

@implementation GTShowRouteViewController

- (void)awakeFromNib
{
	[self.view setBackgroundColor:DASHBOARD_BG_COLOR];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0.0
															longitude:0.0
																 zoom:1];

	// Create the GMSMapView with the camera position.
	self.mapView.camera = camera;
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
