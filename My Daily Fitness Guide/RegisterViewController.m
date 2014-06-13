//
//  RegisterViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 14/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () {
    BOOL bName, bEmail, bContact, bArea, bAge, nextClick;
    UIActivityIndicatorView *activityIndicator;
    DatabaseExtra *d;
    NSString *dob;
    NSInteger age;
    UIToolbar *bgToolbar;
    NSDate *datePickerSelectedDate;
}

@end

@implementation RegisterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add UIToolBar to view with alpha 0.7 for transparency
    bgToolbar = [[UIToolbar alloc] initWithFrame:self.view.frame];
    bgToolbar.barStyle = UIBarStyleBlack;
    bgToolbar.alpha = 0.7;
    bgToolbar.translucent = YES;
    
    // initialize activityIndicator and add it to view.
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = CGRectMake(0, 0, 40, 40);
    activityIndicator.center = self.view.center;
    [bgToolbar addSubview:activityIndicator];
    
    //initialize DatabaseExtra class
    d = [[DatabaseExtra alloc] init];
    
    // set female button alpha to 0.5, so male is highlighted
    [self.btnFemale setAlpha:0.5f];
    
    // set NEXT button clicked as NO for boolean value
    nextClick = NO;
    // initialize age as zero
    age = 0;
    
    // Add Logo to UINavigationBar
    UIView *myView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 300, 30)];
    UIImage *image = [UIImage imageNamed:@"nav_bar_icon.png"];
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:image];
    myImageView.frame = CGRectMake(0, 0, 30, 30);
    
    [myView setBackgroundColor:[UIColor  clearColor]];
    [myView addSubview:myImageView];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:myView];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextbox)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 9;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextColor:self.navigationController.navigationBar.tintColor];
    [label setText:@"Welcome! Lets Activate your Account"];

    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    [label setFont:[UIFont boldSystemFontOfSize:11]];
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextColor:self.navigationController.navigationBar.tintColor];
    [label setText:@"We use this information to tailor your workout plans"];
    
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

#pragma mark - TextField Delegate methods

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textView
{
    if (textView == self.txtAge) {
        
        [self resignTextbox];
        
        // Open DatePicker when age textfield is clicked
        sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake ( 0.0, 44.0, 0.0, 0.0)];
        timePicker.backgroundColor = [UIColor whiteColor];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        timePicker.maximumDate = [NSDate date];
        
        if (datePickerSelectedDate) {
            [timePicker setDate:datePickerSelectedDate];
        }
        
        //format datePicker mode. in this example time is used
        timePicker.datePickerMode = UIDatePickerModeDate;
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        UIView *toolbarPicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolbarPicker.backgroundColor = [UIColor grayColor];
        [toolbarPicker sizeToFit];
        
        UIButton *bbitem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [bbitem setTitle:@"Done" forState:UIControlStateNormal];
        [bbitem addTarget:self action:@selector(dateDoneClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *bbitem1 = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 60, 44)];
        [bbitem1 setTitle:@"Cancel" forState:UIControlStateNormal];
        [bbitem1 setTitleColor:[UIColor colorWithHexString:@"#FE2E2E"] forState:UIControlStateNormal];
        [bbitem1 addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [toolbarPicker addSubview:bbitem];
        [toolbarPicker addSubview:bbitem1];
        [sheet addSubview:toolbarPicker];
        [sheet addSubview:toolbarPicker];
        [sheet addSubview:timePicker];
        [sheet showInView:self.view];
        [sheet setBounds:CGRectMake(0,0,320, 464)];
    } else {
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.txtName) {
        [self.txtEmail becomeFirstResponder];
        return NO;
    } else if (textField == self.txtEmail) {
        [self.txtContact becomeFirstResponder];
        return NO;
    } else if (textField == self.txtContact) {
        [self.txtArea becomeFirstResponder];
        return NO;
    } else if (textField == self.txtArea) {
        [self.txtAge becomeFirstResponder];
        return YES;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.txtName) {
        [self.lblName setTextColor:[UIColor blackColor]];
        
        if ([DatabaseExtra trimString:self.txtName].length <= 2) {
            bName = NO;
        }else {
            bName = YES;
        }
    }
    
    if (textField == self.txtEmail) {
        [self.lblEmail setTextColor:[UIColor blackColor]];
        
        if ([self.txtEmail.text isEqualToString:@""] || ![DatabaseExtra isValidEmail:self.txtEmail Strict:YES]) {
            bEmail = NO;
        } else {
            bEmail = YES;
        }
    }
    
    if (textField == self.txtContact) {
        [self.lblContact setTextColor:[UIColor blackColor]];
        
        if (self.txtContact.text.length > 10 || self.txtContact.text.length < 10) {
            bContact = NO;
        } else if (![DatabaseExtra numberValidation:self.txtContact]) {
            bContact = NO;
        } else {
            bContact = YES;
        }
    }
    
    if (textField == self.txtArea) {
        [self.lblArea setTextColor:[UIColor blackColor]];
        
        if ([DatabaseExtra trimString:self.txtArea].length <= 2) {
            bArea = NO;
        }else {
            bArea = YES;
        }
    }
    
    return YES;
}

