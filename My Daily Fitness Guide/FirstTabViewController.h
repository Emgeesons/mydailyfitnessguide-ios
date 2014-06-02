//
//  FirstTabViewController.h
//  My Daily Fitness Guide
//
//  Created by yogesh on 15/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstTabViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewStart;

@property (weak, nonatomic) IBOutlet UIView *viewBegin;
@property (weak, nonatomic) IBOutlet UILabel *lblBegin;
- (IBAction)btnBeginClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewWeeklyDiet;
@property (weak, nonatomic) IBOutlet UITableView *tvWeeklyDiet;

@property (weak, nonatomic) IBOutlet UIView *vwProfile;

@property (weak, nonatomic) IBOutlet UIView *vwTrainerWeeklySchedule;
//@property (weak, nonatomic) IBOutlet UITableView *tvWeeklyScheduleParent;
@property (weak, nonatomic) IBOutlet UIScrollView *trainerScrollView;

@property (weak, nonatomic) IBOutlet UIView *viewBodyStats;

// properties for tab view
@property (weak, nonatomic) IBOutlet UIView *btnTrainer;
@property (weak, nonatomic) IBOutlet UIView *btnNutritionist;
@property (weak, nonatomic) IBOutlet UIView *btnProfile;

@property (weak, nonatomic) IBOutlet UIButton *btnImageTrainer;
@property (weak, nonatomic) IBOutlet UIButton *btnLabelTrainer;

@property (weak, nonatomic) IBOutlet UIButton *btnImageNutritionist;
@property (weak, nonatomic) IBOutlet UIButton *btnLabelNutritionist;

@property (weak, nonatomic) IBOutlet UIButton *btnIamgeProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnLabelProfile;

@end
