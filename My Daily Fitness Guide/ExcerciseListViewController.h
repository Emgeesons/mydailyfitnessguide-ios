//
//  ExcerciseListViewController.h
//  My Daily Fitness Guide
//
//  Created by yogesh on 29/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExcerciseListViewController : UIViewController
//@property (weak, nonatomic) IBOutlet UIView *viewBg;

- (IBAction)backButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (nonatomic, strong) NSString *dietPlan, *excerciseName, *pageTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle, *lblSecondTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewDetail;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
