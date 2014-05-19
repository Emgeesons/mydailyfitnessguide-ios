//
//  FirstTabViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 15/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "FirstTabViewController.h"
#import "SWRevealViewController.h"

@interface FirstTabViewController () {
    FMDatabase *database;
}

@end

@implementation FirstTabViewController

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
    
    // database initialization
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    
    // code for changing Back button text color
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
    // set left side navigation button
    UIButton *btnMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    [btnMenu setBackgroundImage:[UIImage imageNamed:navigationImage] forState:UIControlStateNormal];
    [btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * menuButton = [[UIBarButtonItem alloc] initWithCustomView:btnMenu];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.title = [NSString stringWithFormat:@"Howdy %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"name"]];
    
    // Add tap gesture on views of bottom tab
    UITapGestureRecognizer *tapTrainer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleTrainerTap)];
    [self.btnTrainer addGestureRecognizer:tapTrainer];
    
    UITapGestureRecognizer *tapNutritionist = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleNutritionistTap)];
    [self.btnNutritionist addGestureRecognizer:tapNutritionist];
    
    UITapGestureRecognizer *tapProfile = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleProfileTap)];
    [self.btnProfile addGestureRecognizer:tapProfile];
    
    // set background image for viewStart
    [self.viewStart setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"welcome_bg.png"]]];
    
    [self positionViewbelow];
    
    // load startScreen based on value present in database
    [self loadStartView];
}

-(void)positionViewbelow {
    CGRect frame = self.viewStart.frame;
    frame.origin.y = 200;
    self.viewStart.frame = frame;
}

-(void)loadStartView {
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT value FROM fitnessMainData WHERE type = 'goal'"];
    NSString *result;
    while([results next]) {
        result = [results stringForColumn:@"value"];
    }
    
    if ([result isEqualToString:@"Undefined"]) {
        CGRect newFrame = self.viewStart.frame;
        newFrame.origin.y = 68;
        
        [UIView animateWithDuration:0.7f
                              delay:0.0f
                            options: UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             self.viewStart.frame = newFrame;
                         }
                         completion:nil];
    }
    
    [database close];
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

#pragma mark - Tap gesture methods

-(void)handleTrainerTap {
    // set current image as active and rest inactive
    [self.btnImageTrainer setBackgroundImage:[UIImage imageNamed:@"trainer_active.png"] forState:UIControlStateNormal];
    [self.btnImageNutritionist setBackgroundImage:[UIImage imageNamed:@"nutritionist_inactive.png"] forState:UIControlStateNormal];
    [self.btnIamgeProfile setBackgroundImage:[UIImage imageNamed:@"profile_inactive.png"] forState:UIControlStateNormal];
    
    self.btnLabelTrainer.titleLabel.textColor = [UIColor yellowColor];
    self.btnLabelNutritionist.titleLabel.textColor = [UIColor whiteColor];
    self.btnLabelProfile.titleLabel.textColor = [UIColor whiteColor];
}

-(void)handleNutritionistTap {
    // set current image as active and rest inactive
    [self.btnImageTrainer setBackgroundImage:[UIImage imageNamed:@"trainer_inactive.png"] forState:UIControlStateNormal];
    [self.btnImageNutritionist setBackgroundImage:[UIImage imageNamed:@"nutritionist_active.png"] forState:UIControlStateNormal];
    [self.btnIamgeProfile setBackgroundImage:[UIImage imageNamed:@"profile_inactive.png"] forState:UIControlStateNormal];
    
    self.btnLabelTrainer.titleLabel.textColor = [UIColor whiteColor];
    self.btnLabelNutritionist.titleLabel.textColor = [UIColor yellowColor];
    self.btnLabelProfile.titleLabel.textColor = [UIColor whiteColor];
}

-(void)handleProfileTap {
    // set current image as active and rest inactive
    [self.btnImageTrainer setBackgroundImage:[UIImage imageNamed:@"trainer_inactive.png"] forState:UIControlStateNormal];
    [self.btnImageNutritionist setBackgroundImage:[UIImage imageNamed:@"nutritionist_inactive.png"] forState:UIControlStateNormal];
    [self.btnIamgeProfile setBackgroundImage:[UIImage imageNamed:@"profile_active.png"] forState:UIControlStateNormal];
    
    self.btnLabelTrainer.titleLabel.textColor = [UIColor whiteColor];
    self.btnLabelNutritionist.titleLabel.textColor = [UIColor whiteColor];
    self.btnLabelProfile.titleLabel.textColor = [UIColor yellowColor];
}

@end
