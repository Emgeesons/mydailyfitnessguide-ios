//
//  CourseCorrectionViewController.h
//  My Daily Fitness Guide
//
//  Created by Yogesh Suthar on 02/06/2014.
//  Copyright (c) 2014 Yogesh Suthar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCorrectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
- (IBAction)backButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@end
