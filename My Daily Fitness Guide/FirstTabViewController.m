//
//  FirstTabViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 15/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "FirstTabViewController.h"
#import "SWRevealViewController.h"
#import "DietPlan.h"
#import "GuidelinesViewController.h"
#import "DosAndDontsViewController.h"
#import "WeeklySchedule.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface FirstTabViewController () {
    FMDatabase *database;
    NSString *weeklyDiet, *vacationDate, *goalState;
    int randomNutritionist, randomTrainer, numberOfRowsNutritionistTableView, top;
    BOOL bTrainer, bNutritionist, bProfile;
    NSArray *dietTips, *trainerTips, *vacationTips;
    float webViewHeight;
    UIWebView *webView;
    UITableView *scheduleTableChild;
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
    
    //WeeklySchedule *w = [[WeeklySchedule alloc] initialize];
    
    top = 0;
    
    // database initialization
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    
    // Find out the path of Religion
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dietTips" ofType:@"plist"];
    
    // Load the file content and read the data into arrays
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    dietTips = [dict objectForKey:@"tips"];
    trainerTips = [dict objectForKey:@"trainerTips"];
    vacationTips = [dict objectForKey:@"vacationTips"];
    
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
    
    [self hideAllViews];
    [self positionViewbelow];
    
    // count the selected medicalCondition and display number of rows.
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT count(selected) as selected FROM medicalCondition WHERE selected='true' AND dietMod = 'yes'"];
    while([results next]) {
        if ([[results stringForColumn:@"selected"] intValue] == 0) {
            numberOfRowsNutritionistTableView = 5;
        } else {
            numberOfRowsNutritionistTableView = 7;
        }
    }
    
    FMResultSet *vacationResult = [database executeQuery:@"SELECT type, value FROM fitnessMainData"];
    while([vacationResult next]) {
        if ([[vacationResult stringForColumn:@"type"] isEqualToString:@"vacationDate"]) {
            vacationDate = [vacationResult stringForColumn:@"value"];
        } else if ([[vacationResult stringForColumn:@"type"] isEqualToString:@"goal"]) {
            goalState = [vacationResult stringForColumn:@"value"];
        }
    }
    
    [database close];
    
    // set btrainer as YES and rest NO
    bTrainer = YES;
    bNutritionist = NO;
    bProfile = NO;
    
    //initialize scheduleTableChild
    scheduleTableChild = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, 280, 300)];
    scheduleTableChild.delegate = self;
    scheduleTableChild.dataSource = self;
    scheduleTableChild.scrollEnabled = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [self hideAllViews];
    [self positionViewbelow];
    
    // generate random numbers here
    randomTrainer = arc4random_uniform(trainerTips.count) + 0;
    randomNutritionist = arc4random_uniform(dietTips.count) + 0;
}

-(void)viewDidAppear:(BOOL)animated {
    [self positionViewbelow];
    
    // load startScreen based on value present in database
    if (bTrainer) {
        [self loadStartViewTrainer];
    } else if (bNutritionist) {
        [self loadStartViewNutritionist];
    } else if (bProfile) {
        [self loadStartViewProfile];
    }
    
}

-(void)positionViewbelow {
    CGRect frame = self.viewStart.frame;
    frame.origin.y = 200;
    self.viewStart.frame = frame;
    self.viewBegin.frame = frame;
    self.viewWeeklyDiet.frame = frame;
    self.vwProfile.frame = frame;
    self.vwTrainerWeeklySchedule.frame = frame;
}

