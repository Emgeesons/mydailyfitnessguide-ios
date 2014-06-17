//
//  BMIViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 19/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "BMIViewController.h"

@interface BMIViewController () {
    NSArray *ft, *inch, *txtFt, *txtInch;
    NSInteger feet, inches;
    NSString *gender, *programType, *heightString;
    NSDictionary *scheduleLoss, *scheduleGain;
    FMDatabase *database;
    double bmi, newIBW, numberOfMonths, ibw, weight;
}

@end

@implementation BMIViewController

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
    // Do any additional setup after loading the view.
    
    // initialize database
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    
    self.title = @"Body Stats";
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextClicked)];
    
    self.navigationItem.rightBarButtonItem = nextButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    ft = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    txtFt = @[@"feet"];
    inch = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11"];
    txtInch = @[@"inches"];
    
    gender = [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
    
    [self.btnPound setAlpha:0.5f];
    
    self.lblResult.textColor = self.btnPound.tintColor;
    
    scheduleLoss = @{@"1": @"Basic 1", @"2": @"Basic 2", @"3": @"Basic 2", @"4": @"Intermediate", @"5": @"Intermediate", @"6": @"Intermediate", @"7": @"Advance 1"};
    
    scheduleGain = @{@"1": @"basic 1", @"2": @"basic 2 (no cardio)", @"3": @"intermediate 1", @"4": @"intermediate 2 ( no cardio)", @"5": @"advance 1 (no cardio)", @"6": @"advance 2", @"7": @"Functional training 2"};
}

