//
//  GTShowRouteViewController.h
//  GoTogetherApp
//
//  Created by MSPiMac2 on 8/20/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface GTShowRouteViewController : UIViewController

@property (nonatomic,retain) IBOutlet MKMapView *map;
@property (nonatomic,weak) IBOutlet UILabel *addrs;

@end