-(void)loadStartViewTrainer {
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT value FROM fitnessMainData WHERE type = 'goal'"];
    NSString *result;
    while([results next]) {
        result = [results stringForColumn:@"value"];
    }
    [database close];
    // For goal is Undefined
    if ([result isEqualToString:@"Undefined"]) {
        CGRect newFrame = self.viewStart.frame;
        newFrame.origin.y = 68;
        self.viewStart.hidden = NO;
        
        [UIView animateWithDuration:0.7f
                              delay:0.0f
                            options: UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             self.viewStart.frame = newFrame;
                         }
                         completion:nil];
    }
    
    // For goal is Set
    else if ([result isEqualToString:@"Set"]) {
        NSString *month, *programType, *weightType;
        double beginWeight = 0.0;
        
        [database open];
        FMResultSet *res = [database executeQuery:@"SELECT type, value FROM fitnessMainData"];
        
        while([res next]) {
            if ([[res stringForColumn:@"type"] isEqualToString:@"weightType"]) {
                weightType = [res stringForColumn:@"value"];
            } else if ([[res stringForColumn:@"type"] isEqualToString:@"durationInMonth"]) {
                month = [res stringForColumn:@"value"];
            } else if ([[res stringForColumn:@"type"] isEqualToString:@"programType"]) {
                programType = [res stringForColumn:@"value"];
            } else if ([[res stringForColumn:@"type"] isEqualToString:@"kgsLossGain"]) {
                beginWeight = [[res stringForColumn:@"value"] doubleValue];
            }
        }
        [database close];
        
        if ([programType isEqualToString:@"weightGain"]) {
            programType = @"gain";
        } else {
            programType = @"loss";
        }
        
        if ([weightType isEqualToString:@"kgs"]) {
            weightType = @"kg(s)";
        } else {
            weightType = @"pound(s)";
            beginWeight = beginWeight * 2.20462;
        }
        
        self.lblBegin.text = [NSString stringWithFormat:@"You need to %@ %.2f in %d month(s)", programType, beginWeight, [month intValue]];
        
        CGRect newFrame = self.viewBegin.frame;
        newFrame.origin.y = 68;
        self.viewBegin.hidden = NO;
        
        [UIView animateWithDuration:0.7f
                              delay:0.0f
                            options: UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             self.viewBegin.frame = newFrame;
                         }
                         completion:nil];
    }
    
    // For goal is Set
    else if ([result isEqualToString:@"Begun"]) {
        CGRect newFrame = self.vwTrainerWeeklySchedule.frame;
        newFrame.origin.y = 68;
        self.vwTrainerWeeklySchedule.hidden = NO;
        
        [UIView animateWithDuration:0.7f
                              delay:0.0f
                            options: UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             self.vwTrainerWeeklySchedule.frame = newFrame;
                         }
                         completion:nil];
        // Add cards based on values here
        
        //-------------------------- Add Tips View Start -------------------------
        
        NSString *tips;
        if ([vacationDate isEqualToString:@""] || vacationDate == NULL) {
            tips = trainerTips[randomTrainer];
        } else {
            tips = vacationTips[0];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 90, 131)];
        if (tips.length < 60) {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"t_m_1.jpg"]];
        } else if (tips.length > 60 && tips.length < 120) {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"t_m_2.jpg"]];
        } else if (tips.length > 120 && tips.length < 160) {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"t_m_3.jpg"]];
        } else {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"t_m_4.jpg"]];
        }
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12]};
        CGRect rect = [tips boundingRectWithSize:CGSizeMake(203, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
        float heightToAdd = MAX(rect.size.height, 70.0f);
        
        UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, top, 300, (heightToAdd + 26))];
        [imageView setFrame:CGRectMake(2, 2, 90, (heightToAdd + 22))];
        yellowView.backgroundColor = [UIColor yellowColor];
        
        UIImageView *quoteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(95, 3, 20, 18)];
        quoteImageView.image = [UIImage imageNamed:@"quotes.png"];
        
        UILabel *lblTips = [[UILabel alloc] initWithFrame:CGRectMake(95, 21, 203, rect.size.height)];
        lblTips.text = tips;
        lblTips.numberOfLines = 0;
        lblTips.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        
        [yellowView addSubview:imageView];
        [yellowView addSubview:quoteImageView];
        [yellowView addSubview:lblTips];
        [self.trainerScrollView addSubview:yellowView];
        
        // set the top value here
        top = top + (heightToAdd + 26);
        
        //-------------------------- Add Tips View End -------------------------
        
        //-------------------------- Add Log your weight Start -----------------
        //if ([result isEqualToString:@"Indeterminate"]) {
            UIView *logWeight = [[UIView alloc] initWithFrame:CGRectMake(0, top + 10, 300, 54)];
            logWeight.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green_panel.png"]];
            UIImageView *alarmImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
            alarmImage.image = [UIImage imageNamed:@"ic_log.png"];
            
            UILabel *lblLogWeight = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 200, 25)];
            lblLogWeight.text = @"Log your Weight";
            lblLogWeight.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        
            UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(280, 20, 7, 15)];
            arrowImage.image = [UIImage imageNamed:@"arrow.png"];
        
            [logWeight addSubview:alarmImage];
            [logWeight addSubview:lblLogWeight];
            [logWeight addSubview:arrowImage];
            [self.trainerScrollView addSubview:logWeight];
            
            // set the top value here
            top = top + 64;
        //}
        //-------------------------- Add Log your weight End -------------------
        
        //-------------------------- Add Log yesterday's workout Start ---------
        // if yesterday's workout is not logged
        UIView *logYesterdayWeight = [[UIView alloc] initWithFrame:CGRectMake(0, top + 10, 300, 54)];
        logYesterdayWeight.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        UIImageView *alarmYesterdayImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
        alarmYesterdayImage.image = [UIImage imageNamed:@"ic_log.png"];
        
        UILabel *lblYesterdayLogWeight = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 250, 25)];
        lblYesterdayLogWeight.text = @"Log Yesterday's Workout";
        lblYesterdayLogWeight.textColor = [UIColor redColor];
        lblYesterdayLogWeight.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        
        UIImageView *arrowYesterdayImage = [[UIImageView alloc] initWithFrame:CGRectMake(280, 20, 7, 15)];
        arrowYesterdayImage.image = [UIImage imageNamed:@"arrow.png"];
        
        [logYesterdayWeight addSubview:alarmYesterdayImage];
        [logYesterdayWeight addSubview:lblYesterdayLogWeight];
        [logYesterdayWeight addSubview:arrowYesterdayImage];
        [self.trainerScrollView addSubview:logYesterdayWeight];
        
        // set the top value here
        top = top + 64;
        //-------------------------- Add Log yesterday's workout End -----------
        
        //-------------------------- Add Weekly Schedule Start -----------------
        UIView *viewSchedule = [[UIView alloc] initWithFrame:CGRectMake(0, top + 10, 300, 350)];
        viewSchedule.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        
        UILabel *lblSchedule = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 20)];
        lblSchedule.text = @"Weekly Schedule";
        //lblSchedule.textColor = [UIColor redColor];
        lblSchedule.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        
        [viewSchedule addSubview:lblSchedule];
        [self.trainerScrollView addSubview:viewSchedule];
        //-------------------------- Add Weekly Schedule End -------------------
    }
}

