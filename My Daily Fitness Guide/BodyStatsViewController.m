//
//  BodyStatsViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 02/06/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "BodyStatsViewController.h"
#import "WeeklySchedule.h"
#import "CourseCorrectionViewController.h"

@interface BodyStatsViewController () {
    FMDatabase *database;
    WeeklySchedule *week;
}

@end

@implementation BodyStatsViewController

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
    
    self.navItem.title = @"Log your Body Stats";
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed)];
    
    self.navItem.rightBarButtonItem = btnDone;
    
    // initialize WeklySchedule class
    week = [[WeeklySchedule alloc] initialize];
    
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
        [self.btnKgs setAlpha:0.5f];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneButtonPressed {
    if ([self.txtWeight.text isEqualToString:@""] && self.txtWeight.text.length < 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Hey, Enter Your Stats So We Can Track Your Progress" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self.txtWeight becomeFirstResponder];
        return;
    }
    
    if ([self.txtPBF.text doubleValue] > 100) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Hey, PBF can't be more than 100." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self.txtPBF becomeFirstResponder];
        return;
    }
    
    NSString *weightType, *smmWeight, *weight;
    if (self.btnPound.alpha == 0.5) {
        // kgs is selected
        weightType = @"kgs";
        smmWeight = self.txtSMM.text;
        weight = self.txtWeight.text;
    } else {
        // pounds is selected
        weightType = @"pounds";
        smmWeight = [NSString stringWithFormat:@"%f", [self.txtSMM.text doubleValue] / KGS_CONVERSION];
        weight = [NSString stringWithFormat:@"%f", [self.txtWeight.text doubleValue] / KGS_CONVERSION];
    }
    
    int month = [week getMonth];
    
    [database open];
    [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", weightType, @"weightType"];
    [database executeUpdate:@"INSERT INTO monthLog(monthNumber, weight, pbf, smm) VALUES(?, ?, ?, ?)" , [NSString stringWithFormat:@"%d", month], weight, self.txtPBF.text, smmWeight, nil];
    
    // get goal, program, beginWeight
    FMResultSet *results = [database executeQuery:@"SELECT type, value FROM fitnessMainData"];
    NSString *goal, *program, *beginWeight, *weightAmount;
    while([results next]) {
        if ([[results stringForColumn:@"type"] isEqualToString:@"goal"]) {
            goal = [results stringForColumn:@"value"];
        } else if([[results stringForColumn:@"type"] isEqualToString:@"programType"]) {
            program = [results stringForColumn:@"value"];
        } else if([[results stringForColumn:@"type"] isEqualToString:@"weight"]) {
            beginWeight = [results stringForColumn:@"value"];
        } else if([[results stringForColumn:@"type"] isEqualToString:@"kgsLossGain"]) {
            weightAmount = [results stringForColumn:@"value"];
        }
    }
    [database close];
    
    if ([goal isEqualToString:@"Begun"]) {
        if ([program isEqualToString:@"weightGain"]) {
            // weight gain
            if ([self.txtWeight.text doubleValue] >= ([beginWeight doubleValue] + [weightAmount doubleValue])) {
                [database open];
                [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", @"Achieved", @"goal"];
                [database close];
            }
        } else {
            // weight loss
            if ([self.txtWeight.text doubleValue] <= ([beginWeight doubleValue] - [weightAmount doubleValue])) {
                [database open];
                [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", @"Achieved", @"goal"];
                [database close];
            } else if ([self.txtWeight.text doubleValue] > [beginWeight doubleValue]) {
                NSString *courseCorrection = [[NSUserDefaults standardUserDefaults] objectForKey:@"courseCorrection"];
                if ([courseCorrection isEqualToString:@"no"] || courseCorrection == NULL) {
                    // open Course Correction screen
                    CourseCorrectionViewController *viewController = (CourseCorrectionViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"courseCorrectionViewController"];
                    [self presentViewController:viewController animated:YES completion:nil];
                }
            }
        }
    } else if ([goal isEqualToString:@"Indeterminate"]) {
        if ([program isEqualToString:@"weightGain"]) {
            // weight gain
            if ([self.txtWeight.text doubleValue] >= ([beginWeight doubleValue] + [weightAmount doubleValue])) {
                [database open];
                [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", @"Achieved", @"goal"];
                [database close];
            } else {
                [database open];
                [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", @"Not Achieved", @"goal"];
                [database close];
            }
        } else {
            // weight loss
            if ([self.txtWeight.text doubleValue] <= ([beginWeight doubleValue] - [weightAmount doubleValue])) {
                [database open];
                [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", @"Achieved", @"goal"];
                [database close];
            } else {
                [database open];
                [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", @"Not Achieved", @"goal"];
                [database close];
            }
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)poundClicked:(id)sender {
    [self.btnPound setAlpha:1.0f];
    [self.btnKgs setAlpha:0.5f];
}

- (IBAction)kgsClicked:(id)sender {
    [self.btnPound setAlpha:0.5f];
    [self.btnKgs setAlpha:1.0f];
}

#pragma mark - UITextField Delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.txtWeight) {
        [self.txtPBF becomeFirstResponder];
        return NO;
    } else if (textField == self.txtPBF) {
        [self.txtSMM becomeFirstResponder];
        return NO;
    }
    return YES;
}


@end
