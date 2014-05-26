//
//  GuidelinesViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 24/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "GuidelinesViewController.h"

@interface GuidelinesViewController () {
    FMDatabase *database;
    NSString *programType, *weightLoss, *weightGain;
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
    
    //NSLog(@"%@", self.screenType);
    [self loadInitialData];
    
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT type, value FROM fitnessMainData"];
    while([results next]) {
        if ([[results stringForColumn:@"type"] isEqualToString:@"programType"]) {
            programType = [results stringForColumn:@"value"];
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
    }
    [self longPress:_webView];
    //_webView.scrollView.scrollEnabled = NO;
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
}
@end
