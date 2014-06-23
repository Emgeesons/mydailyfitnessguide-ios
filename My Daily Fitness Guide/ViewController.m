//
//  ViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 14/05/2014.
//  Copyright (c) 2014. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add UINavigationBar to view
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 63)];
    navbar.barTintColor = [UIColor blackColor];
    navbar.tintColor = [UIColor whiteColor];
    [self.view addSubview:navbar];
    
    // Add Blank UINavigationItem to UINavigationBar
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@""];
    navbar.items = [NSArray arrayWithObject:item];
    
    // Add UIBarButtonItem to UINavigationItem
    UIBarButtonItem *agreeButton = [[UIBarButtonItem alloc] initWithTitle:@"AGREE" style:UIBarButtonItemStylePlain target:self action:@selector(agreeClicked)];
    item.rightBarButtonItem = agreeButton;
    
    // Add Logo to UINavigationItem
    UIView *myView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 50, 30)];
    UIImage *image = [UIImage imageNamed:@"nav_bar_icon.png"];
    
    // Create ImageView for Logo
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:image];
    myImageView.frame = CGRectMake(0, 0, 30, 30);
    [myView setBackgroundColor:[UIColor  clearColor]];
    [myView addSubview:myImageView];
    
    // Set logo to left side of navigation bar
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:myView];
    item.leftBarButtonItem = leftButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)agreeClicked {
    // save agree button click value in NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setValue:@"agreeClicked" forKey:@"agree"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // open registeration page with CATransition
    UIViewController *v = [self.storyboard instantiateViewControllerWithIdentifier:@"register"];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.8;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:v animated:NO completion:nil];
}

@end