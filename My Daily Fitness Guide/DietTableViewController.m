//
//  DietTableViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 20/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "DietTableViewController.h"
#import "MVCustomAlertView.h"
#import "MVPickerAlertView.h"

#import "DietaryRecallTableViewCell.h"

@interface DietTableViewController () {
    FMDatabase *database;
    NSMutableArray *food, *ids, *calcValue;
    NSMutableDictionary *selectedFood;
    NSArray *hours, *minutes, *dayTime, *servings, *servLabel;
    NSInteger selectedNumber;
    NSIndexPath *selectedIndexPath;
    NSString *number;
}

@end

@implementation DietTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    
    selectedFood = [[NSMutableDictionary alloc] init];
    
    NSDictionary *tmpDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:self.dietType];
    if (tmpDictionary.count > 0) {
        selectedFood = [[[NSUserDefaults standardUserDefaults] objectForKey:self.dietType] mutableCopy];
    }
    
    hours = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"];
    minutes = @[@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10",
                @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20",
                @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30",
                @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"38", @"39", @"40",
                @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49", @"50",
                @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59"];
    dayTime = @[@"AM", @"PM"];
    
    servings = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
    servLabel = @[@"servings"];
    
    self.title = self.dietType;
    [self loadFood];
}

-(void)viewDidAppear:(BOOL)animated {
    MVPickerAlertView *picker = [[MVPickerAlertView alloc] initWithTitle:@"Select Time" values1:hours values2:minutes values3:dayTime delegate:self];
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:selectedFood forKey:self.dietType];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

