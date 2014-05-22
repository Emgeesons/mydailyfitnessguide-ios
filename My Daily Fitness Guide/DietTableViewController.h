//
//  DietTableViewController.h
//  My Daily Fitness Guide
//
//  Created by yogesh on 20/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DietTableViewController : UITableViewController <UIPickerViewDelegate,UIPickerViewDataSource> {
    UIActionSheet *sheet;
    UIPickerView *pickerView;
}
@property (nonatomic, strong) NSString *dietType;
@end
