//
//  BMIViewController.h
//  My Daily Fitness Guide
//
//  Created by yogesh on 19/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMIViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource> {
    UIActionSheet *sheet;
    UIPickerView *pickerView;
}
@property (weak, nonatomic) IBOutlet UILabel *lblResult;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


@property (weak, nonatomic) IBOutlet UITextField *txtHeight;
@property (weak, nonatomic) IBOutlet UITextField *txtWeight;
@property (weak, nonatomic) IBOutlet UIButton *btnPound;
@property (weak, nonatomic) IBOutlet UIButton *btnKgs;

- (IBAction)poundClicked:(id)sender;
- (IBAction)kgsClicked:(id)sender;

@end
