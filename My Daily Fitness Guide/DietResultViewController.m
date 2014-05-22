//
//  DietResultViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 22/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "DietResultViewController.h"

@interface DietResultViewController () {
    FMDatabase *database;
}

@end

@implementation DietResultViewController

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
    
    self.title = @"Dietary Recall";
    
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    
    [self.viewBack setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"welcome_bg.png"]]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextClicked)];
    
    self.navigationItem.rightBarButtonItem = nextButton;
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
    //NSLog(@"%@", self.navigationController.viewControllers);
    
    [database open];
    [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", @"Set", @"goal"];
    [database close];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 5] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
