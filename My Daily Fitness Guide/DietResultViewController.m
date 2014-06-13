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
    
    // set gradient background color for view
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.viewBack.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHexString:@"#e8e8e8"] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [self.viewBack.layer insertSublayer:gradient atIndex:0];
    
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    
    [self.viewBack setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"welcome_bg.png"]]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextClicked)];
    
    self.navigationItem.rightBarButtonItem = nextButton;
    
    double oldCarbohydrates = [[[NSUserDefaults standardUserDefaults] objectForKey:@"carbohydrates"] doubleValue];
    double oldProtiens = [[[NSUserDefaults standardUserDefaults] objectForKey:@"protiens"] doubleValue];
    double oldFats = [[[NSUserDefaults standardUserDefaults] objectForKey:@"fats"] doubleValue];
    double oldFibre = [[[NSUserDefaults standardUserDefaults] objectForKey:@"fibre"] doubleValue];
    
    double total = oldCarbohydrates + oldProtiens + oldFats;
    double perCarbohydrates, perProtiens, perFats, perFibre;
    
    perCarbohydrates = (oldCarbohydrates * 100)/ total;
    perProtiens = (oldProtiens * 100)/ total;
    perFats = (oldFats * 100)/ total;
    perFibre = (14 * total) / 1000;
    
    // For carbohydrates
    if (perCarbohydrates > 60) {
        self.lblCarbohydrates.text = @"High Intake of Carbohydrates";
    } else if (perCarbohydrates == 60) {
        self.lblCarbohydrates.text = @"Normal Intake of Carbohydrates";
    } else {
        self.lblCarbohydrates.text = @"Less Intake of Carbohydrates";
    }
    
    // For Protiens
    if (perProtiens > 30) {
        self.lblProtiens.text = @"High Intake of Protien";
    } else if (perProtiens >= 25 && perProtiens <= 30) {
        self.lblProtiens.text = @"Normal Intake of Protien";
    } else {
        self.lblProtiens.text = @"Less Intake of Protien";
    }
    
    // For Fats
    if (perFats > 15) {
        self.lblFats.text = @"High Intake of Fat";
    } else if (perFats >= 10 && perFats <= 15) {
        self.lblFats.text = @"Normal Intake of Fat";
    } else {
        self.lblFats.text = @"Less Intake of Fat";
    }
    
    // For Fibre
    if (perFibre < oldFibre) {
        self.lblFibre.text = @"Good Intake of Fibre";
    } else if (perFibre == oldFibre) {
        self.lblFibre.text = @"Normal Intake of Fibre";
    } else {
        self.lblFibre.text = @"Poor Intake of Fibre";
    }
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
