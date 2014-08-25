//
//  GTDatePickerViewController.h
//  GoTogetherApp
//
//  Created by Janani on 8/24/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateDelegate <NSObject>

-(void)selectedDate:(NSString *) date;
@end

@interface GTDatePickerViewController : UIViewController
@property (nonatomic,retain) id<DateDelegate> delegate;

@end
