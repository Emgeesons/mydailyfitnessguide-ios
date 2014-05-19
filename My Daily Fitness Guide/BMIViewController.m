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
    NSString *gender;
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
    
    ft = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    txtFt = @[@"feet"];
    inch = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11"];
    txtInch = @[@"inches"];
    
    gender = [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
    
    [self.btnPound setAlpha:0.5f];
    
    self.lblResult.textColor = self.btnPound.tintColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self updateBMI];
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
        
        UIView *toolbarPicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        //toolbarPicker.backgroundColor = [UIColor grayColor];
        toolbarPicker.backgroundColor = [UIColor whiteColor];
        [toolbarPicker sizeToFit];
        
        UIButton *bbitem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [bbitem setTitle:@"done" forState:UIControlStateNormal];
        [bbitem setTitleColor:self.btnPound.tintColor forState:UIControlStateNormal];
        [bbitem addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *bbitem1 = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 60, 44)];
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
    //[self updateBMI];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

#pragma mark dataSouce Methods
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
    self.txtHeight.text = [NSString stringWithFormat:@"%@ ft %@ inches", [ft objectAtIndex:[pickerView selectedRowInComponent:0]], [inch objectAtIndex:[pickerView selectedRowInComponent:2]]];
    
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

-(void)cancelClicked {
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)poundClicked:(id)sender {
    [self.btnPound setAlpha:1.0f];
    [self.btnKgs setAlpha:0.5f];
}

- (IBAction)kgsClicked:(id)sender {
    [self.btnPound setAlpha:0.5f];
    [self.btnKgs setAlpha:1.0f];
}

-(void)updateBMI {
    if (self.txtHeight.text.length > 0 && self.txtWeight.text.length > 0) {
        double height, bmi, ibw;
        height = (((feet * 12) + inches)*2.54)/100;
        bmi = [self.txtWeight.text intValue]/(height * height);
        
        if ([gender isEqualToString:@"Male"]) {
            ibw = (((feet*12)+inches)*2.54)-100;
        } else {
            ibw = (((feet*12)+inches)*2.54)-105;
        }
        
        self.lblResult.text = [NSString stringWithFormat:@"Your BMI is %.2f.\nYou are %.2f loss", bmi, ([self.txtWeight.text doubleValue] - ibw)];
    }
}
@end