-(void)loadStartViewNutritionist {
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT value FROM fitnessMainData WHERE type = 'goal'"];
    NSString *result;
    while([results next]) {
        result = [results stringForColumn:@"value"];
    }
    [database close];
    // For goal is Undefined
    if ([result isEqualToString:@"Undefined"]) {
        CGRect newFrame = self.viewStart.frame;
        newFrame.origin.y = 68;
        self.viewStart.hidden = NO;
        
        [UIView animateWithDuration:0.7f
                              delay:0.0f
                            options: UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             self.viewStart.frame = newFrame;
                         }
                         completion:nil];
    }
    
    // For goal is Set
    else if ([result isEqualToString:@"Set"]) {
        NSString *month, *programType, *weightType;
        double beginWeight = 0.0;
        
        [database open];
        FMResultSet *res = [database executeQuery:@"SELECT type, value FROM fitnessMainData"];
        
        while([res next]) {
            if ([[res stringForColumn:@"type"] isEqualToString:@"weightType"]) {
                weightType = [res stringForColumn:@"value"];
            } else if ([[res stringForColumn:@"type"] isEqualToString:@"durationInMonth"]) {
                month = [res stringForColumn:@"value"];
            } else if ([[res stringForColumn:@"type"] isEqualToString:@"programType"]) {
                programType = [res stringForColumn:@"value"];
            } else if ([[res stringForColumn:@"type"] isEqualToString:@"kgsLossGain"]) {
                beginWeight = [[res stringForColumn:@"value"] doubleValue];
            }
        }
        [database close];
        
        if ([programType isEqualToString:@"weightGain"]) {
            programType = @"gain";
        } else {
            programType = @"loss";
        }
        
        if ([weightType isEqualToString:@"kgs"]) {
            weightType = @"kg(s)";
        } else {
            weightType = @"pound(s)";
            beginWeight = beginWeight * 2.20462;
        }
        
        self.lblBegin.text = [NSString stringWithFormat:@"You need to %@ %.2f in %d month(s)", programType, beginWeight, [month intValue]];
        
        CGRect newFrame = self.viewBegin.frame;
        newFrame.origin.y = 68;
        self.viewBegin.hidden = NO;
        
        [UIView animateWithDuration:0.7f
                              delay:0.0f
                            options: UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             self.viewBegin.frame = newFrame;
                         }
                         completion:nil];
    }
    
    // For goal is Set
    else if ([result isEqualToString:@"Begun"]) {
        CGRect newFrame = self.viewWeeklyDiet.frame;
        newFrame.origin.y = 68;
        self.viewWeeklyDiet.hidden = NO;
        
        [UIView animateWithDuration:0.7f
                              delay:0.0f
                            options: UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             self.viewWeeklyDiet.frame = newFrame;
                         }
                         completion:nil];
        DietPlan *dietPlan = [[DietPlan alloc] initialize];
        weeklyDiet = [dietPlan getDiet];
        
        webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        
        webView.scrollView.scrollEnabled = NO;
        webView.backgroundColor = [UIColor clearColor];
        webView.delegate = self;
        
        [webView loadHTMLString:weeklyDiet baseURL:nil];
        [self.tvWeeklyDiet reloadData];
    }
}

