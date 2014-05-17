//
//  CityTableViewController.h
//  My Daily Fitness Guide
//
//  Created by yogesh on 15/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityTableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    UIPickerView *myPickerView;
    NSMutableArray *numArray;
    UIActionSheet *sheet;
    NSString *selectedNumber;
}

@property (nonatomic, strong) NSString *State;
//@property (strong, nonatomic) IBOutlet UITableViewCell *tableCell;

@end
