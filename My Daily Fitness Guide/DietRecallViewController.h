//
//  DietRecallViewController.h
//  My Daily Fitness Guide
//
//  Created by yogesh on 20/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DietRecallViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnBreakfast;
@property (weak, nonatomic) IBOutlet UIButton *btnlunch;
@property (weak, nonatomic) IBOutlet UIButton *Snacks;
@property (weak, nonatomic) IBOutlet UIButton *btnDinner;
@property (weak, nonatomic) IBOutlet UIButton *btnBedtime;
- (IBAction)switchClicked:(id)sender;

@end
