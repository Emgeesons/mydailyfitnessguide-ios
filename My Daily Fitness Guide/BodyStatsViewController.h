//
//  BodyStatsViewController.h
//  My Daily Fitness Guide
//
//  Created by yogesh on 02/06/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BodyStatsViewController : UIViewController
- (IBAction)backButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (weak, nonatomic) IBOutlet UIButton *btnPound;
@property (weak, nonatomic) IBOutlet UIButton *btnKgs;
@property (weak, nonatomic) IBOutlet UITextField *txtWeight;
@property (weak, nonatomic) IBOutlet UITextField *txtPBF;
@property (weak, nonatomic) IBOutlet UITextField *txtSMM;

- (IBAction)poundClicked:(id)sender;
- (IBAction)kgsClicked:(id)sender;
@end
