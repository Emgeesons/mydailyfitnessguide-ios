//
//  GuidelinesViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 24/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "GuidelinesViewController.h"
#import "WeeklySchedule.h"

@interface GuidelinesViewController () {
    FMDatabase *database;
    NSString *programType, *weightLoss, *weightGain, *vacationDate;
    NSMutableString *htmlString;
    NSString *basic, *intermediate, *advance, *functional, *vacation;
}

@end

@implementation GuidelinesViewController

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
    htmlString = [[NSMutableString alloc] init];
    
    [self loadInitialData];
    
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT type, value FROM fitnessMainData"];
    while([results next]) {
        if ([[results stringForColumn:@"type"] isEqualToString:@"programType"]) {
            programType = [results stringForColumn:@"value"];
        } else if ([[results stringForColumn:@"type"] isEqualToString:@"vacationDate"]) {
            vacationDate = [results stringForColumn:@"value"];
        }
    }
    [database close];
    
    [self.navBar setBounds:CGRectMake(0, 0, 320, 81)];
    [self.navBar setBarTintColor:[UIColor blackColor]];
    
    if ([self.screenType isEqualToString:@"nutritionist"]) {
        if ([programType isEqualToString:@"weightGain"]) {
            // load weightGain guidelines
            [_webView loadHTMLString:weightGain baseURL:nil];
        } else {
            // load weightLoss guidelines
            [_webView loadHTMLString:weightLoss baseURL:nil];
        }
    } else {
        // for trainer part
        [htmlString appendFormat:@"<html><head><style>ul {padding-left: 20px; margin-left: 10px;} h4 { text-align: center;} div {background: -webkit-linear-gradient(top, #e8e8e8, #ffffff);}</style></head><body>"];
        
        if ([vacationDate isEqualToString:@""] || vacationDate == NULL) {
            WeeklySchedule *week = [[WeeklySchedule alloc] initialize];
            NSString *dietPlan = [week getProgramLevel:[week getMonth] dietType:[week getDietType]];
            
            if ([dietPlan isEqualToString:@"Basic 1"] || [dietPlan isEqualToString:@"Basic 2"] || [dietPlan isEqualToString:@"Basic 2 (No Cardio)"]) {
                [htmlString appendString:basic];
            } else if ([dietPlan isEqualToString:@"Intermediate 1"] || [dietPlan isEqualToString:@"Intermediate 2 (No Cardio)"]) {
                [htmlString appendString:intermediate];
            } else if ([dietPlan isEqualToString:@"Advance 1"] || [dietPlan isEqualToString:@"Advance 2"] || [dietPlan isEqualToString:@"Advance 1 (No Cardio)"]) {
                [htmlString appendString:advance];
            } else if ([dietPlan isEqualToString:@"Functional Training 1"] || [dietPlan isEqualToString:@"Functional Training 2"]) {
                [htmlString appendString:functional];
            }
        } else {
            [htmlString appendString:vacation];
        }
        
        [htmlString appendString:@"</body></html>"];
        [_webView loadHTMLString:htmlString baseURL:nil];
    }
    [self longPress:_webView];
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadInitialData {
    weightGain = @"<html><head><style>ul {padding-left: 10px; margin-left: 10px;} h4 { text-align: center;} div {background: -webkit-linear-gradient(top, #e8e8e8, #ffffff);}</style></head><body style='background: -webkit-linear-gradient(top, #e8e8e8, #ffffff);'><h4>Guidelines</h4><ul><li>Eat energy dense foods \n\n</li><li>Eat more protein rich foods like milk and milk products, pulses, nuts and oilseeds, fish, chicken \n\n</li><li>Eat foods at regular interval \n\n</li><li>Eat more sweet fruits like banana, chickoo, custard apple,  grapes and mango \n\n</li><li>Eat more starchy vegetables like potato, sweet potato \n\n</li><li>Do not starve yourself \n\n</li><li>Drink plenty of water \n\n</li><li>Eat plenty of cereals like bread, pasta, noodles, rice, rotis etc. \n\n</li></ul></body></html>";
    
    weightLoss = @"<html><head><style>ul {padding-left: 10px; margin-left: 10px;} h4 { text-align: center;} div {background: -webkit-linear-gradient(top, #e8e8e8, #ffffff);}</style></head><body style='background: -webkit-linear-gradient(top, #e8e8e8, #ffffff);'><h4>Guidelines</h4><ul><li>Ensure that you eat your meals on time \n\n</li><li>Take a hearty breakfast \n\n</li><li>Eating breakfast reduces your hunger later in the day, making it easier to avoid overeating. In addition, prolonged fasting which occurs when you skip breakfast can increase your body\'s insulin response, which in turn increases fat storage and weight gain. \n\n</li><li>Do not replace your main meals with fruits \n\n</li><li>Increase your daily intake of water, especially in between meals.  \n\n</li><li>Eat slowly in a comfortable, relaxed environment. \n\n</li><li>Go high on Vegetables \n\n</li><li>Do not skip your meals. Do not keep a gap of more than three hours in between meals \n\n</li><li>Start your meal with salad and then move on to your main meals.  \n\n</li><li>Avoid the products made from sugar, jaggery and honey. \n\n</li><li>Restrict products made from maida like bread, khari, toast, butter, biscuits, etc \n\n</li><li>Use cow\'s milk/ skimmed milk instead of buffalo\'s milk. \n\n</li><li>Have plenty of vegetables, green leafy vegetables, sprouts, salads etc in your day to day meals.\n\n</li><li>Restrict Papads, pickles, ketchups, canned foods etc\n\n</li><li>Opt for low fat curd or vinegar or salsa dressing instead of mayo or cheese dressing.\n\n</li><li>Fruits allowed (Apple/ Sweet lime / Oranges / pear / straw berries/ papaya / guava / kiwi/ Grape fruit etc) \n\n</li><li>Avoid pulpy fruits like banaa, chickoo, mango and custard apple. instead have more of juicy fruits like orange \n\n</li><li>Go for unsweetened beverages like Green Tea / Ice Tea / Diet Soda instead of milkshakes, ice-creams or soft drinks \n\n</li><li>Restrict the intake of fresh coconut, dry coconut and groundnuts.\n\n</li><li>Avoid butter, cheese, jam, jellies, pastries, sweets, ice-cream and alcohol. \n\n</li><li>Opt for grilled or roasted items instead of fried foods, especially when eating outside. \n\n</li></ul></body></html>";
    
    basic = @"<div><h4>Guidelines</h4><ul><li>You should start slowly with a basic cardio program and a full body resistance training routine.</li><li>You'll want to have recovery days to allow your body to rest and your muscles to heal from your new routine.</li><li>A typical beginner program will include about 3 days of cardio and 2 days of strength training.</li><ul></div>";
    
    intermediate = @"<div><h4>Guidelines</h4><ul><li>If you're more advanced, you can split your routine further, focusing more attention on each muscle group.</li><li>You can also increase the intensity of your cardio, incorporating interval training and other advanced techniques to burn calories and build endurance.</li></ul></div>";
    
    advance = @"<div><h4>Guidelines</h4><ul><li>If you're more advanced, you can split your routine further, focusing more attention on each muscle group.</li><li>You can also increase the intensity of your exercises, incorporating interval training and other advanced techniques to burn calories and build endurance.</li></ul></div>";
    
    functional = @"<div><h4>Guidelines</h4><ul><li>Anyone who wants to workout provided you have a basic strength to carry out all these exercises successfully.</li><li>Intensity and volume will change according to your strength.</li><li>Always make sure that you don’t overdo in the beginning, progress slowly.</li><li>It involves your own body resistance which is most of the time very much difficult than carrying your external weights.</li><li>You remain active by doing all these exercises which can give you all the benefits that you are going to achieve with weight training exercises that you are see on the gym floor.</li></ul></div>";
    
    vacation = @"<div><h4>Guidelines</h4><ul><li>Always make your body warm (warm-up) before exercise.</li><li>Follow the target heart rate during exercise.</li><li>Calculation of Target Heart Rate (THR) - THR = 60% of Maximum Heart Rate = 0.6 x (220 - age). \n\nOnce the patient feels comfortable with this level of exercise, gradually the intensity may be increased by 5 percent after consultation with a doctor. But the upper limit should not exceed more than 80 percent of the maximum heart rate.</li><li>Always cool down after the exercise program.</li><li>Keep an exercise diary and record your resting and exercise heart rates.</li><li>Do not exercise within two hours after a meal.</li><li>Don't drink alcohol two hours before an exercising program.</li><li>Don't smoke before an exercising program.</li><li>For any abnormal symptoms, such as irregular heartbeats, excessive shortness of breath or lightheadedness stop and rest. If the symptoms do not subside in a few minutes immediately consult a heart specialist.</li></ul></div>";
}
@end
