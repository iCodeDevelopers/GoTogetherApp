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
#import "UserWorker.h"


@interface GTShowRouteViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *rideInfo;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

- (IBAction)doConfirmAndPost:(id)sender;

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

- (IBAction)doConfirmAndPost:(id)sender
{
	[APP_DELEGATE.hud setLabelText:@"Creating New Ride..."];

	__block BOOL creationDone = NO;

	[APP_DELEGATE.hud showAnimated:YES
			   whileExecutingBlock:^{
				   creationDone =
				   [UserWorker doCreateANewRide:self.rideInfo];
			   } completionBlock:^{
				   if (creationDone) {
					   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
																		   message:@"Your ride is created."
																		  delegate:self
																 cancelButtonTitle:@"OK"
																 otherButtonTitles:nil];

					   [alertView show];
				   }
			   }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}
@end
