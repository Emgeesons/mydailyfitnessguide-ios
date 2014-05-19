//
//  FirstTabViewController.h
//  My Daily Fitness Guide
//
//  Created by yogesh on 15/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstTabViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewStart;


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
