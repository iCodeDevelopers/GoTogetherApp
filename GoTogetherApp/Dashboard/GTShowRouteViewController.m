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
#import "Place.h"
#import "PlaceMark.h"
#import "RegexKitLite.h"

@interface GTShowRouteViewController () <UIAlertViewDelegate,MKMapViewDelegate>

@property (nonatomic) CLLocationCoordinate2D from;
@property (nonatomic) CLLocationCoordinate2D to;

@property (nonatomic,retain)NSArray *routes;

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
    self.map.delegate = self;
}




-(void)showMap
{
    NSDictionary *fromData = [APP_DELEGATE.gloabalDicti valueForKey:@"From"];
    [self addAnnotation:[fromData valueForKey:@"locality_desc"] lat:[[fromData valueForKey:@"lat"] floatValue] andLong:[[fromData valueForKey:@"long"] floatValue]];
    
    NSDictionary *toData = [APP_DELEGATE.gloabalDicti valueForKey:@"To"];
    [self addAnnotation:[toData valueForKey:@"locality_desc"] lat:[[toData valueForKey:@"lat"] floatValue] andLong:[[toData valueForKey:@"long"] floatValue]];

    CLLocationCoordinate2D from1;
    from1.latitude = [[fromData valueForKey:@"lat"] floatValue];
    from1.longitude = [[fromData valueForKey:@"long"] floatValue];
    self.from = from1;
    
    CLLocationCoordinate2D to1;
    to1.latitude = [[toData valueForKey:@"lat"] floatValue];
    to1.longitude = [[toData valueForKey:@"long"] floatValue];
    self.to = to1;
    
    self.addrs.text = [NSString stringWithFormat:@"%@ -> %@",[fromData valueForKey:@"locality_desc"],[toData valueForKey:@"locality_desc"] ];
    self.routes = [self calculateRoutesFrom:self.from to:self.to];
    [self updateRouteView];
	[self centerMap];
}

-(void) updateRouteView
{
    [self.map removeOverlays:self.map.overlays];
    
    CLLocationCoordinate2D pointsToUse[[self.routes count]];
    for (int i = 0; i < [self.routes count]; i++) {
        CLLocationCoordinate2D coords;
        CLLocation *loc = [self.routes objectAtIndex:i];
        coords.latitude = loc.coordinate.latitude;
        coords.longitude = loc.coordinate.longitude;
        pointsToUse[i] = coords;
    }
    MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:[self.routes count]];
    [self.map addOverlay:lineOne];

}

-(void) centerMap {
    
	MKCoordinateRegion region;
    
	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
	for(int idx = 0; idx < self.routes.count; idx++)
	{
		CLLocation* currentLocation = [self.routes objectAtIndex:idx];
		if(currentLocation.coordinate.latitude > maxLat)
			maxLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.latitude < minLat)
			minLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.longitude > maxLon)
			maxLon = currentLocation.coordinate.longitude;
		if(currentLocation.coordinate.longitude < minLon)
			minLon = currentLocation.coordinate.longitude;
	}
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat + 0.018;
	region.span.longitudeDelta = maxLon - minLon + 0.018;
    
	[self.map setRegion:region animated:YES];
}


-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t
{
	NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
	NSLog(@"api url: %@", apiUrl);
    
    NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl];
	NSString* encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
    return [self decodePolyLine:[encodedPoints mutableCopy]:f to:t];
}

-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded :(CLLocationCoordinate2D)f to: (CLLocationCoordinate2D) t {
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
		NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
		printf("[%f,", [latitude doubleValue]);
		printf("%f]", [longitude doubleValue]);
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
		[array addObject:loc];
	}
    CLLocation *first = [[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:f.latitude] floatValue] longitude:[[NSNumber numberWithFloat:f.longitude] floatValue]];
    CLLocation *end = [[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:t.latitude] floatValue] longitude:[[NSNumber numberWithFloat:t.longitude] floatValue]];
	[array insertObject:first atIndex:0];
    [array addObject:end];
	return array;
}



-(void)addAnnotation:(NSString *)name lat:(float)lat andLong:(float)longt
{
    Place *place = [[Place alloc] init] ;
	place.name = name;
	place.latitude = lat;
	place.longitude =longt;
    
    PlaceMark* from = [[PlaceMark alloc] initWithPlace:place];
	[self.map addAnnotation:from];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

    [self showMap];
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
				   [UserWorker doCreateANewRide:[APP_DELEGATE.gloabalDicti valueForKeyPath:@"RideInfo"]];
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

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineView *overlayView = [[MKPolylineView alloc] initWithPolyline:overlay];
    overlayView.lineWidth = 5.0f;
    overlayView.strokeColor = [UIColor redColor];
    return overlayView;
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
            pinView.canShowCallout = YES;
            pinView.calloutOffset = CGPointMake(0, 32);
        } else
        {
            pinView.annotation = annotation;
        }
        pinView.pinColor = MKPinAnnotationColorGreen;

        return pinView;
    }
    return nil;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}
@end
