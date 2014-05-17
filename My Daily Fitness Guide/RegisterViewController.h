//
//  RegisterViewController.h
//  My Daily Fitness Guide
//
//  Created by yogesh on 14/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UITableViewController <UITextFieldDelegate> {
    UIActionSheet *sheet;
    UIDatePicker *timePicker;
}

// Labels
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblContact;
@property (weak, nonatomic) IBOutlet UILabel *lblArea;
@property (weak, nonatomic) IBOutlet UILabel *lblAge;

// TextFields
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtContact;
@property (weak, nonatomic) IBOutlet UITextField *txtArea;
@property (weak, nonatomic) IBOutlet UITextField *txtAge;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *btnMale;
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;

//methods
- (IBAction)btnNextClicked:(id)sender;
- (IBAction)maleClicked:(id)sender;
- (IBAction)femaleClicked:(id)sender;

@end
