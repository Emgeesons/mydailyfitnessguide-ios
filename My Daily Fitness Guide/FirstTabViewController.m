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
#import "CustomButton.h"
#import "ExcerciseListViewController.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface FirstTabViewController () {
    FMDatabase *database;
    NSString *weeklyDiet, *vacationDate, *goalState, *yesterdayName;
    int randomNutritionist, randomTrainer, numberOfRowsNutritionistTableView, top;
    BOOL bTrainer, bNutritionist, bProfile;
    NSArray *dietTips, *trainerTips, *vacationTips;
    float webViewHeight;
    UIWebView *webView;
    UITableView *scheduleTableChild;
    CustomButton *btnMonTick, *btnTueTick, *btnWedTick, *btnThurTick, *btnFriTick, *btnSatTick, *btnSunTick, *btnYesterdayTick;
    int mon, tue, wed, thur, fri, sat, sun, yesterdaysDay;
    
    UIView *logYesterdayWeight, *viewSchedule, *viewGuidelines, *viewDAD;
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

- (void) titleView {
    UIView *myView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 300, 30)];
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(70, 0, 300, 30)];
    
    title.text = [NSString stringWithFormat:@"Howdy %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"name"]];
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont boldSystemFontOfSize:titleFont]];
    
    [title setBackgroundColor:[UIColor clearColor]];
    UIImage *image = [UIImage imageNamed:@"nav_bar_icon.png"];
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:image];
    
    myImageView.frame = CGRectMake(30, 0, 30, 30);
    
    [myView addSubview:title];
    [myView setBackgroundColor:[UIColor  clearColor]];
    [myView addSubview:myImageView];
    self.navigationItem.titleView = myView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    [self titleView];
    
    //self.title = [NSString stringWithFormat:@"Howdy %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"name"]];
    
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
    
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT value,type FROM fitnessMainData"];
    NSString *startDate, *endDate;
    
    while([results next]) {
        if ([[results stringForColumn:@"type"] isEqualToString:@"vacationDate"]) {
            startDate = [results stringForColumn:@"value"];
        }
    }
    [database close];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    endDate = [f stringFromDate:[NSDate date]];
    if ([startDate isEqualToString:@""]) {
        
    } else {
        int numberOfDays = [DatabaseExtra numberOfDaysBetween:startDate and:endDate];
        if (numberOfDays > 1) {
            // update database and empty the vacation date
            [database open];
            [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", @"", @"vacationDate"];
            [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = ?", @"", @"vacationStartDate"];
            [database close];
        }
    }
    
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

-(void)assignDay {
    NSString *start_date, *endDate;
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT value FROM fitnessMainData WHERE type = 'start_date'"];

    while([results next]) {
        start_date = [results stringForColumn:@"value"];
    }
    
    [database close];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    endDate = [f stringFromDate:[NSDate date]];
    int numberOfDays = [DatabaseExtra numberOfDaysBetween:start_date and:endDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EE"];
    NSString *dayName = [dateFormatter stringFromDate:[f dateFromString:start_date]];
    
    // set yesterdaysDay here
    yesterdaysDay = numberOfDays - 1;
    
    NSDate *now = [NSDate date];
    
    NSString *currentDayName = [dateFormatter stringFromDate:now];
    
    int daysToAdd = -1;
    NSDate *newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    NSString *yesterDayName = [dateFormatter stringFromDate:newDate1];
    yesterdayName = yesterDayName;
    
    //NSLog(@"%@", dayName);
    
    //NSLog(@"%d", numberOfDays);
    
    if (numberOfDays > 1) {
        if ([currentDayName isEqualToString:@"Mon"]) {
            mon = numberOfDays, tue = (numberOfDays + 1), wed = (numberOfDays + 2), thur = (numberOfDays + 3), fri = (numberOfDays + 4), sat = (numberOfDays + 5), sun = (numberOfDays + 6);
        } else if ([currentDayName isEqualToString:@"Tue"]) {
            mon = (numberOfDays - 1), tue = numberOfDays, wed = (numberOfDays + 1), thur = (numberOfDays + 2), fri = (numberOfDays + 3), sat = (numberOfDays + 4), sun = (numberOfDays + 5);
        } else if ([currentDayName isEqualToString:@"Wed"]) {
            mon = (numberOfDays - 2), tue = (numberOfDays - 1), wed = numberOfDays, thur = (numberOfDays + 1), fri = (numberOfDays + 2), sat = (numberOfDays + 3), sun = (numberOfDays + 4);
        } else if ([currentDayName isEqualToString:@"Thu"]) {
            mon = (numberOfDays - 3), tue = (numberOfDays - 2), wed = (numberOfDays - 1), thur = numberOfDays, fri = (numberOfDays + 1), sat = (numberOfDays + 2), sun = (numberOfDays + 3);
        } else if ([currentDayName isEqualToString:@"Fri"]) {
            mon = (numberOfDays - 4), tue = (numberOfDays - 3), wed = (numberOfDays - 2), thur = (numberOfDays - 1), fri = numberOfDays, sat = (numberOfDays + 1), sun = (numberOfDays + 2);
        } else if ([currentDayName isEqualToString:@"Sat"]) {
            mon = (numberOfDays - 5), tue = (numberOfDays - 4), wed = (numberOfDays - 3), thur = (numberOfDays - 2), fri = (numberOfDays - 1), sat = numberOfDays, sun = (numberOfDays + 1);
        } else if ([currentDayName isEqualToString:@"Sun"]) {
            mon = (numberOfDays - 6), tue = (numberOfDays - 5), wed = (numberOfDays - 4), thur = (numberOfDays - 3), fri = (numberOfDays - 2), sat = (numberOfDays - 1), sun = numberOfDays;
        }
    } else {
        if ([dayName isEqualToString:@"Mon"]) {
            mon = 1, tue = 2, wed = 3, thur = 4, fri = 5, sat = 6, sun = 7;
        } else if ([dayName isEqualToString:@"Tue"]) {
            mon = -1, tue = 1, wed = 2, thur = 3, fri = 4, sat = 5, sun = 6;
        } else if ([dayName isEqualToString:@"Wed"]) {
            mon = -1, tue = -1, wed = 1, thur = 2, fri = 3, sat = 4, sun = 5;
        } else if ([dayName isEqualToString:@"Thu"]) {
            mon = -1, tue = -1, wed = -1, thur = 1, fri = 2, sat = 3, sun = 4;
        } else if ([dayName isEqualToString:@"Fri"]) {
            mon = -1, tue = -1, wed = -1, thur = -1, fri = 1, sat = 2, sun = 3;
        } else if ([dayName isEqualToString:@"Sat"]) {
            mon = -1, tue = -1, wed = -1, thur = -1, fri = -1, sat = 1, sun = 2;
        } else if ([dayName isEqualToString:@"Sun"]) {
            mon = -1, tue = -1, wed = -1, thur = -1, fri = -1, sat = -1, sun = 1;
        }
    }
    //NSLog(@"%@", dayName);
    
    //NSLog(@"%d", numberOfDays);
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
    
    // For goal is Begun
    else if ([result isEqualToString:@"Begun"]) {
        top = 0;
        [self assignDay];
        
        // remove all subviews from scrollview
        [self.trainerScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
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
        if ([result isEqualToString:@"Indeterminate"]) {
            UIView *logWeight = [[UIView alloc] initWithFrame:CGRectMake(0, top + 10, 300, 54)];
            logWeight.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green_panel.png"]];
            UIImageView *alarmImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
            alarmImage.image = [UIImage imageNamed:@"ic_log.png"];
            
            UILabel *lblLogWeight = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 200, 25)];
            lblLogWeight.text = @"Log your Body Stats";
            lblLogWeight.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        
            UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(280, 20, 7, 15)];
            arrowImage.image = [UIImage imageNamed:@"arrow.png"];
        
            [logWeight addSubview:alarmImage];
            [logWeight addSubview:lblLogWeight];
            [logWeight addSubview:arrowImage];
            [self.trainerScrollView addSubview:logWeight];
            
            // set the top value here
            top = top + 64;
        }
        //-------------------------- Add Log your weight End -------------------
        
        //-------------------------- Add Log yesterday's workout Start ---------
        // if yesterday's workout is not logged
        
        logYesterdayWeight = [[UIView alloc] initWithFrame:CGRectMake(0, top + 10, 300, 54)];
        logYesterdayWeight.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        UIImageView *alarmYesterdayImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
        alarmYesterdayImage.image = [UIImage imageNamed:@"ic_log.png"];
        
        UILabel *lblYesterdayLogWeight = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 250, 25)];
        lblYesterdayLogWeight.text = @"Log Yesterday's Workout";
        lblYesterdayLogWeight.textColor = [UIColor redColor];
        lblYesterdayLogWeight.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        
        btnYesterdayTick = [[CustomButton alloc] initWithFrame:CGRectMake(260, 19, 20, 20)];
        [btnYesterdayTick setBackgroundImage:[UIImage imageNamed:@"grey_tickmark.png"] forState:UIControlStateNormal];
        [btnYesterdayTick addTarget:self action:@selector(btnYesterdayTickClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [logYesterdayWeight addSubview:alarmYesterdayImage];
        [logYesterdayWeight addSubview:lblYesterdayLogWeight];
        [logYesterdayWeight addSubview:btnYesterdayTick];
        [self.trainerScrollView addSubview:logYesterdayWeight];
        if ([self dayPresent:yesterdaysDay] && [self checkDayPresent:yesterdaysDay]) {
            // Do nothing
            logYesterdayWeight.alpha = 0;
        } else {
            // check today's date with start_date of database
            [database open];
            
            FMResultSet *results = [database executeQuery:@"SELECT value,type FROM fitnessMainData"];
            NSString *startDate, *endDate;
            
            while([results next]) {
                if ([[results stringForColumn:@"type"] isEqualToString:@"start_date"]) {
                    startDate = [results stringForColumn:@"value"];
                }
            }
            [database close];
            
            NSDateFormatter *f = [[NSDateFormatter alloc] init];
            [f setDateFormat:@"yyyy-MM-dd"];
            endDate = [f stringFromDate:[NSDate date]];
            int numberOfDays = [DatabaseExtra numberOfDaysBetween:startDate and:endDate];
            //NSLog(@"%d", numberOfDays);
            if (numberOfDays > 1) {
                // set the top value here
                top = top + 64;
            } else {
                // Do nothing
                logYesterdayWeight.alpha = 0;
            }
        }
        //-------------------------- Add Log yesterday's workout End -----------
        
        //-------------------------- Add Weekly Schedule Start -----------------
        
        // Get Weekly Schedule
        WeeklySchedule *week = [[WeeklySchedule alloc] initialize];
        NSArray *scheduleArray = [week getWeeklySchedule];
        
        viewSchedule = [[UIView alloc] initWithFrame:CGRectMake(0, top + 10, 300, 370)];
        viewSchedule.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        
        UILabel *lblSchedule = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 20)];
        lblSchedule.text = @"Weekly Schedule";
        lblSchedule.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        
        // -----------------------------------Add btnMon-------------------------------------
        CustomButton *btnMon = [[CustomButton alloc] initWithFrame:CGRectMake(lblSchedule.frame.origin.x, 35, 270, 44)];
        btnMon.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
        btnMon.dayName = @"Mon";
        btnMon.dayWorkout = scheduleArray[0];
        btnMon.dietPlan = scheduleArray[7];
        [btnMon addTarget:self action:@selector(btnScheduleClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lblMon = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 30, 20)];
        lblMon.text = btnMon.dayName;
        lblMon.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        [btnMon addSubview:lblMon];
        
        UILabel *lblMonSchedule = [[UILabel alloc] initWithFrame:CGRectMake(45, 13, 195, 20)];
        lblMonSchedule.text = scheduleArray[0];
        lblMonSchedule.textColor = [UIColor grayColor];
        lblMonSchedule.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
        [btnMon addSubview:lblMonSchedule];
        
        btnMonTick = [[CustomButton alloc] initWithFrame:CGRectMake(245, 13, 20, 20)];
        [btnMonTick setBackgroundImage:[UIImage imageNamed:@"grey_tickmark.png"] forState:UIControlStateNormal];
        if (mon > 0) {
            btnMonTick.dayNumber = mon;
            [btnMonTick addTarget:self action:@selector(btnTickClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([self checkDayPresent:mon]) {
                [btnMonTick setBackgroundImage:[UIImage imageNamed:@"green_tickmark.png"] forState:UIControlStateNormal];
            }
            
            [btnMon addSubview:btnMonTick];
        }
        
        [viewSchedule addSubview:btnMon];
        
        // -----------------------------------Add btnTue-------------------------------------
        CustomButton *btnTue = [[CustomButton alloc] initWithFrame:CGRectMake(btnMon.frame.origin.x, btnMon.frame.origin.y + btnMon.frame.size.height + 2, btnMon.frame.size.width, btnMon.frame.size.height)];
        btnTue.backgroundColor = btnMon.backgroundColor;
        btnTue.dayName = @"Tue";
        btnTue.dayWorkout = scheduleArray[1];
        btnTue.dietPlan = scheduleArray[7];
        [btnTue addTarget:self action:@selector(btnScheduleClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lblTue = [[UILabel alloc] initWithFrame:lblMon.frame];
        lblTue.text = btnTue.dayName;
        lblTue.font = lblMon.font;
        [btnTue addSubview:lblTue];
        
        UILabel *lblTueSchedule = [[UILabel alloc] initWithFrame:lblMonSchedule.frame];
        lblTueSchedule.text = scheduleArray[1];
        lblTueSchedule.textColor = lblMonSchedule.textColor;
        lblTueSchedule.font = lblMonSchedule.font;
        [btnTue addSubview:lblTueSchedule];
        
        btnTueTick = [[CustomButton alloc] initWithFrame:btnMonTick.frame];
        [btnTueTick setBackgroundImage:[UIImage imageNamed:@"grey_tickmark.png"] forState:UIControlStateNormal];
        if (tue > 0) {
            btnTueTick.dayNumber = tue;
            [btnTueTick addTarget:self action:@selector(btnTickClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([self checkDayPresent:tue]) {
                [btnTueTick setBackgroundImage:[UIImage imageNamed:@"green_tickmark.png"] forState:UIControlStateNormal];
            }
            
            [btnTue addSubview:btnTueTick];
        }
        
        [viewSchedule addSubview:btnTue];
        
        // -------------------------------------Add btnWed-------------------------------------
        CustomButton *btnWed = [[CustomButton alloc] initWithFrame:CGRectMake(btnMon.frame.origin.x, btnTue.frame.origin.y + btnMon.frame.size.height + 2, btnMon.frame.size.width, btnMon.frame.size.height)];
        btnWed.backgroundColor = btnMon.backgroundColor;
        btnWed.dayName = @"Wed";
        btnWed.dayWorkout = scheduleArray[2];
        btnWed.dietPlan = scheduleArray[7];
        [btnWed addTarget:self action:@selector(btnScheduleClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lblWed = [[UILabel alloc] initWithFrame:lblMon.frame];
        lblWed.text = btnWed.dayName;
        lblWed.font = lblMon.font;
        [btnWed addSubview:lblWed];
        
        UILabel *lblWedSchedule = [[UILabel alloc] initWithFrame:lblMonSchedule.frame];
        lblWedSchedule.text = scheduleArray[2];
        lblWedSchedule.textColor = lblMonSchedule.textColor;
        lblWedSchedule.font = lblMonSchedule.font;
        [btnWed addSubview:lblWedSchedule];
        
        btnWedTick = [[CustomButton alloc] initWithFrame:btnMonTick.frame];
        [btnWedTick setBackgroundImage:[UIImage imageNamed:@"grey_tickmark.png"] forState:UIControlStateNormal];
        if (wed > 0) {
            btnWedTick.dayNumber = wed;
            [btnWedTick addTarget:self action:@selector(btnTickClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([self checkDayPresent:wed]) {
                [btnWedTick setBackgroundImage:[UIImage imageNamed:@"green_tickmark.png"] forState:UIControlStateNormal];
            }
            
            [btnWed addSubview:btnWedTick];
        }
        
        [viewSchedule addSubview:btnWed];
        
        // -------------------------------------Add btnThur-------------------------------------
        CustomButton *btnThur = [[CustomButton alloc] initWithFrame:CGRectMake(btnMon.frame.origin.x, btnWed.frame.origin.y + btnMon.frame.size.height + 2, btnMon.frame.size.width, btnMon.frame.size.height)];
        btnThur.backgroundColor = btnMon.backgroundColor;
        btnThur.dayName = @"Thu";
        btnThur.dayWorkout = scheduleArray[3];
        btnThur.dietPlan = scheduleArray[7];
        [btnThur addTarget:self action:@selector(btnScheduleClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lblThur = [[UILabel alloc] initWithFrame:lblMon.frame];
        lblThur.text = btnThur.dayName;
        lblThur.font = lblMon.font;
        [btnThur addSubview:lblThur];
        
        UILabel *lblThurSchedule = [[UILabel alloc] initWithFrame:lblMonSchedule.frame];
        lblThurSchedule.text = scheduleArray[3];
        lblThurSchedule.textColor = lblMonSchedule.textColor;
        lblThurSchedule.font = lblMonSchedule.font;
        [btnThur addSubview:lblThurSchedule];
        
        btnThurTick = [[CustomButton alloc] initWithFrame:btnMonTick.frame];
        [btnThurTick setBackgroundImage:[UIImage imageNamed:@"grey_tickmark.png"] forState:UIControlStateNormal];
        if (thur > 0) {
            btnThurTick.dayNumber = thur;
            [btnThurTick addTarget:self action:@selector(btnTickClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([self checkDayPresent:thur]) {
                [btnThurTick setBackgroundImage:[UIImage imageNamed:@"green_tickmark.png"] forState:UIControlStateNormal];
            }
            
            [btnThur addSubview:btnThurTick];
        }
        
        [viewSchedule addSubview:btnThur];
        
        // -------------------------------------Add btnFri-------------------------------------
        CustomButton *btnFri = [[CustomButton alloc] initWithFrame:CGRectMake(btnMon.frame.origin.x, btnThur.frame.origin.y + btnMon.frame.size.height + 2, btnMon.frame.size.width, btnMon.frame.size.height)];
        btnFri.backgroundColor = btnMon.backgroundColor;
        btnFri.dayName = @"Fri";
        btnFri.dayWorkout = scheduleArray[4];
        btnFri.dietPlan = scheduleArray[7];
        [btnFri addTarget:self action:@selector(btnScheduleClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lblFri = [[UILabel alloc] initWithFrame:lblMon.frame];
        lblFri.text = btnFri.dayName;
        lblFri.font = lblMon.font;
        [btnFri addSubview:lblFri];
        
        UILabel *lblFriSchedule = [[UILabel alloc] initWithFrame:lblMonSchedule.frame];
        lblFriSchedule.text = scheduleArray[4];
        lblFriSchedule.textColor = lblMonSchedule.textColor;
        lblFriSchedule.font = lblMonSchedule.font;
        [btnFri addSubview:lblFriSchedule];
        
        btnFriTick = [[CustomButton alloc] initWithFrame:btnMonTick.frame];
        [btnFriTick setBackgroundImage:[UIImage imageNamed:@"grey_tickmark.png"] forState:UIControlStateNormal];
        if (fri > 0) {
            btnFriTick.dayNumber = fri;
            [btnFriTick addTarget:self action:@selector(btnTickClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([self checkDayPresent:fri]) {
                [btnFriTick setBackgroundImage:[UIImage imageNamed:@"green_tickmark.png"] forState:UIControlStateNormal];
            }
            
            [btnFri addSubview:btnFriTick];
        }
        
        [viewSchedule addSubview:btnFri];
        
        // -------------------------------------Add btnSat-------------------------------------
        CustomButton *btnSat = [[CustomButton alloc] initWithFrame:CGRectMake(btnMon.frame.origin.x, btnFri.frame.origin.y + btnMon.frame.size.height + 2, btnMon.frame.size.width, btnMon.frame.size.height)];
        btnSat.backgroundColor = btnMon.backgroundColor;
        btnSat.dayName = @"Sat";
        btnSat.dayWorkout = scheduleArray[5];
        btnSat.dietPlan = scheduleArray[7];
        [btnSat addTarget:self action:@selector(btnScheduleClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lblSat = [[UILabel alloc] initWithFrame:lblMon.frame];
        lblSat.text = btnSat.dayName;
        lblSat.font = lblMon.font;
        [btnSat addSubview:lblSat];
        
        UILabel *lblSatSchedule = [[UILabel alloc] initWithFrame:lblMonSchedule.frame];
        lblSatSchedule.text = scheduleArray[5];
        lblSatSchedule.textColor = lblMonSchedule.textColor;
        lblSatSchedule.font = lblMonSchedule.font;
        [btnSat addSubview:lblSatSchedule];
        
        btnSatTick = [[CustomButton alloc] initWithFrame:btnMonTick.frame];
        [btnSatTick setBackgroundImage:[UIImage imageNamed:@"grey_tickmark.png"] forState:UIControlStateNormal];
        if (sat > 0) {
            btnSatTick.dayNumber = sat;
            [btnSatTick addTarget:self action:@selector(btnTickClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([self checkDayPresent:sat]) {
                [btnSatTick setBackgroundImage:[UIImage imageNamed:@"green_tickmark.png"] forState:UIControlStateNormal];
            }
            
            [btnSat addSubview:btnSatTick];
        }
        
        [viewSchedule addSubview:btnSat];
        
        // -------------------------------------Add btnSun-------------------------------------
        CustomButton *btnSun = [[CustomButton alloc] initWithFrame:CGRectMake(btnMon.frame.origin.x, btnSat.frame.origin.y + btnMon.frame.size.height + 2, btnMon.frame.size.width, btnMon.frame.size.height)];
        btnSun.backgroundColor = btnMon.backgroundColor;
        btnSun.dayName = @"Sun";
        btnSun.dayWorkout = scheduleArray[6];
        btnSun.dietPlan = scheduleArray[7];
        [btnSun addTarget:self action:@selector(btnScheduleClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lblSun = [[UILabel alloc] initWithFrame:lblMon.frame];
        lblSun.text = btnSun.dayName;
        lblSun.font = lblMon.font;
        [btnSun addSubview:lblSun];
        
        UILabel *lblSunSchedule = [[UILabel alloc] initWithFrame:lblMonSchedule.frame];
        lblSunSchedule.text = scheduleArray[6];
        lblSunSchedule.textColor = lblMonSchedule.textColor;
        lblSunSchedule.font = lblMonSchedule.font;
        [btnSun addSubview:lblSunSchedule];
        
        btnSunTick = [[CustomButton alloc] initWithFrame:btnMonTick.frame];
        [btnSunTick setBackgroundImage:[UIImage imageNamed:@"grey_tickmark.png"] forState:UIControlStateNormal];
        if (sun > 0) {
            btnSunTick.dayNumber = sun;
            [btnSunTick addTarget:self action:@selector(btnTickClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([self checkDayPresent:sun]) {
                [btnSunTick setBackgroundImage:[UIImage imageNamed:@"green_tickmark.png"] forState:UIControlStateNormal];
            }
            
            [btnSun addSubview:btnSunTick];
        }
        
        [viewSchedule addSubview:btnSun];
        
        [viewSchedule addSubview:lblSchedule];
        [self.trainerScrollView addSubview:viewSchedule];
        
        // set the top value here
        top = top + 380;
        //-------------------------- Add Weekly Schedule End -------------------
        
        //-------------------------- Add Guidelines Start ----------------------
        
        UITapGestureRecognizer *tapGuide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGuide:)];
        
        viewGuidelines = [[UIView alloc] initWithFrame:CGRectMake(0, top + 10, 300, 54)];
        viewGuidelines.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        [viewGuidelines addGestureRecognizer:tapGuide];
        
        UIImageView *guideImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
        guideImage.image = [UIImage imageNamed:@"ic_guidelines.png"];
        
        UILabel *lblGuide = [[UILabel alloc] initWithFrame:CGRectMake(55, 15, 250, 25)];
        lblGuide.text = @"Guidelines";
        lblGuide.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        
        UIImageView *arrowGuide = [[UIImageView alloc] initWithFrame:CGRectMake(280, 20, 7, 15)];
        arrowGuide.image = [UIImage imageNamed:@"arrow.png"];
        
        [viewGuidelines addSubview:guideImage];
        [viewGuidelines addSubview:lblGuide];
        [viewGuidelines addSubview:arrowGuide];
        [self.trainerScrollView addSubview:viewGuidelines];
        
        // set the top value here
        top = top + 64;
        //-------------------------- Add Guidelines End ------------------------
        
        //-------------------------- Add Do's And Dont's Start -----------------
        [database open];
        int trainerMedicalCount = 0;
        FMResultSet *results = [database executeQuery:@"SELECT count(selected) as selected FROM medicalCondition WHERE selected='true' AND wtm = 'yes'"];
        while([results next]) {
            trainerMedicalCount = [[results stringForColumn:@"selected"] intValue];
        }
        [database close];
        
        UITapGestureRecognizer *tapDAD = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDAD:)];
        
        viewDAD = [[UIView alloc] initWithFrame:CGRectMake(0, top + 10, 300, 54)];
        viewDAD.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        [viewDAD addGestureRecognizer:tapDAD];
        
        UIImageView *dadImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
        dadImage.image = [UIImage imageNamed:@"ic_dos_and_donts.png"];
        
        UILabel *lblDAD = [[UILabel alloc] initWithFrame:CGRectMake(55, 15, 250, 25)];
        lblDAD.text = @"Do's and Dont's";
        lblDAD.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        
        UIImageView *arrowDAD = [[UIImageView alloc] initWithFrame:CGRectMake(280, 20, 7, 15)];
        arrowDAD.image = [UIImage imageNamed:@"arrow.png"];
        
        [viewDAD addSubview:dadImage];
        [viewDAD addSubview:lblDAD];
        [viewDAD addSubview:arrowDAD];
        
        if (trainerMedicalCount != 0) {
            [self.trainerScrollView addSubview:viewDAD];
        }
        //-------------------------- Add Do's And Dont's End -------------------
        
        float sizeOfContent = 0;
        UIView *lLast = [self.trainerScrollView.subviews lastObject];
        NSInteger wd = lLast.frame.origin.y;
        NSInteger ht = lLast.frame.size.height;
        
        sizeOfContent = wd+ht;
        
        self.trainerScrollView.contentSize = CGSizeMake(self.trainerScrollView.frame.size.width, sizeOfContent);
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

#pragma mark - Tap Recogniser

- (void)tapDAD:(UITapGestureRecognizer *)recognizer {
    // open do's and don't
    DosAndDontsViewController *viewController = (DosAndDontsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"dosAndDontsViewController"];
    viewController.screenType = @"trainer";
    viewController.modalPresentationStyle = UIModalPresentationPageSheet;
    viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)tapGuide:(UITapGestureRecognizer *)recognizer {
    // open Guidelines
    GuidelinesViewController *viewController = (GuidelinesViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"guidelinesViewController"];
    viewController.screenType = @"trainer";
    viewController.modalPresentationStyle = UIModalPresentationPageSheet;
    viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)btnScheduleClicked:(id)sender {
    CustomButton *btn = (CustomButton *)sender;
    
    if ([btn.dayWorkout isEqualToString:@"Rest"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Kudos! You've earned your rest for today" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        ExcerciseListViewController *viewController = (ExcerciseListViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"excerciselistViewController"];
        
        viewController.dietPlan = btn.dietPlan;
        viewController.excerciseName = btn.dayWorkout;
        viewController.pageTitle = btn.dayName;
        
        viewController.modalPresentationStyle = UIModalPresentationPageSheet;
        viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

-(void)btnTickClicked:(id)sender {
    CustomButton *btn = (CustomButton *)sender;

    NSLog(@"%d", yesterdaysDay);
    NSLog(@"new %d", sun);
    if (btn == btnMonTick) {
        if ([yesterdayName isEqualToString:@"Mon"]) {
            [self btnShrink:btnMonTick withDay:btnMonTick.dayNumber withYesterday:YES];
        } else {
            [self btnShrink:btnMonTick withDay:btnMonTick.dayNumber withYesterday:NO];
        }
    } else if (btn == btnTueTick) {
        if ([yesterdayName isEqualToString:@"Tue"]) {
            [self btnShrink:btnTueTick withDay:btnTueTick.dayNumber withYesterday:YES];
        } else {
            [self btnShrink:btnTueTick withDay:btnTueTick.dayNumber withYesterday:NO];
        }
    } else if (btn == btnWedTick) {
        if ([yesterdayName isEqualToString:@"Wed"]) {
            [self btnShrink:btnWedTick withDay:btnWedTick.dayNumber withYesterday:YES];
        } else {
            [self btnShrink:btnWedTick withDay:btnWedTick.dayNumber withYesterday:NO];
        }
    } else if (btn == btnThurTick) {
        if ([yesterdayName isEqualToString:@"Thu"]) {
            [self btnShrink:btnThurTick withDay:btnThurTick.dayNumber withYesterday:YES];
        } else {
            [self btnShrink:btnThurTick withDay:btnThurTick.dayNumber withYesterday:NO];
        }
    } else if (btn == btnFriTick) {
        if ([yesterdayName isEqualToString:@"Fri"]) {
            [self btnShrink:btnFriTick withDay:btnFriTick.dayNumber withYesterday:YES];
        } else {
            [self btnShrink:btnFriTick withDay:btnFriTick.dayNumber withYesterday:NO];
        }
    } else if (btn == btnSatTick) {
        if ([yesterdayName isEqualToString:@"Sat"]) {
            [self btnShrink:btnSatTick withDay:btnSatTick.dayNumber withYesterday:YES];
        } else {
            [self btnShrink:btnSatTick withDay:btnSatTick.dayNumber withYesterday:NO];
        }
    } else if (btn == btnSunTick) {
        /*if ([yesterdayName isEqualToString:@"Sun"]) {
            [self btnShrink:btnSunTick withDay:btnSunTick.dayNumber withYesterday:YES];
        } else {*/
            [self btnShrink:btnSunTick withDay:btnSunTick.dayNumber withYesterday:NO];
        //}
    }
}

#pragma mark - Animation Functions

-(void)btnShrink:(CustomButton *)button withDay:(int)day withYesterday:(BOOL)yest {
    CGRect newFrameOfMyView = button.frame;
    newFrameOfMyView.size.width = 1;
    newFrameOfMyView.size.height = 1;
    
    CGPoint ce = button.center;
    CGPoint yesterdayCe = btnYesterdayTick.center;
    
    [UIView animateWithDuration:1.f
                          delay:0.0f
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         button.frame = newFrameOfMyView;
                         button.center = ce;
                         if (yest) {
                             btnYesterdayTick.frame = newFrameOfMyView;
                             btnYesterdayTick.center = yesterdayCe;
                         }
                     }
                     completion:^(BOOL finished) {
                         // update/insert into database
                         
                         if ([self dayPresent:day]) {
                             // update query
                             UIImage *tmpImage = [UIImage imageNamed:@"green_tickmark.png"];
                             
                             if (button.currentBackgroundImage == tmpImage) {
                                 //update false query
                                 [database open];
                                 [database executeUpdate:@"UPDATE dailyTicks SET tick = ? WHERE day = ?", @"false", [NSString stringWithFormat:@"%d",day]];
                                 [button setBackgroundImage:[UIImage imageNamed:@"grey_tickmark.png"] forState:UIControlStateNormal];
                                 
                                 if (yest) {
                                     [btnYesterdayTick setBackgroundImage:[UIImage imageNamed:@"grey_tickmark.png"] forState:UIControlStateNormal];
                                 }
                                 
                                 [database close];
                             } else {
                                 //update true query
                                 [database open];
                                 [database executeUpdate:@"UPDATE dailyTicks SET tick = ? WHERE day = ?", @"true", [NSString stringWithFormat:@"%d",day]];
                                 [button setBackgroundImage:[UIImage imageNamed:@"green_tickmark.png"] forState:UIControlStateNormal];
                                 
                                 if (yest) {
                                     [btnYesterdayTick setBackgroundImage:[UIImage imageNamed:@"green_tickmark.png"] forState:UIControlStateNormal];
                                 }
                                 
                                 [database close];
                             }
                             
                         } else {
                             // insert query
                             [database open];
                             [database executeUpdate:@"INSERT INTO dailyTicks (day, tick) VALUES (?, ?)", [NSString stringWithFormat:@"%d",day], @"true", nil];
                             [button setBackgroundImage:[UIImage imageNamed:@"green_tickmark.png"] forState:UIControlStateNormal];
                             
                             if (yest) {
                                 [btnYesterdayTick setBackgroundImage:[UIImage imageNamed:@"green_tickmark.png"] forState:UIControlStateNormal];
                             }
                             
                             [database close];
                         }
                         
                         [self btnGrow:button withYesterday:yest];
                     }];
}

-(void)btnGrow:(CustomButton *)button  withYesterday:(BOOL)yest {
    CGRect newFrameOfMyView = button.frame;
    newFrameOfMyView.size.width = 20;
    newFrameOfMyView.size.height = 20;
    
    CGPoint ce = button.center;
    CGPoint yesterdayCe = btnYesterdayTick.center;
    
    [UIView animateWithDuration:1.f
                          delay:0.0f
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         button.frame = newFrameOfMyView;
                         button.center = ce;
                         
                         if (yest) {
                             btnYesterdayTick.frame = newFrameOfMyView;
                             btnYesterdayTick.center = yesterdayCe;
                         }
                     }
                     completion:^(BOOL finished) {
                         if (logYesterdayWeight.alpha == 1 && yest) {
                             [self hideLogYesterdayView];
                         } else if (logYesterdayWeight.alpha == 0 && yest) {
                             [self showLogYesterdayView];
                         }
                     }];
}

-(void)btnYesterdayTickClicked:(id)sender {
    if ([yesterdayName isEqualToString:@"Mon"]) {
        [self btnShrink:btnMonTick withDay:btnMonTick.dayNumber withYesterday:YES];
    } else if ([yesterdayName isEqualToString:@"Tue"]) {
        [self btnShrink:btnTueTick withDay:btnTueTick.dayNumber withYesterday:YES];
    } else if ([yesterdayName isEqualToString:@"Wed"]) {
        [self btnShrink:btnWedTick withDay:btnWedTick.dayNumber withYesterday:YES];
    } else if ([yesterdayName isEqualToString:@"Thu"]) {
        [self btnShrink:btnThurTick withDay:btnThurTick.dayNumber withYesterday:YES];
    } else if ([yesterdayName isEqualToString:@"Fri"]) {
        [self btnShrink:btnFriTick withDay:btnFriTick.dayNumber withYesterday:YES];
    } else if ([yesterdayName isEqualToString:@"Sat"]) {
        [self btnShrink:btnSatTick withDay:btnSatTick.dayNumber withYesterday:YES];
    } else if ([yesterdayName isEqualToString:@"Sun"]) {
        [self btnShrink:nil withDay:(btnSunTick.dayNumber - 7) withYesterday:YES];
    }
}

-(void)hideLogYesterdayView {
    CGRect newFrameSchedule = viewSchedule.frame;
    CGRect newFrameGuide = viewGuidelines.frame;
    CGRect newFrameDAD = viewDAD.frame;
    
    newFrameSchedule.origin.y -= 64;
    newFrameGuide.origin.y -= 64;
    newFrameDAD.origin.y -= 64;
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         logYesterdayWeight.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5f
                                               delay:0.0f
                                             options: UIViewAnimationOptionTransitionCrossDissolve
                                          animations:^{
                                              viewSchedule.frame = newFrameSchedule;
                                              viewGuidelines.frame = newFrameGuide;
                                              viewDAD.frame = newFrameDAD;
                                          }
                                          completion:^(BOOL finished){
                                              float sizeOfContent = 0;
                                              UIView *lLast = [self.trainerScrollView.subviews lastObject];
                                              NSInteger wd = lLast.frame.origin.y;
                                              NSInteger ht = lLast.frame.size.height;
                                              
                                              sizeOfContent = wd+ht;
                                              
                                              self.trainerScrollView.contentSize = CGSizeMake(self.trainerScrollView.frame.size.width, sizeOfContent);
                                          }];
                     }];
}

-(void)showLogYesterdayView {
    CGRect newFrameSchedule = viewSchedule.frame;
    CGRect newFrameGuide = viewGuidelines.frame;
    CGRect newFrameDAD = viewDAD.frame;
    
    newFrameSchedule.origin.y += 64;
    newFrameGuide.origin.y += 64;
    newFrameDAD.origin.y += 64;
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options: UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         viewSchedule.frame = newFrameSchedule;
                         viewGuidelines.frame = newFrameGuide;
                         viewDAD.frame = newFrameDAD;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5f
                                               delay:0.0f
                                             options: UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              logYesterdayWeight.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished){
                                                float sizeOfContent = 0;
                                                UIView *lLast = [self.trainerScrollView.subviews lastObject];

                                                NSInteger wd = lLast.frame.origin.y;
                                                NSInteger ht = lLast.frame.size.height;

                                                sizeOfContent = wd+ht;

                                                self.trainerScrollView.contentSize = CGSizeMake(self.trainerScrollView.frame.size.width, sizeOfContent);
                                          }];
                     }];
}

#pragma mark - General Functions

-(BOOL)dayPresent:(int)day {
    
    BOOL tmpResult = '\0';
    
    [database open];
    
    FMResultSet *results = [database executeQuery:[NSString stringWithFormat:@"SELECT count(day) as day FROM dailyTicks WHERE day = '%d'", day]];
    
    while([results next]) {
        if([results intForColumn:@"day"] >= 1) {
            tmpResult = YES;
        } else {
            tmpResult = NO;
        }
    }
    
    [database close];
    
    return tmpResult;
}

-(BOOL)checkDayPresent:(int)day {
    
    BOOL tmpResult = '\0';
    
    [database open];
    
    FMResultSet *results = [database executeQuery:[NSString stringWithFormat:@"SELECT count(day) as day FROM dailyTicks WHERE tick = 'true' AND day = '%d'", day]];

    while([results next]) {
        if([results intForColumn:@"day"] >= 1) {
            tmpResult = YES;
        } else {
            tmpResult = NO;
        }
    }
    
    [database close];
    
    return tmpResult;
}
@end