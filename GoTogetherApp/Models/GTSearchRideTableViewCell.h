//
//  GTSearchRideTableViewCell.h
//  Ride2Gether
//
//  Created by Janani on 8/24/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTSearchRideTableViewCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *lblName;
@property (nonatomic,retain) IBOutlet UILabel *lblVehicleNo;
@property (nonatomic,retain) IBOutlet UILabel *lblDate;
@property (nonatomic,retain) IBOutlet UIButton *btnVerify;

@end
