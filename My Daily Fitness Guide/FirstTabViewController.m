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

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface FirstTabViewController () {
    FMDatabase *database;
    NSString *weeklyDiet;
    int max, min, numberOfRowsNutritionistTableView;
    BOOL bTrainer, bNutritionist, bProfile;
    NSArray *dietTips;
    float webViewHeight;
    UIWebView *webView;
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
    
    // initialize max and min numbers gor random images
    max = 4, min = 1;
    
    // database initialization
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    
    // Find out the path of Religion
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dietTips" ofType:@"plist"];
    
    // Load the file content and read the data into arrays
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    dietTips = [dict objectForKey:@"tips"];
    
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
    [database close];
    
    // set btrainer as YES and rest NO
    bTrainer = YES;
    bNutritionist = NO;
    bProfile = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [self hideAllViews];
    [self positionViewbelow];
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
        /*CGRect newFrame = self.viewWeeklyDiet.frame;
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
        [self.tvWeeklyDiet reloadData];*/
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
            
            int num = arc4random_uniform(dietTips.count) + 0;
            NSString *tips = dietTips[num];
            
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

            /*double lessHeight;
            if (weeklyDiet.length > 2400 &&  weeklyDiet.length < 2600) {
                lessHeight = 275;
            } else if (weeklyDiet.length > 2600 &&  weeklyDiet.length < 3000) {
                lessHeight = 400;
            } else if (weeklyDiet.length > 3000 &&  weeklyDiet.length < 3300) {
                lessHeight = 300;
            } else if (weeklyDiet.length > 3300 &&  weeklyDiet.length < 3500) {
                lessHeight = 500;
            } else if (weeklyDiet.length > 3500) {
                lessHeight = 425;
            }
            
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGRect textRect = [weeklyDiet boundingRectWithSize:constraint
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]}
                                                 context:nil];
            CGSize size = textRect.size;*/
            
            // call function for disabling long press on uiwebview
            [self longPress:webView];
            
            //removing extra spacing
            //[webView setFrame:CGRectMake(0, 0, CELL_CONTENT_WIDTH, MAX((size.height - lessHeight), 44.0f))];
            [webView setFrame:CGRectMake(0, 0, CELL_CONTENT_WIDTH, webViewHeight)];
            
            //cell.backgroundColor = [UIColor grayColor];
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
            NSString *text = weeklyDiet;
            
            double lessHeight;
            if (weeklyDiet.length > 2400 &&  weeklyDiet.length < 2600) {
                lessHeight = 275;
            } else if (weeklyDiet.length > 2600 &&  weeklyDiet.length < 3000) {
                lessHeight = 400;
            } else if (weeklyDiet.length > 3000 &&  weeklyDiet.length < 3300) {
                lessHeight = 300;
            } else if (weeklyDiet.length > 3300 &&  weeklyDiet.length < 3500) {
                lessHeight = 500;
            } else if (weeklyDiet.length > 3500) {
                lessHeight = 425;
            }
            
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            CGRect textRect = [text boundingRectWithSize:constraint
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]}
                                                 context:nil];
            CGSize size = textRect.size;
            //removing extra spacing
            CGFloat height = MAX((size.height - lessHeight), 44.0f);

            //CGFloat height = MAX((webView.scrollView.contentSize.height), 44.0f);
            return webViewHeight;
        } else if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 5) {
            return 20;
        }
    }
    return 44;
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

- (void)longPress:(UIView *)webView {
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
    
    // Making sure the allowable movement isn't too narrow
    longPress.allowableMovement=100;
    // This is important - the duration must be long enough to allow taps but not longer than the period in which the scroll view opens the magnifying glass
    longPress.minimumPressDuration=0.3;
    
    longPress.delaysTouchesBegan=YES;
    longPress.delaysTouchesEnded=YES;
    
    longPress.cancelsTouchesInView=YES; // That's when we tell the gesture recognizer to block the gestures we want
    
    [webView addGestureRecognizer:longPress]; // Add the gesture recognizer to the view and scroll view then release
    [webView addGestureRecognizer:longPress];
}

// I just need this for the selector in the gesture recognizer.
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
    NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
}

@end