-(void)loadStartViewProfile {
    CGRect newFrame = self.vwProfile.frame;
    newFrame.origin.y = 68;
    self.vwProfile.hidden = NO;
    
    [UIView animateWithDuration:0.7f
                          delay:0.0f
                        options: UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         self.vwProfile.frame = newFrame;
                     }
                     completion:nil];
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
    
    // set btrainer as YES and rest NO
    bTrainer = YES;
    bNutritionist = NO;
    bProfile = NO;
    
    [self hideAllViews];
    [self positionViewbelow];
    [self loadStartViewTrainer];
}

-(void)handleNutritionistTap {
    // set current image as active and rest inactive
    [self.btnImageTrainer setBackgroundImage:[UIImage imageNamed:@"trainer_inactive.png"] forState:UIControlStateNormal];
    [self.btnImageNutritionist setBackgroundImage:[UIImage imageNamed:@"nutritionist_active.png"] forState:UIControlStateNormal];
    [self.btnIamgeProfile setBackgroundImage:[UIImage imageNamed:@"profile_inactive.png"] forState:UIControlStateNormal];
    
    self.btnLabelTrainer.titleLabel.textColor = [UIColor whiteColor];
    self.btnLabelNutritionist.titleLabel.textColor = [UIColor yellowColor];
    self.btnLabelProfile.titleLabel.textColor = [UIColor whiteColor];
    
    // set bNutritionist as YES and rest NO
    bTrainer = NO;
    bNutritionist = YES;
    bProfile = NO;
    
    [self hideAllViews];
    [self positionViewbelow];
    [self loadStartViewNutritionist];
}

-(void)handleProfileTap {
    // set current image as active and rest inactive
    [self.btnImageTrainer setBackgroundImage:[UIImage imageNamed:@"trainer_inactive.png"] forState:UIControlStateNormal];
    [self.btnImageNutritionist setBackgroundImage:[UIImage imageNamed:@"nutritionist_inactive.png"] forState:UIControlStateNormal];
    [self.btnIamgeProfile setBackgroundImage:[UIImage imageNamed:@"profile_active.png"] forState:UIControlStateNormal];
    
    self.btnLabelTrainer.titleLabel.textColor = [UIColor whiteColor];
    self.btnLabelNutritionist.titleLabel.textColor = [UIColor whiteColor];
    self.btnLabelProfile.titleLabel.textColor = [UIColor yellowColor];
    
    // set bProfile as YES and rest NO
    bTrainer = NO;
    bNutritionist = NO;
    bProfile = YES;
    
    [self hideAllViews];
    [self positionViewbelow];
    [self loadStartViewProfile];
}

-(void)hideAllViews {
    self.viewStart.hidden = YES;
    self.viewBegin.hidden = YES;
    self.viewWeeklyDiet.hidden = YES;
    self.vwProfile.hidden = YES;
    self.vwTrainerWeeklySchedule.hidden = YES;
}

#pragma mark - Button click Events

