//
//  GTRegisterViewController.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 7/30/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "GTRegisterViewController.h"
#import "UserWorker.h"
#import "ASTextField.h"
#import "GTAppDelegate.h"
#import "JSQFlatButton.h"

typedef enum {
	kActionSignIn,
	kActionRegister
}Type;

@interface FooterView : UIView

@property (nonatomic, strong) JSQFlatButton *buttonRight;
@property (nonatomic, strong) JSQFlatButton *buttonLeft;

@end

@interface GTRegisterViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *textFields;
@property (nonatomic, assign) NSInteger totalFieldsToDisplay;
@property (nonatomic, assign) Type type;

@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *texts;

@property (strong, nonatomic) FooterView *footerView;


- (void)doRegister:(id)sender;
- (void)doSignIn:(id)sender;

@end

@implementation GTRegisterViewController

- (void)awakeFromNib
{
	self.textFields = [NSMutableArray new];
	self.images = @[@"user_name_icon", @"password_icon", @"confirm_password_icon"];
	self.texts = @[@"User Name", @"Password", @"Confirm Password"];

	self.totalFieldsToDisplay = 2;
	self.type = kActionSignIn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.footerView = [FooterView new];
	[self.footerView.buttonRight setTitle:@"Sign In" forState:UIControlStateNormal];
	[self.footerView.buttonRight addTarget:self action:@selector(doActionForRight:) forControlEvents:UIControlEventTouchUpInside];
	[self.footerView.buttonLeft setTitle:@"New" forState:UIControlStateNormal];
	[self.footerView.buttonLeft addTarget:self action:@selector(doActionForLeft:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doSignIn:(id)sender
{

}

- (void)doRegister:(UIBarButtonItem *)sender
{
	[APP_DELEGATE.hud setLabelText:@"Registering..."];

	__block BOOL registrationDone = NO;

	[APP_DELEGATE.hud showAnimated:YES
			   whileExecutingBlock:^{
				   //					 NSString *deviceToken = [APP_DELEGATE.gloabalDicti objectForKey:@"devicetoken"];
				   //				   registrationDone =
				   //				   [UserWorker doRegisteration:@{@"user": self.tfUserID.text,
				   //												 @"password" : self.tfPassword.text,
				   //												 @"devicetoken": deviceToken?deviceToken:@""}];
			   } completionBlock:^{
				   if (registrationDone) {
					   [self performSegueWithIdentifier:@"login" sender:self];
				   }
			   }];
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	return YES;
}

#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 60;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.totalFieldsToDisplay;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	static NSInteger textFieldTag = 900;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		ASTextField *textField = [[ASTextField alloc] initWithFrame:CGRectInset(cell.bounds, 20, 2)];
		[textField setBorderStyle:UITextBorderStyleNone];
		[textField setTag:900];
		[cell.contentView addSubview:textField];
		[textField setTextColor:[UIColor colorWithRed:59/255.f green:76/255.f blue:86/255.f alpha:1]];
		[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[textField setAutocorrectionType:UITextAutocorrectionTypeNo];
		[textField setTintColor:[UIColor colorWithRed:59/255.f green:76/255.f blue:86/255.f alpha:1]];
	}

	ASTextField * textField = (ASTextField*)[cell.contentView viewWithTag:textFieldTag];

	[textField setupTextFieldWithIconName:[self.images objectAtIndex:indexPath.row]];
	[textField setPlaceholder:[self.texts objectAtIndex:indexPath.row]];

	[self.textFields addObject:textField];

	switch (indexPath.row) {
		case 1:
		case 2:
			[textField setSecureTextEntry:YES];
			break;

		default:
			break;
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{

}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{

}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{

}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //set clear color to cell.
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = [UIView new];
	return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	return self.footerView;
}

- (void)doActionForRight:(id)sender
{

}

- (void)doActionForLeft:(id)sender
{
	switch (self.type) {
		case kActionRegister: //// I pressed Already
		{
		self.totalFieldsToDisplay = 2;
		self.type = kActionSignIn;
		[self.tableView beginUpdates];
		NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
		NSArray *indexArray = [NSArray arrayWithObjects:path,nil];
		[self.tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationLeft];
		[self.tableView endUpdates];

		[self.footerView.buttonRight setTitle:@"Sign In" forState:UIControlStateNormal];
		[self.footerView.buttonLeft setTitle:@"New!" forState:UIControlStateNormal];
		}
			break;

		case kActionSignIn: // I pressed new
		{
		self.totalFieldsToDisplay = 3;
		self.type = kActionRegister;
		[self.tableView beginUpdates];
		NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
		NSArray *indexArray = [NSArray arrayWithObjects:path,nil];
		[self.tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationRight];
		[self.tableView endUpdates];

		[self.footerView.buttonRight setTitle:@"Register Me" forState:UIControlStateNormal];
		[self.footerView.buttonLeft setTitle:@"Already?" forState:UIControlStateNormal];
		}
			break;
		default:
			break;
	}
}

@end

#pragma mark - footterView

@interface FooterView ()

@end
@implementation FooterView

- (instancetype)init
{
	self = [super init];

	if (self) {
		self.buttonRight = [[JSQFlatButton alloc] initWithFrame:CGRectZero
												backgroundColor:[UIColor colorWithRed:59/255.f green:76/255.f blue:86/255.f alpha:1]
												foregroundColor:[UIColor whiteColor]
														  title:nil
														  image:nil];

		self.buttonLeft = [[JSQFlatButton alloc] initWithFrame:CGRectZero
											   backgroundColor:[UIColor colorWithRed:59/255.f green:76/255.f blue:86/255.f alpha:1]
											   foregroundColor:[UIColor whiteColor]
														 title:nil
														 image:nil];

		[self addSubview:self.buttonRight];
		[self addSubview:self.buttonLeft];

	}

	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect rect = [self bounds];
	CGRect rect1 = CGRectZero;
	CGRect rect2 = CGRectZero;
	CGRectDivide(rect, &rect1, &rect2, CGRectGetWidth(self.bounds)/2, CGRectMinXEdge);

	[self.buttonLeft setFrame:CGRectInset(rect1, 20, 10)];
	[self.buttonRight setFrame:CGRectInset(rect2, 20, 10)];
}

@end