-(void)setTitle:(NSString *)title {
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:titleFont];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor whiteColor]; // Change to desired color
        
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)nextClicked {
    if (self.txtHeight.text.length != 0 && self.txtWeight.text.length != 0) {
        // update data in table
        [database open];
        
        [self updateBMI];
        
        NSString *weightType;
        if (self.btnPound.alpha == 0.5) {
            // kgs is selected
            weightType = @"kgs";
        } else {
            // pounds is selected
            weightType = @"pounds";
        }
        
        [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", weightType, @"weightType"];
        [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?",[NSString stringWithFormat:@"%d", feet], @"feet"];
        [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", [NSString stringWithFormat:@"%d", inches], @"inches"];
        [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", [NSString stringWithFormat:@"%f", bmi], @"bmi"];
        [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", programType, @"programType"];
        [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", [NSString stringWithFormat:@"%f", newIBW], @"kgsLossGain"];
        [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", [NSString stringWithFormat:@"%f", numberOfMonths], @"durationInMonth"];
        [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", [NSString stringWithFormat:@"%f", ibw], @"targetWeight"];
        [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", [NSString stringWithFormat:@"%f", weight], @"weight"];
        
        [database close];
        
        // open diet screen
        UIViewController *v = [self.storyboard instantiateViewControllerWithIdentifier:@"dietRecall"];
        [self.navigationController pushViewController:v animated:YES];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Don’t feel shy.. Enter your information." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - TextField Delegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.txtWeight) {
        NSCharacterSet *aCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; i++) {
            unichar aCharacter = [string characterAtIndex:i];
            if (![aCharacterSet characterIsMember:aCharacter]) {
                return NO;
            }
        }
        
        NSUInteger newLength = self.txtWeight.text.length + string.length - range.length;
        return (newLength > 3) ? NO : YES;
    }
    return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textView
{
    if (textView == self.txtHeight) {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        [sheet addSubview:pickerView];
        pickerView.backgroundColor = [UIColor whiteColor];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.showsSelectionIndicator = YES;
        
        if (feet != 0 && inches != 0) {
            [pickerView selectRow:[ft indexOfObject:[NSString stringWithFormat:@"%d", feet]] inComponent:0 animated:YES];
            [pickerView selectRow:[inch indexOfObject:[NSString stringWithFormat:@"%d", inches]] inComponent:2 animated:YES];
        }
        
        UIView *toolbarPicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        //toolbarPicker.backgroundColor = [UIColor grayColor];
        toolbarPicker.backgroundColor = [UIColor whiteColor];
        [toolbarPicker sizeToFit];
        
        UIButton *bbitem = [[UIButton alloc] initWithFrame:CGRectMake(255, 0, 60, 44)];
        [bbitem setTitle:@"done" forState:UIControlStateNormal];
        [bbitem setTitleColor:self.btnPound.tintColor forState:UIControlStateNormal];
        [bbitem addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *bbitem1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 60, 44)];
        [bbitem1 setTitle:@"cancel" forState:UIControlStateNormal];
        [bbitem1 setTitleColor:self.btnPound.tintColor forState:UIControlStateNormal];
        [bbitem1 addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [toolbarPicker addSubview:bbitem];
        [toolbarPicker addSubview:bbitem1];
        [sheet addSubview:toolbarPicker];
        
        [sheet showInView:self.view];
        [sheet setBounds:CGRectMake(0, 0, 320, 415)];
    } else {
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self updateBMI];
    return YES;
}

#pragma mark picker dataSouce Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  4;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
        return [ft count];
    else if(component == 1)
        return txtFt.count;
    else if (component == 2)
        return inch.count;
    else
        return  txtInch.count;
}

#pragma mark delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0)
        return ft[row];
    else if (component == 1)
        return txtFt[row];
    else if (component == 2)
        return inch[row];
    else
        return  txtInch[row];
}

- (void)pickerView:(UIPickerView *)pView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    heightString = [NSString stringWithFormat:@"%@ ft %@ in", [ft objectAtIndex:[pickerView selectedRowInComponent:0]], [inch objectAtIndex:[pickerView selectedRowInComponent:2]]];
    
    feet = [[ft objectAtIndex:[pickerView selectedRowInComponent:0]] intValue];
    inches = [[inch objectAtIndex:[pickerView selectedRowInComponent:2]] intValue];
    
    [self updateBMI];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch(component) {
        case 0: return 50;
        case 1: return 50;
        case 2: return 50;
        default: return 150;
    }
    //NOT REACHED
    return 50;
}

-(void)doneClicked {
    self.txtHeight.text = heightString;
    heightString = @"";
    
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)cancelClicked {
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)poundClicked:(id)sender {
    [self.btnPound setAlpha:1.0f];
    [self.btnKgs setAlpha:0.5f];
    [self updateBMI];
}

- (IBAction)kgsClicked:(id)sender {
    [self.btnPound setAlpha:0.5f];
    [self.btnKgs setAlpha:1.0f];
    [self updateBMI];
}

-(void)updateBMI {
    if (self.txtHeight.text.length > 0 && self.txtWeight.text.length > 0) {
        double height, progressValue;
        NSString *weightType;
        
        height = (((feet * 12) + inches)*2.54)/100;
        
        if (self.btnPound.alpha == 0.5) {
            // kgs is selected
            weight = [self.txtWeight.text doubleValue];
        } else {
            // pounds is selected
            weight = [self.txtWeight.text doubleValue]/KGS_CONVERSION;
        }
        bmi = weight/(height * height);
        
        if ([gender isEqualToString:@"Male"]) {
            ibw = (((feet*12)+inches)*2.54)-100;
        } else {
            ibw = (((feet*12)+inches)*2.54)-105;
        }
        
        newIBW = (weight - ibw);
        
        if (newIBW > 0) {
            //NSLog(@"positive");
            weightType = @"kgs Overweight";
            programType = @"weightLoss";
            
            // calculate duration plan for weight loss
            if (newIBW <= 4.5) {
                numberOfMonths = 1;
            } else if (newIBW >= 4.51 && newIBW <= 8.50) {
                numberOfMonths = 2;
            } else if (newIBW >= 8.51 && newIBW <= 10.50) {
                numberOfMonths = 3;
            } else if (newIBW >= 10.51 && newIBW <= 13.50) {
                numberOfMonths = 4;
            } else if (newIBW >= 13.51 && newIBW <= 15.50) {
                numberOfMonths = 5;
            } else if (newIBW >= 15.51 && newIBW <= 18.50) {
                numberOfMonths = 6;
            } else if (newIBW >= 18.51) {
                numberOfMonths = 7;
            }
        } else {
            //NSLog(@"negative");
            weightType = @"kgs Underweight";
            newIBW = fabs(newIBW);
            programType = @"weightGain";
            
            // calculate duration plan for weight gain
            if (newIBW <= 1.5) {
                numberOfMonths = 1;
            } else if (newIBW >= 1.51 && newIBW <= 3.50) {
                numberOfMonths = 2;
            } else if (newIBW >= 3.51 && newIBW <= 5.50) {
                numberOfMonths = 3;
            } else if (newIBW >= 5.51 && newIBW <= 7.00) {
                numberOfMonths = 4;
            } else if (newIBW >= 7.01 && newIBW <= 8.00) {
                numberOfMonths = 5;
            } else if (newIBW >= 8.01 && newIBW <= 9.00) {
                numberOfMonths = 6;
            } else if (newIBW >= 9.01) {
                numberOfMonths = 7;
            }
        }
        
        // code for checking BMI
        if (bmi < 18.5) {
            progressValue = (16.65 * bmi/18.5);
        } else if(bmi <=25){
            progressValue = (33.32 * bmi/25);
        } else if(bmi <=30){
            progressValue = (49.99 * bmi/30);
        } else if(bmi <=35){
            progressValue = (66.66 * bmi/35);
        } else if(bmi <=40){
            progressValue = (83.33 * bmi/40);
        } else {
            progressValue = (100 * bmi/50);
        }

        self.progressView.progress = progressValue / 100;
        
        self.lblResult.text = [NSString stringWithFormat:@"Your BMI is %.2f.\nYou are %.2f %@", bmi, newIBW, weightType];
    }
}
@end
