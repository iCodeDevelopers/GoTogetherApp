//
//  GTMapViewController.h
//  GoTogetherApp
//
//  Created by Janani on 8/23/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationDelegate <NSObject>

-(void)selectedAddress:(NSDictionary *) addr forAddress:(int)tag;

@end

@interface GTMapViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic,retain) IBOutlet MKMapView *map;
@property (nonatomic,retain) IBOutlet UITableView *tbleView;
@property (nonatomic,retain) IBOutlet UITextField *location;
@property (nonatomic,retain) IBOutlet  UIBarButtonItem *done;
@property (nonatomic,retain) id<LocationDelegate> delegate;
@property (nonatomic, retain) CLLocationManager *lManager;
- (IBAction)locationSelected:(id)sender;

@end
