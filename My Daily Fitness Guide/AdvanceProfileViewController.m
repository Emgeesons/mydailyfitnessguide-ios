//
//  AdvanceProfileViewController.m
//  My Daily Fitness Guide
//
//  Created by Yogesh Suthar on 11/06/2014.
//  Copyright (c) 2014 Yogesh Suthar. All rights reserved.
//

#import "AdvanceProfileViewController.h"

@interface AdvanceProfileViewController () {
    FMDatabase *database;
}

@end

@implementation AdvanceProfileViewController

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
    
    [self.navBar setBounds:CGRectMake(0, 0, 320, 81)];
    [self.navBar setBarTintColor:[UIColor blackColor]];
    
    // initialize database
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT value FROM fitnessMainData WHERE type = 'weightType'"];
    NSString *weightType;
    while([results next]) {
        weightType = [results stringForColumn:@"value"];
    }
    [database close];
    
    if ([weightType isEqualToString:@"kgs"]) {
        // kgs selected
        [self.btnPound setAlpha:0.5f];
    } else {
        // pounds selected
        [self.btnKg setAlpha:0.5f];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnPoundsClicked:(id)sender {
    [self.btnPound setAlpha:1.0f];
    [self.btnKg setAlpha:0.5f];
}

- (IBAction)btnKgdClicked:(id)sender {
    [self.btnPound setAlpha:0.5f];
    [self.btnKg setAlpha:1.0f];
}

- (IBAction)doneButtonPressed:(id)sender {
    if ([self.txtPBF.text doubleValue] > 100) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Hey, PBF can't be more than 100." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self.txtPBF becomeFirstResponder];
        return;
    }
    
    NSString *weightType;
    if (self.btnPound.alpha == 0.5) {
        // kgs is selected
        weightType = @"kgs";
    } else {
        // pounds is selected
        weightType = @"pounds";
    }
    
    [database open];
    [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", weightType, @"weightType"];
    
    [database executeUpdate:@"UPDATE monthLog SET pbf = ?, smm = ? WHERE monthNumber = 1", self.txtPBF.text, self.txtSMM.text];
    [database close];
    
    [self backButtonPressed:nil];
}

#pragma mark - UITextField Delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.txtSMM) {
        [self.txtPBF becomeFirstResponder];
        return NO;
    } else if (textField == self.txtPBF) {
        [self.txtSMM resignFirstResponder];
        [self doneButtonPressed:nil];
        
        return YES;
    }
    return YES;
}

@end