- (IBAction)btnBeginClicked:(id)sender {
    
    //format date
    NSDateFormatter *FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setLocale: [NSLocale currentLocale]];
    
    //set date format
    [FormatDate setDateFormat:@"YYYY-MM-dd"];
    NSString *start_date = [FormatDate stringFromDate:[NSDate date]];
    
    [database open];
    
    FMResultSet *res = [database executeQuery:@"SELECT value FROM fitnessMainData WHERE type ='durationInMonth'"];
    int month = 0, days;
    while([res next]) {
        month = [[res stringForColumn:@"value"] integerValue];
    }
    
    days = month * 30;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd"];
    NSDate *stDate = [format dateFromString:start_date];
    NSDate *enDate = [stDate dateByAddingTimeInterval:60*60*24 * days];
    
    [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", @"Begun", @"goal"];
    [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", start_date, @"start_date"];
    [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", [format stringFromDate:enDate], @"endDate"];
    [database close];
    
    // Now show nutritionist tab with current week's diet plan.
    
    DietPlan *dietPlan = [[DietPlan alloc] initialize];
    weeklyDiet = [dietPlan getDiet];
    [self.tvWeeklyDiet reloadData];
    
    [self handleNutritionistTap];
}

#pragma mark - UITableView Delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tvWeeklyDiet) {
        return 1;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tvWeeklyDiet) {
        return numberOfRowsNutritionistTableView;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tvWeeklyDiet) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
            yellowView.backgroundColor = [UIColor yellowColor];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 90, 96)];
            
            NSString *tips = dietTips[randomNutritionist];
            
            if (tips.length < 60) {
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"n_m_1.jpg"]];
            } else if (tips.length > 60 && tips.length < 120) {
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"n_m_2.jpg"]];
            } else if (tips.length > 120 && tips.length < 160) {
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"n_m_3.jpg"]];
            } else {
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"n_m_4.jpg"]];
            }
            
            UIImageView *quoteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(95, 3, 20, 18)];
            quoteImageView.image = [UIImage imageNamed:@"quotes.png"];
            
            UILabel *lblTips = [[UILabel alloc] initWithFrame:CGRectMake(95, 20, 203, 90)];
            lblTips.text = tips;
            lblTips.numberOfLines = 0;
            lblTips.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
            
            [yellowView addSubview:imageView];
            [yellowView addSubview:quoteImageView];
            [yellowView addSubview:lblTips];
            
            [cell.contentView addSubview:yellowView];
        } else if (indexPath.row == 2) {
            // call function for disabling long press on uiwebview
            [self longPress:webView];
            [webView setFrame:CGRectMake(0, 0, CELL_CONTENT_WIDTH, webViewHeight)];
            [cell.contentView addSubview:webView];
            
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"Guidelines";
            cell.imageView.image = [UIImage imageNamed:@"ic_guidelines.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        } else if (indexPath.row == 6) {
            cell.textLabel.text = @"Do's and Dont's";
            cell.imageView.image = [UIImage imageNamed:@"ic_dos_and_donts.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        }
        
        return cell;
    }
    return NULL;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tvWeeklyDiet) {
        if (indexPath.row == 0) {
            return 100;
        } else if (indexPath.row == 2) {
            return webViewHeight;
        } else if (indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 8) {
            return 44;
        }
    }
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tvWeeklyDiet) {
        if (indexPath.row == 4) {
            // open Guidelines
            GuidelinesViewController *viewController = (GuidelinesViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"guidelinesViewController"];
            viewController.screenType = @"nutritionist";
            viewController.modalPresentationStyle = UIModalPresentationPageSheet;
            viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:viewController animated:YES completion:nil];
        } else if (indexPath.row == 6) {
            // open do's and don't
            DosAndDontsViewController *viewController = (DosAndDontsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"dosAndDontsViewController"];
            viewController.screenType = @"nutritionist";
            viewController.modalPresentationStyle = UIModalPresentationPageSheet;
            viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
}

#pragma mark - UIWebView Long Press Disable methods

- (void)longPress:(UIView *)webview {
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
    
    // Making sure the allowable movement isn't too narrow
    longPress.allowableMovement=100;
    // This is important - the duration must be long enough to allow taps but not longer than the period in which the scroll view opens the magnifying glass
    longPress.minimumPressDuration=0.3;
    
    longPress.delaysTouchesBegan=YES;
    longPress.delaysTouchesEnded=YES;
    
    longPress.cancelsTouchesInView=YES; // That's when we tell the gesture recognizer to block the gestures we want
    
    [webview addGestureRecognizer:longPress]; // Add the gesture recognizer to the view and scroll view then release
    [webview addGestureRecognizer:longPress];
}

- (void)handleLongPress {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
    webViewHeight = fittingSize.height;
    [self.tvWeeklyDiet reloadData];
}

@end