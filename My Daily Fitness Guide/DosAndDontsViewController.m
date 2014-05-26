//
//  DosAndDontsViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 24/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "DosAndDontsViewController.h"

@interface DosAndDontsViewController () {
    FMDatabase *database;
    NSString *heart, *diabetes, *pregnancy, *thyroid, *cholestrol, * pcos;
    NSMutableString *htmlString;
}

@end

@implementation DosAndDontsViewController

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
    
    //self.webView.delegate = self;
    
    [self.navBar setBounds:CGRectMake(0, 0, 320, 81)];
    [self.navBar setBarTintColor:[UIColor blackColor]];
    
    [self initializeStrings];
    
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    htmlString = [[NSMutableString alloc] init];
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"welcome_bg" ofType:@"png"];
    [htmlString appendFormat:@"<html><head><style>ul {padding-left: 20px; margin-top: 2px; margin-left: 10px;} h5 { margin-bottom: 2px; padding-left: 5px; margin-left:5px;} h4 { margin-top: -6px; margin-bottom: -12px; text-align: center;} div {background: -webkit-linear-gradient(top, #e8e8e8, #ffffff);}</style></head><body>"];
    //NSLog(@"%@", htmlString);
    
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT name FROM medicalCondition WHERE selected = 'true' AND dietMod = 'yes'"];
    while([results next]) {
        if ([[results stringForColumn:@"name"] isEqualToString:@"Heart / Hypertension / High BP"]) {
            [htmlString appendString:heart];
        } else if ([[results stringForColumn:@"name"] isEqualToString:@"Diabetes"]) {
            [htmlString appendString:diabetes];
        } else if ([[results stringForColumn:@"name"] isEqualToString:@"Pregnancy"]) {
            [htmlString appendString:pregnancy];
        } else if ([[results stringForColumn:@"name"] isEqualToString:@"Thyroid (hypo thyroid)"]) {
            [htmlString appendString:thyroid];
        } else if ([[results stringForColumn:@"name"] isEqualToString:@"Cholesterol"]) {
            [htmlString appendString:cholestrol];
        } else if ([[results stringForColumn:@"name"] isEqualToString:@"PCOS"]) {
            [htmlString appendString:pcos];
        }
    }
    [database close];
    
    [htmlString appendString:@"</body></html>"];
    
    [_webView loadHTMLString:htmlString baseURL:nil];
    [self longPress:self.webView];
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

-(void)initializeStrings {
    heart = @"<div id='Heart'><br/><h4>Blood Pressure - Hypertension</h4><h5>Do's</h5><ul><li>Have lot of vegetables and fruits.</li><li>Use low fat dairy products.</li><li>Consume whole grains and lean meat, fish and poultry.</li><li>Limit fast foods, canned foods or foods that are bought prepared.</li></ul><h5>Don'ts</h5><ul><li>Avoid Saturated fats and Trans Fats.</li><li>Restrict the intake of table salt.</li><li>Avoid Alcohol and Smoking.</li></ul></div><div id='Heart'><br/><h4>Blood Pressure - Hypotension</h4><h5>Do's</h5><ul><li>Include more salt in your diet.</li><li>Eating smaller meals, more often.</li></ul><h5>Don'ts</h5><ul><li>Avoid caffeine at night.</li><li>Limit alcohol intake.</li></ul></div>";
    
    diabetes = @"<div id='Diabetes'><br/><h4>Diabetes </h4><h5>Do's</h5><p>Include the following in your diet regularly</p><ul><li>Fenugreek (methi)- 1-2tspn/day</li><li>Indian blackberry (jamun)- 8-10/day</li><li>Garlic- 2-3 cloves/day</li><li>Flaxseed- 1-2tspn/day </li><li>Fibre- 25-30gms/day </li></ul><h5>Don'ts</h5><p>Use the following foods in moderation</p><ul><li>Salt </li><li>Sugar </li><li>Fat </li><li>Whole milk and products </li><li>Tea and coffee</li><li>White flour and its products</li><li>Foods with a high glycemic index.</li></ul></div>";
    
    pregnancy = @"<div id='Pregnancy'><br/><h4>Pregnancy</h4><h5>Do's</h5><ul><li>Eat plenty of calcium (milk, cheese, yoghurt).</li><li>Include protein (lean meat, chicken and fish, eggs and pulses) in your diet.</li><li>Eat iron rich foods(fortified cereals, red meat, pulses, bread, green veg).</li></ul><h5>Don'ts</h5><ul><li>Avoid caffeine intake.</li><li>Do not consume liver or liver products.</li><li>Avoid raw shellfish.</li></ul></div>";
    
    thyroid = @"<div id='Thyroid (HyproThyroid)'><br/><h4>Thyroid (HyproThyroid)</h4><h5>Do's</h5><ul><li>Eat Foods high in Vitamin B and Iron such as fresh vegetables and whole grains.</li><li>Eat more of Almonds, Sesame Seeds, and Oats.</li><li>Eat foods high in antioxidants, including fruits such as blueberries, cherries, and tomatoes.</li><li>Include omega 3 sources like fish, walnuts, etc.</li></ul><h5>Don'ts</h5><ul><li>Avoid High levels of Caffeine.</li><li>Avoid goitrogens like broccoli, cabbage, brussels sprouts, cauliflower, kale, spinach, turnips, soybeans, peanuts, linseed, pine nuts, millets.</li></ul></div>";
    
    cholestrol = @"<div id='Cholestrol'><br/><h4>Cholestrol</h4><h5>Do's</h5><ul><li>Consume vegetables, soy products, protein rich foods, and a high fiber diet.</li><li>Include lot of walnuts, flaxseeds, fish, oats, whole wheat bran and whole grain in your diet.</li><li>Drink at least 8-10 glasses of water each day.</li></ul><h5>Don'ts</h5><ul><li>Avoid red meats, organ meats and all those junk foods that contain a high amount of toxic trans-fats and saturated fats.</li><li>Avoid refined and processed foods.</li><li>Avoid high fat dairy products, instead use low fat variety.</li><li>Use salt in moderation.</li></ul></div>";
    
    pcos = @"<div id='PCOS'><br/><h4>PCOS</h4><h5>Do's</h5><ul><li>Increase the intake of Fiber in your diet.</li><li>Include omega 3 rich food like fish, walnuts in your diet.</li></ul><h5>Don'ts</h5><ul><li>Don't Eat High-Sugar Foods.</li></ul></div>";
}

@end