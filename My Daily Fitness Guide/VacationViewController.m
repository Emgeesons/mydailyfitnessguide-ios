//
//  VacationViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 31/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "VacationViewController.h"
#import "SWRevealViewController.h"
#import "FirstTabViewController.h"

@interface VacationViewController () {
    FMDatabase *database;
}

@end

@implementation VacationViewController

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
    
    self.title = @"Vacation Mode";
    
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    
    // set left side navigation button
    UIButton *btnMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    [btnMenu setTitle:@"Cancel" forState:UIControlStateNormal];
    //[btnMenu setBackgroundImage:[UIImage imageNamed:navigationImage] forState:UIControlStateNormal];
    [btnMenu addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * menuButton = [[UIBarButtonItem alloc] initWithCustomView:btnMenu];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [btnOK setTitle:@"OK" forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(btnOKPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * okButton = [[UIBarButtonItem alloc] initWithCustomView:btnOK];
    self.navigationItem.rightBarButtonItem = okButton;
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.datePicker.minimumDate = [NSDate date];
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

-(void)cancelBtnClicked {
    FirstTabViewController *dvc = (FirstTabViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"firstTab"];
    UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
    [navController setViewControllers: @[dvc] animated: NO ];
}

-(void)btnOKPressed {
    //format date
    NSDateFormatter *FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setLocale: [NSLocale currentLocale]];
    
    //set date format
    [FormatDate setDateFormat:@"YYYY-MM-dd"];
    NSString  *end_date = [FormatDate stringFromDate:[self.datePicker date]];
    //NSLog(@"%@", end_date);
    
    NSDate *startDate = [NSDate date];
    NSString *start_date = [FormatDate stringFromDate:startDate];
    
    [database open];
    [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", end_date, @"vacationDate"];
    [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", start_date, @"vacationStartDate"];
    [database close];
    
    [self cancelBtnClicked];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
