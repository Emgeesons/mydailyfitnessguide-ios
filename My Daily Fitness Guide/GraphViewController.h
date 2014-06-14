//
//  GraphViewController.h
//  My Daily Fitness Guide
//
//  Created by Yogesh Suthar on 14/06/2014.
//  Copyright (c) 2014 Yogesh Suthar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"

@interface GraphViewController : UIViewController <BEMSimpleLineGraphDelegate> {
    BEMSimpleLineGraphView *graphWeight, *graphPBF, *graphSMM;
}
- (IBAction)backButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)ChangeSegment:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSMutableArray *ArrayOfValues,*valWeight, *valPBF, *valSMM;
@property (strong, nonatomic) NSMutableArray *monthArray;

@end
