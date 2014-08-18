//
//  GTRegisterViewController.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 7/30/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTRegisterViewController.h"
#import "UserWorker.h"
#import "FDTakeController.h"
#import "GTAppDelegate.h"

@interface GTRegisterViewController () <FDTakeDelegate>

@property (nonatomic, strong) FDTakeController* takeController;
@property (nonatomic, strong) NSString *imagePath;
@end

@implementation GTRegisterViewController

- (void)awakeFromNib
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.takeController = [[FDTakeController alloc] init];
    self.takeController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doRegister:(UIBarButtonItem *)sender
{
	[APP_DELEGATE.hud setLabelText:@"Registering..."];

	__block BOOL registrationDone = NO;

	[APP_DELEGATE.hud showAnimated:YES
			   whileExecutingBlock:^{
				   registrationDone = 
				   [UserWorker doRegisteration:[NSArray arrayWithObjects:[self.tfUserID.text length]<=0?nil:self.tfUserID.text,
												[self.tfPassword.text length]<=0?nil:self.tfPassword.text,
												[self.tfConfirmPassword.text length]<=0?nil:self.tfConfirmPassword.text,
												self.tfFirstName.text,
												self.tfLastName.text,
												[NSNumber numberWithBool:YES],
												self.imagePath,
												nil]];
			   } completionBlock:^{
				   if (registrationDone) {
					   [self performSegueWithIdentifier:@"login" sender:self];
				   }
			   }];

}

- (IBAction)doUploadClicked:(id)sender {
	[self.takeController takePhotoOrChooseFromLibrary];
}

#pragma mark FD Delegates
- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt
{
}

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

	self.imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"profile"]];
	NSData *imageData = UIImagePNGRepresentation(photo);
	if ([imageData writeToFile:self.imagePath atomically:YES]) {
		NSLog(@"Image saved to %@", self.imagePath);
	}
	else {
		NSLog(@"Image could not saved.");
	}

    [self.photoView setImage:photo];
}

@end
