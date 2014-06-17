//
//  CityTableViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 15/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "CityTableViewController.h"
#import "CityTableViewCell.h"
#import "MapViewController.h"

@interface CityTableViewController () <CityTableViewCellDelegate> {
    UIActivityIndicatorView *activityIndicator;
    DatabaseExtra *d;
    NSMutableArray *name, *address, *email, *telephone, *latitude, *longitude, *time;
    NSString *mapLat, *mapLongi, *mapTitle, *mapAddress;
}

@end

@implementation CityTableViewController

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
    
    //initialize DatabaseExtra class
    d = [[DatabaseExtra alloc] init];
    
    // initialize activityIndicator and add it to view.
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(0, 0, 40, 40);
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    
    
    self.title = self.State;
    [self loadCities];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = backButton;
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
    return name.count;
}

-(void)loadCities {
    name = [[NSMutableArray alloc] init];
    address = [[NSMutableArray alloc] init];
    email = [[NSMutableArray alloc] init];
    telephone = [[NSMutableArray alloc] init];
    latitude = [[NSMutableArray alloc] init];
    longitude = [[NSMutableArray alloc] init];
    time = [[NSMutableArray alloc] init];
    
    //check connection
    if (!d.checkConnection) {
        [DatabaseExtra errorInConnection];
        return;
    }
    
    [activityIndicator startAnimating];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"city": self.State};
    //NSLog(@"%@", parameters);
    [manager POST:cityListURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [activityIndicator stopAnimating];
        
        NSDictionary *json = (NSDictionary *)responseObject;
        
        if ([[json objectForKey:@"status"] isEqualToString:@"success"]) {
            
            NSInteger countData =[[json objectForKey:@"response"] count];
            //NSLog(@"%d", countData);
            for (int i = 0; i < countData; i++) {
                NSDictionary *response = (NSDictionary *)[json objectForKey:@"response"][i];
                [name addObject:[response objectForKey:@"name"]];
                [address addObject:[response objectForKey:@"address"]];
                [email addObject:[response objectForKey:@"email"]];
                [telephone addObject:[response objectForKey:@"telephone"]];
                [latitude addObject:[response objectForKey:@"latitude"]];
                [longitude addObject:[response objectForKey:@"longitude"]];
                [time addObject:[response objectForKey:@"timings"]];
            }
            [self.tableView reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [activityIndicator stopAnimating];
        [DatabaseExtra errorInConnection];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cityCell";
    
    CityTableViewCell *cell = (CityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[CityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    cell.lblName.text = name[indexPath.row];
	cell.lblAddress.text = address[indexPath.row];
    [cell.btnMail setTitle:email[indexPath.row] forState:UIControlStateNormal];
    cell.btnCall.callString = telephone[indexPath.row];

    /*NSString *myHTML = [NSString stringWithFormat:@"<html><body>%@<br/><br/>%@</body></html>", telephone[indexPath.row], email[indexPath.row]];
    [cell.webView loadHTMLString:myHTML baseURL:nil];
    cell.webView.scrollView.scrollEnabled = NO;*/
    
    cell.map.latitude = latitude[indexPath.row];
    cell.map.longitude = longitude[indexPath.row];
    cell.map.title = name[indexPath.row];
    cell.map.address = address[indexPath.row];
    
    cell.lblTime.text = time[indexPath.row];
    
    if (indexPath.row %2) {
        UIColor *altCellColor = [UIColor colorWithHexString:@"#E6E6E6"];
        cell.backgroundColor = altCellColor;
    }
    else {
        UIColor *altCellColor2 = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]; //white color
        cell.backgroundColor = altCellColor2;
    }
    
    return cell;
}

-(void)mapPressed:(NSString *)lat longitude:(NSString *)longi title:(NSString *)title address:(NSString *)add {
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    mapLat = lat;
    mapLongi = longi;
    mapTitle = title;
    mapAddress = add;
}

-(void)mailPressed:(NSString *)emailId {
    NSString *recipients = emailId;
    NSString *e = [NSString stringWithFormat:@"mailto:%@", recipients];
    e = [e stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:e]];
}

-(void)callPressed:(NSString *)callString {
    NSLog(@"%@", callString);
    NSString *s = [callString stringByReplacingOccurrencesOfString:@" " withString:@""];
    //NSLog(@"%@", s);
    NSArray *splitNum = [s componentsSeparatedByString: @","];
    
    numArray = [[NSMutableArray alloc] initWithArray:splitNum];
    //NSLog(@"%lu", (unsigned long)numArray.count);
    
    if (numArray.count == 1) {
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", s]];
        [[UIApplication sharedApplication] openURL:telURL];
        return;
    }
    
    sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    //CGRect pickerFrame = CGRectMake(0.0, 0.0, 0.0, 0.0);
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [sheet addSubview:myPickerView];
    myPickerView.backgroundColor = [UIColor whiteColor];
    myPickerView.delegate = self;
    myPickerView.dataSource = self;
    myPickerView.showsSelectionIndicator = YES;
    
    UIView *toolbarPicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbarPicker.backgroundColor = [UIColor grayColor];
    [toolbarPicker sizeToFit];
    
    UIButton *bbitem = [[UIButton alloc] initWithFrame:CGRectMake(255, 0, 60, 44)];
    [bbitem setTitle:@"Call" forState:UIControlStateNormal];
    [bbitem addTarget:self action:@selector(callClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bbitem1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 60, 44)];
    [bbitem1 setTitle:@"Cancel" forState:UIControlStateNormal];
    [bbitem1 setTitleColor:[UIColor colorWithHexString:@"#FE2E2E"] forState:UIControlStateNormal];
    [bbitem1 addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbarPicker addSubview:bbitem];
    [toolbarPicker addSubview:bbitem1];
    [sheet addSubview:toolbarPicker];
    
    [sheet showInView:self.view];
    [sheet setBounds:CGRectMake(0, 0, 320, 415)];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"mapPush"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MapViewController *v = (MapViewController *)segue.destinationViewController;
        v.latitude = mapLat;
        v.longitude = mapLongi;
        v.address = mapAddress;
        v.title = mapTitle;
    }
}

-(void)cancelClicked {
    selectedNumber = NULL;
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)callClicked {
    if (selectedNumber == NULL) {
        selectedNumber = numArray[0];
    }
    //NSLog(@"%@", selectedNumber);
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", selectedNumber]];
    [[UIApplication sharedApplication] openURL:telURL];
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedNumber = [numArray objectAtIndex:[myPickerView selectedRowInComponent:0]];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return numArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [numArray objectAtIndex:row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 235.0;
}

@end
