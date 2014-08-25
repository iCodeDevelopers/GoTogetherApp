//
//  GTDashboardViewController.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 7/30/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTCreateRideViewController.h"
#import "GTAppDelegate.h"
#import "GTRedisObject.h"
#import "UserWorker.h"
#import "GTShowRouteViewController.h"

@interface GTCreateRideViewController ()

- (IBAction)doShowRoute:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *tfRideName;
@property (weak, nonatomic) IBOutlet UITextField *tfRideNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfRideFrom;
@property (weak, nonatomic) IBOutlet UITextField *tfRideTo;
@property (weak, nonatomic) IBOutlet UITextField *tfRideNumberOfSeats;
@property (weak, nonatomic) IBOutlet UITextField *tfRideWhen;
@property (weak, nonatomic) IBOutlet UITextField *tfRideCost;
@property (weak, nonatomic) IBOutlet UISegmentedControl *time;
@property (weak, nonatomic) IBOutlet UISegmentedControl *type;
@property (weak, nonatomic) IBOutlet UIButton *btnFromMap;
@property (weak, nonatomic) IBOutlet UIButton *btnToMap;
@property (weak, nonatomic) IBOutlet UIButton *btnRoute;

@end

@implementation GTCreateRideViewController



- (void)viewDidAppear:(BOOL)animated
{
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
  self.tfRideWhen.text = [df stringFromDate:[NSDate date]];
  
  
  BOOL shareRide = YES;
  
  self.tfRideName.enabled = shareRide;
  self.tfRideNumber.enabled = shareRide;
  self.tfRideFrom.enabled = shareRide;
  self.tfRideTo.enabled = shareRide;
  self.tfRideNumberOfSeats.enabled = shareRide;
  self.tfRideWhen.enabled = shareRide;
  self.tfRideCost.enabled = shareRide;
  self.type.enabled = shareRide;
  self.btnFromMap.enabled = shareRide;
  self.btnToMap.enabled = shareRide;
  self.time.enabled = shareRide;
  
}



- (IBAction)doShowRoute:(id)sender
{
	[self.view endEditing:YES];
  
  NSString *alertMsg = @"";
  BOOL isValid = NO;
  if(self.tfRideName.text.length == 0)
    alertMsg = @"Enter Ride Name";
  else if(self.tfRideNumber.text.length == 0)
    alertMsg = @"Enter Vehicle Number";
  else if(self.tfRideFrom.text.length == 0)
    alertMsg = @"Enter From location";
  else if(self.tfRideTo.text.length == 0)
    alertMsg = @"Enter To location";
  else if(self.tfRideNumberOfSeats.text.length == 0)
    alertMsg = @"Enter Number of seats";
  else if(self.tfRideCost.text.length == 0)
    alertMsg = @"Enter Cost per Km";
  else
    isValid = YES;
  
  if(!isValid)
    {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops! You missed some details" message:alertMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    }
  else
    {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dict setObject:self.tfRideName.text forKey:@"name"];
    [dict setObject:self.tfRideNumber.text forKey:@"number"];
    
    NSDictionary *fromData = [APP_DELEGATE.gloabalDicti valueForKey:@"From"];
    [dict setObject:[fromData valueForKey:@"lat"] forKey:@"fromlat"];
    [dict setObject:[fromData valueForKey:@"lat"] forKey:@"fromlang"];
    
    NSDictionary *toData = [APP_DELEGATE.gloabalDicti valueForKey:@"To"];
    [dict setObject:[toData valueForKey:@"lat"] forKey:@"tolat"];
    [dict setObject:[toData valueForKey:@"lat"] forKey:@"tolang"];
    
    if(self.time.selectedSegmentIndex == 0)
      [dict setObject:@"Single" forKey:@"rideoption"];
    else
      [dict setObject:@"Periodic" forKey:@"rideoption"];
    
    if(self.type.selectedSegmentIndex == 0)
      [dict setObject:@"Hatch" forKey:@"ridetype"];
    else  if(self.type.selectedSegmentIndex == 0)
      [dict setObject:@"SUV" forKey:@"ridetype"];
    else
      [dict setObject:@"Sedan" forKey:@"ridetype"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [df dateFromString:self.tfRideWhen.text];
    [df setDateFormat:@"yyyyMMddhhmmss"];
    
    [dict setObject:[df stringFromDate:date] forKey:@"ridewhen"];
    [dict setObject:self.tfRideCost.text forKey:@"ridecost"];
    
    [APP_DELEGATE.gloabalDicti setObject:dict forKey:@"RideInfo"];
    GTShowRouteViewController *shwVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GTShowRouteViewController"];
    [self.navigationController pushViewController:shwVC animated:YES];
    }
}

-(IBAction)selectLadies:(id)sender
{
  UIButton *btn = (UIButton *)sender;
  if(btn.selected)
    btn.selected = NO;
  else
    btn.selected = YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  [self.view endEditing:YES];
  if([segue.identifier isEqualToString:@"Map"])
    {
    GTMapViewController *map = segue.destinationViewController;
    map.delegate = self;
    
    UIButton *btn = (UIButton*)sender;
    [APP_DELEGATE.gloabalDicti setObject:[NSString stringWithFormat:@"%d",btn.tag] forKey:@"locationType"];
    
    if(btn.tag == 1)
      [APP_DELEGATE.gloabalDicti setObject:self.tfRideFrom.text forKey:@"location"];
    else
      [APP_DELEGATE.gloabalDicti setObject:self.tfRideTo.text forKey:@"location"];
    
    }
  
  if([segue.identifier isEqualToString:@"Date"])
    {
    GTDatePickerViewController *date = segue.destinationViewController;
    date.delegate = self;
    }
}

-(void)selectedDate:(NSString *)date
{
  self.tfRideWhen.text = date;
}



#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ([textField isEqual:self.tfRideName]) {
		[self.tfRideNumber becomeFirstResponder];
	}
	else if ([textField isEqual:self.tfRideNumber]) {
		[self.tfRideNumberOfSeats becomeFirstResponder];
	}
  else if ([textField isEqual:self.tfRideNumberOfSeats]) {
		[self.tfRideWhen becomeFirstResponder];
	}
  else if ([textField isEqual:self.tfRideWhen]) {
		[self.tfRideCost becomeFirstResponder];
	}
  else if ([textField isEqual:self.tfRideCost]) {
		[self.tfRideCost resignFirstResponder];
	}
  
	return NO;
}


-(void)selectedAddress:(NSDictionary *)addr forAddress:(int)tag
{
  if(tag == 1)
    self.tfRideFrom.text = [addr valueForKey:@"locality_desc"];
  else
    self.tfRideTo.text = [addr valueForKey:@"locality_desc"];
}


@end
