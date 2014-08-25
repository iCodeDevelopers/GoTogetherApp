//
//  GTSearchFriendsViewController.m
//  GoTogetherApp
//
//  Created by Janani on 8/24/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTSearchFriendsViewController.h"

@interface GTSearchFriendsViewController ()

@property (nonatomic,retain) NSArray *locationData;
@property (nonatomic,retain) NSArray *filteredLocationData;
@property (weak, nonatomic) IBOutlet UISegmentedControl *select;

@end

@implementation GTSearchFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"locality" ofType:@"plist"];
    self.locationData =[[NSArray alloc] initWithContentsOfFile:plistPath];
    self.filteredLocationData = self.locationData;

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"1BB535DE-A7DE-4C79-93A7-2B0E88382B42"];
    self.myBeaconTransmitter = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                  major:1
                                                                  minor:1
                                                             identifier:@"com.test.iBeacon"];
    
    self.myBeaconReciever = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.test.iBeacon"];
    [self.locationManager startMonitoringForRegion:self.myBeaconReciever];
    [self.select setSelectedSegmentIndex:UISegmentedControlNoSegment];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)closeKeyboard:(id)sender
{
    [self.view endEditing:YES];
    NSDictionary *dict =  self.filteredLocationData[0];
    self.location.text = [dict valueForKey:@"locality_desc"];
    
    self.tbleView.hidden = YES;
}


- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconReciever];
}

-(IBAction)segmentChanged:(UISegmentedControl *)sender
{
    if(self.location.text.length == 0)
    {
        UIAlertView *alr = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Select destination first" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alr show];
        [self.select setSelectedSegmentIndex:UISegmentedControlNoSegment];
    }
    else
    {
        if(self.select.selectedSegmentIndex == 0)
        {
            self.myBeaconData = [self.myBeaconTransmitter peripheralDataWithMeasuredPower:nil];
            self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                             queue:nil
                                                                           options:nil];
            self.select.selectedSegmentIndex = 1;
        }
        else
        {
            [self locationManager:self.locationManager didStartMonitoringForRegion:self.myBeaconReciever];
            self.select.selectedSegmentIndex = 0;
        }
    }
    
}


-(void)peripheralManagerDidUpdateState:(CBPeripheralManager*)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        self.lblMsg.text = @"Sharing Ride";

        NSLog(@"Powered On");
        [self.peripheralManager startAdvertising:self.myBeaconData];
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        self.lblMsg.text = @"Unable to transfer";

        NSLog(@"Powered Off");
        [self.peripheralManager stopAdvertising];
    }
}



- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.filteredLocationData count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSArray *temp =  self.filteredLocationData[indexPath.row];
    cell.textLabel.text = [temp valueForKey:@"locality_desc"];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    NSDictionary *dict =  self.filteredLocationData[indexPath.row];
    self.location.text = [dict valueForKey:@"locality_desc"];
    
    self.tbleView.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.tbleView.hidden = NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"locality_desc contains[c] %@",  [NSString stringWithFormat:@"%@%@",self.location.text,string]];
    self.filteredLocationData = [self.locationData filteredArrayUsingPredicate:pred];
    [self.tbleView reloadData];
    
    return YES;
}


- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    NSLog(@"Beacon Found");
    
    self.lblMsg.text = @"Searching Ride";
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Welcome";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconReciever];
    
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    NSLog(@"Left Region");
    

    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Good bye";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconReciever];
    
}



-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    CLBeacon * beacon = [beacons firstObject];
    UIColor * bgColor;
    
    if (beacon.proximity == CLProximityUnknown)
    {
        bgColor = [UIColor colorWithRed:186.0/255.0 green:197.0/255.0 blue:185.0/255.0 alpha:1];
    }
    else if (beacon.proximity == CLProximityImmediate)
    {
        bgColor = [UIColor yellowColor];
    }
    else if (beacon.proximity == CLProximityNear)
    {
        bgColor = [UIColor greenColor];
    }
    else if (beacon.proximity == CLProximityFar)
    {
        bgColor = [UIColor redColor];
    }

    
    [self.view setBackgroundColor:bgColor];
}


@end
