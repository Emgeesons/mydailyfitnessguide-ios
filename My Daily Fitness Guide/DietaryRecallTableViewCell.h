//
//  DietaryRecallTableViewCell.h
//  My Daily Fitness Guide
//
//  Created by Yogesh Suthar on 16/06/2014.
//  Copyright (c) 2014 Yogesh Suthar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DietaryRecallTableViewCell : UITableViewCell
@property (nonatomic) NSInteger foodID;
@property (nonatomic, strong) NSString *foodName;
@property (nonatomic) NSInteger servingValue;
@end