#pragma mark - Picker Done Buttons

-(void)cancelClicked {
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)dateDoneClicked {
    [self.lblAge setTextColor:[UIColor blackColor]];
    
    //format date
    NSDateFormatter *FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setLocale: [NSLocale currentLocale]];
    
    //set date format
    [FormatDate setDateFormat:@"YYYY-MM-dd"];
    bAge = YES;
    dob = [FormatDate stringFromDate:[timePicker date]];
    age = [DatabaseExtra getAge:[timePicker date]];
    
    datePickerSelectedDate = [timePicker date];
    
    self.txtAge.text = [NSString stringWithFormat:@"%ld yrs", (long)[DatabaseExtra getAge:[timePicker date]]];
    
    timePicker.frame=CGRectMake(0, 44, 320, 416);
    [self cancelClicked];
}

#pragma mark - Methods

- (IBAction)btnNextClicked:(id)sender {
    //check connection
    if (!d.checkConnection) {
        [DatabaseExtra errorInConnection];
        return;
    }
    
    if (nextClick) {
        return;
    }
    
    if (bName && bEmail && bContact && bArea) {
        // server code
        [activityIndicator startAnimating];
        
        [self.view.superview insertSubview:bgToolbar aboveSubview:self.view];
        
        nextClick = YES;
        
        NSString *gender;
        if (self.btnFemale.alpha == 0.5) {
            gender = @"Male";
        } else {
            gender = @"Female";
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"name" : self.txtName.text,
                                     @"email" : self.txtEmail.text,
                                     @"number" : self.txtContact.text,
                                     @"dob" : dob,
                                     @"area" : self.txtArea.text,
                                     @"gender" : gender,
                                     @"device" : [DatabaseExtra getDeviceName]};
        
        [manager POST:registerURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [activityIndicator stopAnimating];
            [bgToolbar removeFromSuperview];
            
            NSDictionary *json = (NSDictionary *)responseObject;
            
            if ([[json objectForKey:@"status"] isEqualToString:@"success"]) {
                
                // fetch server response and set all local data.
                NSDictionary *response = (NSDictionary *)[json objectForKey:@"response"][0];
                NSLog(@"%@", [response objectForKey:@"userId"]);
                
                [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"loggedIn"];
                [[NSUserDefaults standardUserDefaults] setObject:self.txtName.text forKey:@"name"];
                [[NSUserDefaults standardUserDefaults] setObject:dob forKey:@"dob"];
                [[NSUserDefaults standardUserDefaults] setObject:gender forKey:@"gender"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                nextClick = NO;
                
                UIViewController *v = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.8;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self presentViewController:v animated:NO completion:nil];
            } else {
                nextClick = NO;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [activityIndicator stopAnimating];
            [bgToolbar removeFromSuperview];
            
            [DatabaseExtra errorInConnection];
            nextClick = NO;
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:RegisterAlertText delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil, nil];
        [alert show];
        
        if (!bName) {
            [self.lblName setTextColor:[UIColor redColor]];
        }
        
        if (!bEmail) {
            [self.lblEmail setTextColor:[UIColor redColor]];
        }
        
        if (!bContact) {
            [self.lblContact setTextColor:[UIColor redColor]];
        }
        
        if (!bArea) {
            [self.lblArea setTextColor:[UIColor redColor]];
        }
        
        if ([self.txtAge.text isEqualToString:@""]) {
            [self.lblAge setTextColor:[UIColor redColor]];
        }
        
    }
}

- (IBAction)maleClicked:(id)sender {
    [self.btnFemale setAlpha:0.5f];
    [self.btnMale setAlpha:1.0f];
}

- (IBAction)femaleClicked:(id)sender {
    [self.btnFemale setAlpha:1.0f];
    [self.btnMale setAlpha:0.5f];
}

-(void)resignTextbox {
    [self.txtName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtContact resignFirstResponder];
    [self.txtArea resignFirstResponder];
}
@end
