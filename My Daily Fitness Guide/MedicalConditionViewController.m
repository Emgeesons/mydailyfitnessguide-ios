//
//  MedicalConditionViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 19/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "MedicalConditionViewController.h"
#import "BMIViewController.h"

@interface MedicalConditionViewController () {
    NSMutableArray *medicalConditions, *selection;
    FMDatabase *database;
}

@end

@implementation MedicalConditionViewController

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
    
    self.title = @"Medical Conditions";
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextClicked)];
    
    self.navigationItem.rightBarButtonItem = nextButton;
    
    [database open];
    FMResultSet *results = [database executeQuery:@"select * from medicalCondition"];
    
    medicalConditions = [NSMutableArray arrayWithCapacity:1];
    selection = [NSMutableArray arrayWithCapacity:1];
    
    while([results next]) {
        [medicalConditions addObject:[results stringForColumn:@"name"]];
        [selection addObject:[results stringForColumn:@"selected"]];
    }
    [database close];
}

-(void)setTitle:(NSString *)title {
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:titleFont];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor whiteColor]; // Change to desired color
        
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return medicalConditions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = medicalConditions[indexPath.row];
    if ([selection[indexPath.row] isEqualToString:@"true"]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *theCell = [tableView cellForRowAtIndexPath:indexPath];
    
    [database open];
    if (theCell.accessoryType == UITableViewCellAccessoryNone) {
        theCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [database executeUpdate:@"UPDATE medicalCondition SET selected = ? WHERE id = ?", @"true", [NSString stringWithFormat:@"%d",(indexPath.row + 1)]];
        selection[indexPath.row] = @"true";
    } else if (theCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        theCell.accessoryType = UITableViewCellAccessoryNone;
        [database executeUpdate:@"UPDATE medicalCondition SET selected = ? WHERE id = ?", @"false",[NSString stringWithFormat:@"%d",(indexPath.row + 1)]];
        selection[indexPath.row] = @"false";
    }
    [database close];
}

-(void)nextClicked {
    if (([selection[0] isEqualToString:@"true"] && [selection[2] isEqualToString:@"true"] && [selection[3] isEqualToString:@"true"]) || [selection[10] isEqualToString:@"true"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Sorry, please consult your doctor!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        // navigate to another page
        UIViewController *v = [self.storyboard instantiateViewControllerWithIdentifier:@"bmiViewController"];
        [self.navigationController pushViewController:v animated:YES];
    }
}

@end
