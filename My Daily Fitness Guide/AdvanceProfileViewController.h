//
//  AdvanceProfileViewController.h
//  My Daily Fitness Guide
//
//  Created by Yogesh Suthar on 11/06/2014.
//  Copyright (c) 2014 Yogesh Suthar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvanceProfileViewController : UIViewController
- (IBAction)backButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIButton *btnPound;
@property (weak, nonatomic) IBOutlet UIButton *btnKg;
@property (weak, nonatomic) IBOutlet UITextField *txtSMM;
@property (weak, nonatomic) IBOutlet UITextField *txtPBF;

- (IBAction)btnPoundsClicked:(id)sender;
- (IBAction)btnKgdClicked:(id)sender;

- (IBAction)doneButtonPressed:(id)sender;

@end