-(void)loadFood {
    food = [[NSMutableArray alloc] init];
    ids = [[NSMutableArray alloc] init];
    calcValue = [[NSMutableArray alloc] init];
    
    NSString *foodTime, *vegType, *sqlQuery, *type;
    
    if ([self.dietType isEqualToString:@"Lunch"] || [self.dietType isEqualToString:@"Dinner"]) {
        foodTime = @"time = 'main'";
    } else {
        foodTime = [NSString stringWithFormat:@"time = '%@'", self.dietType];
    }
    
    [database open];
    FMResultSet *r = [database executeQuery:@"SELECT value FROM fitnessMainData WHERE type = 'vegNonVeg'"];
    while([r next]) {
        vegType = [r stringForColumn:@"value"];
    }
    [database close];
    //NSLog(@"%@", vegType);
    
    if ([vegType isEqualToString:@"veg"]) {
        type = @" AND type = 'veg'";
    } else {
        type = @"";
    }
    
    // create SELECT query
    sqlQuery = [NSString stringWithFormat:@"SELECT id, calcValue, trim(food) as food FROM dietaryRecall WHERE %@ %@ ORDER BY food ASC", foodTime, type];
    
    [database open];
    FMResultSet *results = [database executeQuery:sqlQuery];
    
    while([results next]) {
        [food addObject:[results stringForColumn:@"food"]];
        [ids addObject:[results stringForColumn:@"id"]];
        [calcValue addObject:[results stringForColumn:@"calcValue"]];
    }
    [database close];
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
    return food.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    DietaryRecallTableViewCell *cell = (DietaryRecallTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //if (cell == nil) {
        cell = [[DietaryRecallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    //}
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = food[indexPath.row];
    NSString *tmpString = [selectedFood objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
    cell.foodID = [ids[indexPath.row] integerValue];
    cell.foodName = food[indexPath.row];
    cell.servingValue = [calcValue[indexPath.row] integerValue];
    
    UIButton *tmpButton = [[UIButton alloc] init];
    
    if (tmpString != NULL) {
        UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake(280, 10, 25, 25)];
        roundView.backgroundColor = tmpButton.tintColor;
        //roundView.backgroundColor = [UIColor grayColor];
        roundView.layer.cornerRadius = 12;
        
        UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        tmpLabel.text = tmpString;
        tmpLabel.textAlignment = NSTextAlignmentCenter;
        tmpLabel.textColor = [UIColor whiteColor];
        
        [roundView addSubview:tmpLabel];
        [cell.contentView addSubview:roundView];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DietaryRecallTableViewCell *tmpCell = (DietaryRecallTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    int oldValue = tmpCell.servingValue;
    NSLog(@"%d", oldValue);
    
    selectedIndexPath = indexPath;
    sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [sheet addSubview:pickerView];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    
    if (oldValue != 0) {
        [pickerView selectRow:(oldValue - 1) inComponent:0 animated:YES];
    }
    
    UIView *toolbarPicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbarPicker.backgroundColor = [UIColor whiteColor];
    [toolbarPicker sizeToFit];
    
    UIButton *bbitem = [[UIButton alloc] initWithFrame:CGRectMake(255, 0, 60, 44)];
    [bbitem setTitle:@"done" forState:UIControlStateNormal];
    [bbitem setTitleColor:bbitem.tintColor forState:UIControlStateNormal];
    [bbitem addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bbitem1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 60, 44)];
    [bbitem1 setTitle:@"cancel" forState:UIControlStateNormal];
    [bbitem1 setTitleColor:bbitem.tintColor forState:UIControlStateNormal];
    [bbitem1 addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbarPicker addSubview:bbitem];
    [toolbarPicker addSubview:bbitem1];
    [sheet addSubview:toolbarPicker];
    
    [sheet showInView:self.view];
    [sheet setBounds:CGRectMake(0, 0, 320, 415)];
}

#pragma mark picker dataSouce Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
        return [servings count];
    else
        return  servLabel.count;
}

#pragma mark delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0)
        return servings[row];
    else
        return  servLabel[row];
}

- (void)pickerView:(UIPickerView *)pView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedNumber = [pickerView selectedRowInComponent:0];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch(component) {
        case 0: return 50;
        default: return 150;
    }
    //NOT REACHED
    return 50;
}

#pragma mark - UIPicker done buttons

-(void)doneClicked {
    if (selectedNumber == NSNotFound) {
        selectedNumber = 0;
    }
    double energy = 0.0, carbohydrates = 0.0, protiens = 0.0, fats = 0.0, fibre = 0.0;
    
    number = servings[selectedNumber];
    
    DietaryRecallTableViewCell *tmpCell = (DietaryRecallTableViewCell *)[self.tableView cellForRowAtIndexPath:selectedIndexPath];
    
    //NSLog(@"%d", selectedIndexPath.row);
    //[selectedFood removeObjectForKey:[NSString stringWithFormat:@"%d", selectedIndexPath.row]];
    [selectedFood setObject:number forKey:[NSString stringWithFormat:@"%d", selectedIndexPath.row]];

    // calculate energy, carbohydrates, protiens, fats, fibre
    [database open];
    NSInteger oldValue = 0;
    FMResultSet *r = [database executeQuery:[NSString stringWithFormat:@"SELECT energy, cho, protiens, fats, fibre, calcValue FROM dietaryRecall WHERE id = %ld", (long)tmpCell.foodID]];
    while([r next]) {
        oldValue = [[r stringForColumn:@"calcValue"] integerValue];
        energy = [[r stringForColumn:@"energy"] doubleValue];
        carbohydrates = [[r stringForColumn:@"cho"] doubleValue];
        protiens = [[r stringForColumn:@"protiens"] doubleValue];
        fats = [[r stringForColumn:@"fats"] doubleValue];
        fibre = [[r stringForColumn:@"fibre"] doubleValue];
    }
    [database close];
    
    NSString *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:@"energy"];
    
    if (tmp != NULL) {
        // increment values
        double oldEnergy = [tmp doubleValue];
        double oldCarbohydrates = [[[NSUserDefaults standardUserDefaults] objectForKey:@"carbohydrates"] doubleValue];
        double oldProtiens = [[[NSUserDefaults standardUserDefaults] objectForKey:@"protiens"] doubleValue];
        double oldFats = [[[NSUserDefaults standardUserDefaults] objectForKey:@"fats"] doubleValue];
        double oldFibre = [[[NSUserDefaults standardUserDefaults] objectForKey:@"fibre"] doubleValue];
        
        // decrement old values data of curent food
        oldEnergy = (oldEnergy - (energy * oldValue)) + (energy * [number intValue]);
        oldCarbohydrates = (oldCarbohydrates - (carbohydrates * oldValue)) + (carbohydrates * [number intValue]);
        oldProtiens = (oldProtiens - (protiens * oldValue)) + (protiens * [number intValue]);
        oldFats = (oldFats - (fats * oldValue)) + (fats * [number intValue]);
        oldFibre = (oldFibre - (fibre * oldValue)) + (fibre * [number intValue]);
        
        // store these values in NSUserdefaults
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", oldEnergy] forKey:@"energy"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", oldCarbohydrates] forKey:@"carbohydrates"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", oldProtiens] forKey:@"protiens"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", oldFats] forKey:@"fats"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", oldFibre] forKey:@"fibre"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        // initial value
        // calculate new values
        energy = energy * [number intValue];
        carbohydrates = carbohydrates * [number intValue];
        protiens = protiens * [number intValue];
        fats = fats * [number intValue];
        fibre = fibre * [number intValue];
        
        // store these values in NSUserdefaults
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", energy] forKey:@"energy"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", carbohydrates] forKey:@"carbohydrates"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", protiens] forKey:@"protiens"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", fats] forKey:@"fats"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", fibre] forKey:@"fibre"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSLog(@"Energy ==> %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"energy"]);
    NSLog(@"Carbohydrates ==> %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"carbohydrates"]);
    NSLog(@"Protiens ==> %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"protiens"]);
    NSLog(@"Fats ==> %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"fats"]);
    NSLog(@"Fibre ==> %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"fibre"]);
    
    // update database and save current selected value
    [database open];
    [database executeUpdate:@"UPDATE dietaryRecall SET calcValue = ? WHERE id = ?", number, [NSString stringWithFormat:@"%d", tmpCell.foodID]];
    [database close];
    
    [self loadFood];
    [self.tableView reloadData];
    
    selectedNumber = NSNotFound;
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)cancelClicked {
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}

@end