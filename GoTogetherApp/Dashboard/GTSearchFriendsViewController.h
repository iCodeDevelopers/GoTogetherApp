//
//  GTSearchFriendsViewController.h
//  GoTogetherApp
//
//  Created by Janani on 8/24/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>



@interface GTSearchFriendsViewController : UIViewController<CBPeripheralManagerDelegate, CLLocationManagerDelegate>

@property (nonatomic,retain) IBOutlet UITableView *tbleView;
@property (nonatomic,retain) IBOutlet UITextField *location;
@property (nonatomic,retain) IBOutlet UILabel *lblMsg;
@property (strong, nonatomic) CLBeaconRegion *myBeaconTransmitter;
@property (strong, nonatomic) CLBeaconRegion *myBeaconReciever;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSDictionary *myBeaconData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;


@end
