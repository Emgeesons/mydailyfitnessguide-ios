//
//  DietResultViewController.h
//  My Daily Fitness Guide
//
//  Created by yogesh on 22/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DietResultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewBack;
@property (weak, nonatomic) IBOutlet UILabel *lblCarbohydrates;
@property (weak, nonatomic) IBOutlet UILabel *lblProtiens;
@property (weak, nonatomic) IBOutlet UILabel *lblFats;
@property (weak, nonatomic) IBOutlet UILabel *lblFibre;

@end
