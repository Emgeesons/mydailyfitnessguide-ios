//
//  GraphViewController.m
//  My Daily Fitness Guide
//
//  Created by Yogesh Suthar on 14/06/2014.
//  Copyright (c) 2014 Yogesh Suthar. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController () {
    FMDatabase *database;
    NSMutableArray *arrayWeight, *arraryPBF, *arraySMM, *arrayMonthNumber;
    float multiplier;
}

@end

@implementation GraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navBar setBounds:CGRectMake(0, 0, 320, 81)];
    [self.navBar setBarTintColor:[UIColor blackColor]];
    
    // initialise database
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT value FROM fitnessMainData WHERE type = 'weightType'"];
    NSString *weightType;
    while([results next]) {
        weightType = [results stringForColumn:@"value"];
    }
    
    [database close];
    
    
    if ([weightType isEqualToString:@"kgs"]) {
        // kgs selected
        [self.segmentedControl setSelectedSegmentIndex:0];
        multiplier = 1;
    } else {
        // pounds selected
        [self.segmentedControl setSelectedSegmentIndex:1];
        multiplier = 2.20462;
    }
    
    [self loadGraph];
    
    //self.ArrayOfValues = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadGraph {
    
    // remove all subviews from scrollview
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [database open];
    
    FMResultSet *graphResults = [database executeQuery:@"SELECT monthNumber,weight, pbf, smm FROM monthLog"];
    
    arrayWeight = [[NSMutableArray alloc] init];
    arraryPBF = [[NSMutableArray alloc] init];
    arraySMM = [[NSMutableArray alloc] init];
    arrayMonthNumber = [[NSMutableArray alloc] init];
    
    self.valWeight = [[NSMutableArray alloc] init];
    self.valPBF = [[NSMutableArray alloc] init];
    self.valSMM = [[NSMutableArray alloc] init];
    
    while([graphResults next]) {
        [arrayWeight addObject:[graphResults stringForColumn:@"weight"]];
        [arraryPBF addObject:[graphResults stringForColumn:@"pbf"]];
        [arraySMM addObject:[graphResults stringForColumn:@"smm"]];
        [arrayMonthNumber addObject:[graphResults stringForColumn:@"monthNumber"]];
    }
    [database close];
    
    // For loop for weight
    for (int i = 0; i < arrayMonthNumber.count; i++) {
        if (i == 0) {
            [self.valWeight addObject:[NSString stringWithFormat:@"%f", ([arrayWeight[i] doubleValue] * multiplier)]];
        } else {
            int diff = [arrayMonthNumber[i] intValue] - [arrayMonthNumber[i - 1] intValue];
            if (diff == 1) {
                [self.valWeight addObject:[NSString stringWithFormat:@"%f", ([arrayWeight[i] doubleValue] * multiplier)]];
            } else {
                for (int j = 0; j < diff - 1; j++) {
                    double diffValue = ([arrayWeight[i] doubleValue] + [arrayWeight[i - 1] doubleValue])/diff;
                    [self.valWeight addObject:[NSString stringWithFormat:@"%f", (diffValue * multiplier)]];
                }
                [self.valWeight addObject:[NSString stringWithFormat:@"%f", ([arrayWeight[i] doubleValue] * multiplier)]];
            }
        }
    }
    
    // For loop for PBF
    for (int i = 0; i < arrayMonthNumber.count; i++) {
        if (i == 0) {
            if ([arraryPBF[i] isEqualToString:@""]) {
                [self.valPBF addObject:[NSString stringWithFormat:@"0"]];
            } else {
                [self.valPBF addObject:arraryPBF[i]];
            }
            
        } else {
            int diff = [arrayMonthNumber[i] intValue] - [arrayMonthNumber[i - 1] intValue];
            if (diff == 1) {
                if ([arraryPBF[i] isEqualToString:@""]) {
                    [self.valPBF addObject:[NSString stringWithFormat:@"0"]];
                } else {
                    [self.valPBF addObject:arraryPBF[i]];
                }
            } else {
                for (int j = 0; j < diff - 1; j++) {
                    double diffValue = ([arraryPBF[i] doubleValue] + [arraryPBF[i - 1] doubleValue])/diff;
                    [self.valPBF addObject:[NSString stringWithFormat:@"%f", diffValue]];
                }
                [self.valPBF addObject:arraryPBF[i]];
            }
        }
    }
    
    // For loop for SMM
    for (int i = 0; i < arrayMonthNumber.count; i++) {
        if (i == 0) {
            if ([arraySMM[i] isEqualToString:@""]) {
                [self.valSMM addObject:[NSString stringWithFormat:@"0"]];
            } else {
                [self.valSMM addObject:[NSString stringWithFormat:@"%f", ([arraySMM[i] doubleValue] * multiplier)]];
            }
            
        } else {
            int diff = [arrayMonthNumber[i] intValue] - [arrayMonthNumber[i - 1] intValue];
            if (diff == 1) {
                if ([arraySMM[i] isEqualToString:@""]) {
                    [self.valSMM addObject:[NSString stringWithFormat:@"0"]];
                } else {
                    [self.valSMM addObject:[NSString stringWithFormat:@"%f", ([arraySMM[i] doubleValue] * multiplier)]];
                }
            } else {
                for (int j = 0; j < diff - 1; j++) {
                    double diffValue = ([arraySMM[i] doubleValue] + [arraySMM[i - 1] doubleValue])/diff;
                    [self.valSMM addObject:[NSString stringWithFormat:@"%f", (diffValue * multiplier)]];
                }
                [self.valSMM addObject:[NSString stringWithFormat:@"%f", ([arraySMM[i] doubleValue] * multiplier)]];
            }
        }
    }
    
    self.monthArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 13; i++) {
        [self.monthArray addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:0 + i]]]; // Dates for the X-Axis of the graph
    }
    
    graphWeight = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(10, 0, 300, 150)];
    graphWeight.delegate = self;
    [self.scrollView addSubview:graphWeight];
    
    // Customization of the graph
    graphWeight.delegate = self;
    graphWeight.colorTop = [UIColor colorWithHexString:@"#e8e8e8"];
    graphWeight.colorBottom = [UIColor colorWithHexString:@"#e8e8e8"];
    graphWeight.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    graphWeight.colorLine = [UIColor redColor];
    graphWeight.colorXaxisLabel = [UIColor blackColor];
    graphWeight.widthLine = 3.0;
    graphWeight.enableTouchReport = YES;
    graphWeight.enablePopUpReport = YES;
    graphWeight.enableBezierCurve = YES;
    
    graphPBF = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(10, 200, 300, 150)];
    graphPBF.delegate = self;
    [self.scrollView addSubview:graphPBF];
    
    // Customization of the graph
    graphPBF.delegate = self;
    graphPBF.colorTop = [UIColor colorWithHexString:@"#e8e8e8"];
    graphPBF.colorBottom = [UIColor colorWithHexString:@"#e8e8e8"];
    graphPBF.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    graphPBF.colorLine = [UIColor greenColor];
    graphPBF.colorXaxisLabel = [UIColor blackColor];
    graphPBF.widthLine = 3.0;
    graphPBF.enableTouchReport = YES;
    graphPBF.enablePopUpReport = YES;
    graphPBF.enableBezierCurve = YES;
    
    
    graphSMM = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(10, 400, 300, 150)];
    graphSMM.delegate = self;
    [self.scrollView addSubview:graphSMM];
    
    // Customization of the graph
    graphSMM.delegate = self;
    graphSMM.colorTop = [UIColor colorWithHexString:@"#e8e8e8"];
    graphSMM.colorBottom = [UIColor colorWithHexString:@"#e8e8e8"];
    graphSMM.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    graphSMM.colorLine = [UIColor blueColor];
    graphSMM.colorXaxisLabel = [UIColor blackColor];
    graphSMM.widthLine = 3.0;
    graphSMM.enableTouchReport = YES;
    graphSMM.enablePopUpReport = YES;
    graphSMM.enableBezierCurve = YES;
    
    float sizeOfContent = 0;
    UIView *lLast = [self.scrollView.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    
    sizeOfContent = wd+ht;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, sizeOfContent);
}

- (IBAction)ChangeSegment:(id)sender {
    if(self.segmentedControl.selectedSegmentIndex == 0){
        multiplier = 1;
        [database open];
        [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = 'weightType'", @"kgs"];
        [database close];
    } else if(self.segmentedControl.selectedSegmentIndex == 1){
        multiplier = 2.20462;
        [database open];
        [database executeUpdate:@"UPDATE fitnessMainData SET value = ? WHERE type = 'weightType'", @"pounds"];
        [database close];
    }
    
    [self loadGraph];
}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.monthArray count];
}

- (NSInteger)numberOfvaluesInLineGraph:(BEMSimpleLineGraphView *)graph {
    if (graph == graphWeight) {
        return (int)[self.valWeight count];
    } else if (graph == graphPBF) {
        return (int)[self.valPBF count];
    }else {
        return (int)[self.valSMM count];
    }
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    if (graph == graphWeight) {
        return [[self.valWeight objectAtIndex:index] floatValue];
    } else if (graph == graphPBF) {
        return [[self.valPBF objectAtIndex:index] floatValue];
    } else {
        return [[self.valSMM objectAtIndex:index] floatValue];
    }
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 1;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    return [self.monthArray objectAtIndex:index];
}

@end
