//
//  CityTableViewCell.h
//  My Daily Fitness Guide
//
//  Created by yogesh on 15/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@protocol CityTableViewCellDelegate <NSObject>

-(void)mapPressed:(NSString *)latitude longitude:(NSString *)longitude;
-(void)mailPressed:(NSString *)emailId;
-(void)callPressed:(NSString *)callString;

@end

@interface CityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet CustomButton *btnCall;
@property (weak, nonatomic) IBOutlet CustomButton *btnMail;

//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet CustomButton *map;
- (IBAction)mapClicked:(id)sender;
- (IBAction)mailClicked:(id)sender;
- (IBAction)calClicked:(id)sender;

@property (nonatomic, weak) id <CityTableViewCellDelegate> delegate;
@end
