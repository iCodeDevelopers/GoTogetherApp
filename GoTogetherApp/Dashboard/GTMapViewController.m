//
//  GTMapViewController.m
//  GoTogetherApp
//
//  Created by Janani on 8/23/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTMapViewController.h"
#import "GTAppDelegate.h"
#import "Place.h"
#import "PlaceMark.h"

@interface GTMapViewController ()

@property (nonatomic,retain) NSArray *locationData;
@property (nonatomic,retain) NSArray *filteredLocationData;
@property (nonatomic,retain) NSDictionary *selectedData;
@end

@implementation GTMapViewController

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
    
    self.lManager = [[CLLocationManager alloc] init];
    self.lManager.delegate=self;
    
    self.map.showsUserLocation = YES;
    self.map.delegate = self;
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"locality" ofType:@"plist"];
    self.locationData =[[NSArray alloc] initWithContentsOfFile:plistPath];
    self.filteredLocationData = self.locationData;

    self.location.text = [APP_DELEGATE.gloabalDicti valueForKey:@"location"];


    if([[APP_DELEGATE.gloabalDicti valueForKey:@"locationType"] intValue] == 1)
    {
        if ([CLLocationManager locationServicesEnabled]){
            self.lManager.desiredAccuracy=kCLLocationAccuracyBest;
            self.lManager.distanceFilter=10.0f;
            [self.lManager startUpdatingLocation];
        }
    }

    
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


// LocationManager delegation implementation,called when location retrieved
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
            fromLocation:(CLLocation *)oldLocation
{
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(newLocation.coordinate,500 ,500);
    [self.map setRegion:region animated:TRUE];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dict setObject:@"Current Location" forKey:@"locality_desc"];
    [dict setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"lat"];
    [dict setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"long"];
    
    self.selectedData = dict;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
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
    
    NSDictionary *temp =  self.filteredLocationData[indexPath.row];
    cell.textLabel.text = [temp valueForKey:@"locality_desc"];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    self.done.enabled = YES;
    self.tbleView.hidden = YES;

    self.selectedData =  self.filteredLocationData[indexPath.row];
    self.location.text = [self.selectedData valueForKey:@"locality_desc"];

    [self showPoint:self.selectedData];
}


-(void)showPoint:(NSDictionary *)data
{
    Place *place = [[Place alloc] init] ;
	place.name = [data valueForKey:@"locality_desc"];
	place.latitude = [[data valueForKey:@"lat"] floatValue];
	place.longitude =[[data valueForKey:@"long"] floatValue];
    [self centerMap:place.latitude andLong:place.longitude];
    
    [self.map removeAnnotations:self.map.annotations];
    PlaceMark* from = [[PlaceMark alloc] initWithPlace:place];
	[self.map addAnnotation:from];
    
    [self.map selectAnnotation:[self.map.annotations lastObject] animated:YES];
}



- (IBAction)locationSelected:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if([[APP_DELEGATE.gloabalDicti valueForKey:@"locationType"] intValue] == 1)
    {
        [APP_DELEGATE.gloabalDicti setObject:self.selectedData forKey:@"From"];
        [self.delegate selectedAddress:self.selectedData forAddress:1];
    }
    else
    {
        [APP_DELEGATE.gloabalDicti setObject:self.selectedData forKey:@"To"];
        [self.delegate selectedAddress:self.selectedData forAddress:2];
    }
}

-(void) centerMap:(float)lat andLong:(float) longitude
{
    
	MKCoordinateRegion region;
    
	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
    
    
    if(lat > maxLat)
        maxLat = lat;
    if(lat < minLat)
        minLat = lat;
    if(longitude > maxLon)
        maxLon = longitude;
    if(longitude < minLon)
        minLon = longitude;
    
    
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat + 0.018;
	region.span.longitudeDelta = maxLon - minLon + 0.018;
    
	[self.map setRegion:region animated:YES];
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

-(IBAction)searchCompleted:(id)sender
{
    [self.location becomeFirstResponder];
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        if (!pinView)
        {
            pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.animatesDrop = YES;
            pinView.pinColor = MKPinAnnotationColorGreen;
            pinView.canShowCallout = YES;
            pinView.calloutOffset = CGPointMake(0, 32);
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}




@end
