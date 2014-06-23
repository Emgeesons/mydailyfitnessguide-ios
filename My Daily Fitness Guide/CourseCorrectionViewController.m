//
//  CourseCorrectionViewController.m
//  My Daily Fitness Guide
//
//  Created by Yogesh Suthar on 02/06/2014.
//  Copyright (c) 2014 Yogesh Suthar. All rights reserved.
//

#import "CourseCorrectionViewController.h"
#import "SWRevealViewController.h"
#import "FirstTabViewController.h"
#import "BodyStatsViewController.h"

@interface CourseCorrectionViewController () {
    NSArray *tableData;
    NSIndexPath* checkedIndexPath;
    FMDatabase *database;
    NSString *beginWeight, *endWeight;
}

@end

@implementation CourseCorrectionViewController

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
    
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"courseCorrection"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navBar setBounds:CGRectMake(0, 0, 320, 81)];
    [self.navBar setBarTintColor:[UIColor blackColor]];
    
    self.navItem.title = @"Course Correction";
    
    /*UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed)];
    
    self.navItem.rightBarButtonItem = btnDone;*/
    
    tableData = @[@"Fat", @"Muscle", @"Don't Know"];
    
    [database open];
    // beginWeight
    FMResultSet *results = [database executeQuery:@"SELECT type, value FROM fitnessMainData WHERE type = 'weight'"];
    while([results next]) {
        beginWeight = [results stringForColumn:@"value"];
    }
    
    //
    FMResultSet *results1 = [database executeQuery:@"SELECT weight FROM monthLog ORDER BY id DESC LIMIT 0,1"];
    while([results1 next]) {
        endWeight = [results1 stringForColumn:@"weight"];
    }
    
    [database close];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Delegate methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = tableData[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //do work for checkmark
    /*if(checkedIndexPath)
    {
        UITableViewCell* uncheckCell = [tableView
                                        cellForRowAtIndexPath:checkedIndexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    }
    if([checkedIndexPath isEqual:indexPath])
    {
        NSLog(@"nothing");
        checkedIndexPath = nil;
    }
    else
    {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        checkedIndexPath = indexPath;
        NSLog(@"set");
    }*/
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *string = cell.textLabel.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    if ([string isEqualToString:@"Fat"]) {
        if (([endWeight doubleValue] - [beginWeight doubleValue]) < 1.49) {
            alert.message = @"That's not very good. Looks like you need to concentrate on your program more if you want to see good results.\nContinue with your schedule as mentioned and add 5 - 10 mins to your cardio session to see better results.";
        } else if (([endWeight doubleValue] - [beginWeight doubleValue]) < 2.49) {
            alert.message = @"That's not very good. Looks like you need to concentrate on your program more if you want to see good results.\nContinue with your schedule as mentioned and add 10 - 15 mins to your cardio session to see better results.";
        } else {
            alert.message = @"That's not very good. Looks like you need to concentrate on your program more if you want to see good results.\nContinue with your schedule as mentioned and add 15 - 20 mins to your cardio session to see better results.";
        }
        
        //alert.message = @"";
    } else if ([string isEqualToString:@"Muscle"]) {
        alert.message = @"That's great, You are very close to your goal. Continue with your workouts.";
    } else if ([string isEqualToString:@"Don't Know"]) {
        alert.message = @"It would be good if you can check this out. Please visit your nearest gym to do a Body analysis. Continue with your workouts.";
    }
    [alert show];
}

#pragma mark - UIAlertView Delegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIViewController *v = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 1;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:v animated:NO completion:nil];
    }
}

@end
