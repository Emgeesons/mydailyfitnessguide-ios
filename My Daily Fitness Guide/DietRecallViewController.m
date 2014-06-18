//
//  DietRecallViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 20/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "DietRecallViewController.h"
#import "DietTableViewController.h"
#import "View+MASShorthandAdditions.h"
#import "MVPopupTransition.h"

@interface DietRecallViewController () {
    FMDatabase *database;
}

@end

@implementation DietRecallViewController

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
    
    self.title = @"Dietary Recall";
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStylePlain target:self action:@selector(nextClicked)];
    
    self.navigationItem.rightBarButtonItem = nextButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = backButton;
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

-(void)nextClicked {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"dietResult"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    // for Breakfast
    NSDictionary *tmpBreakfast = [[NSUserDefaults standardUserDefaults] objectForKey:@"Breakfast"];
    if (tmpBreakfast.count > 0) {
        [self.btnBreakfast setBackgroundImage:[UIImage imageNamed:@"tick_mark_green.png"] forState:UIControlStateNormal];
    }
    
    // for Lunch
    NSDictionary *tmpLunch = [[NSUserDefaults standardUserDefaults] objectForKey:@"Lunch"];
    if (tmpLunch.count > 0) {
        [self.btnlunch setBackgroundImage:[UIImage imageNamed:@"tick_mark_green.png"] forState:UIControlStateNormal];
    }
    
    // for Snacks
    NSDictionary *tmpSnacks = [[NSUserDefaults standardUserDefaults] objectForKey:@"Snacks"];
    if (tmpSnacks.count > 0) {
        [self.Snacks setBackgroundImage:[UIImage imageNamed:@"tick_mark_green.png"] forState:UIControlStateNormal];
    }
    
    // for Dinner
    NSDictionary *tmpDinner = [[NSUserDefaults standardUserDefaults] objectForKey:@"Dinner"];
    if (tmpDinner.count > 0) {
        [self.btnDinner setBackgroundImage:[UIImage imageNamed:@"tick_mark_green.png"] forState:UIControlStateNormal];
    }
    
    // for Bedtime
    NSDictionary *tmpBedtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"Bedtime"];
    if (tmpBedtime.count > 0) {
        [self.btnBedtime setBackgroundImage:[UIImage imageNamed:@"tick_mark_green.png"] forState:UIControlStateNormal];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"breakfast"]) {
        DietTableViewController *v = (DietTableViewController *)segue.destinationViewController;
        v.dietType = @"Breakfast";
    }
    
    if ([segue.identifier isEqualToString:@"lunch"]) {
        DietTableViewController *v = (DietTableViewController *)segue.destinationViewController;
        v.dietType = @"Lunch";
    }
    
    if ([segue.identifier isEqualToString:@"snacks"]) {
        DietTableViewController *v = (DietTableViewController *)segue.destinationViewController;
        v.dietType = @"Snacks";
    }
    
    if ([segue.identifier isEqualToString:@"dinner"]) {
        DietTableViewController *v = (DietTableViewController *)segue.destinationViewController;
        v.dietType = @"Dinner";
    }
    
    if ([segue.identifier isEqualToString:@"bedtime"]) {
        DietTableViewController *v = (DietTableViewController *)segue.destinationViewController;
        v.dietType = @"Bedtime";
    }
    
}

- (IBAction)switchClicked:(id)sender {
    [database open];
    
    NSString *value;
    if ([sender isOn]) {
        value = @"veg";
    } else {
        value = @"nonveg";
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"energy"];
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"carbohydrates"];
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"protiens"];
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"fats"];
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"fibre"];
    
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"Breakfast"];
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"Lunch"];
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"Snacks"];
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"Dinner"];
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"Bedtime"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.btnBreakfast setBackgroundImage:[UIImage imageNamed:@"btn_add.png"] forState:UIControlStateNormal];
    [self.btnlunch setBackgroundImage:[UIImage imageNamed:@"btn_add.png"] forState:UIControlStateNormal];
    [self.Snacks setBackgroundImage:[UIImage imageNamed:@"btn_add.png"] forState:UIControlStateNormal];
    [self.btnDinner setBackgroundImage:[UIImage imageNamed:@"btn_add.png"] forState:UIControlStateNormal];
    [self.btnBedtime setBackgroundImage:[UIImage imageNamed:@"btn_add.png"] forState:UIControlStateNormal];
    
    [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", value, @"vegNonVeg"];
    
    [database close];
}
@end