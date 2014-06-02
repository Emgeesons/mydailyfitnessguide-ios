//
//  ExcerciseListViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 29/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "ExcerciseListViewController.h"

@interface ExcerciseListViewController () <UITableViewDataSource, UITableViewDelegate> {
    UILabel *description, *secondDescription;
    FMDatabase *database;
    NSArray *basic_1_cardio,
            *basic_1_whole_body,
            *basic_2_lower_body,
            *basic_2_upper_body,
            *basic_2_wed_cardio,
            *basic_2_sun_cardio,
            *basic_2_nc_abs,
            *int1_lower_body,
            *int1_upper_1,
            *int1_upper_2,
            *int1_cardio_abs,
            *int2_chest_etc,
            *int2_back_etc,
            //*int2_abs,
            *adv1_legs,
            *adv1_back,
            *adv1_chest_b,
            *adv1_shoulder_t,
            *adv1_cardio_abs,
            *adv1_abs,
            *adv2_legs,
            *adv2_back,
            *adv2_chest_b,
            *adv2_shoulder_t,
            *adv2_cardio_abs,
            *functional1_workout,
            *functional2_workout,
            *functional_cardio,
            *mainArray,
            *secondArray;
    
    NSMutableArray *tmpArray, *tmpSecondArray;
    int top, startValue;
    
    UIView *view1, *view2;
}
@property (strong, nonatomic) IBOutlet UITableView *tvExcersices, *tvSecondExcercise;

@end

@implementation ExcerciseListViewController

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
    top = 55;
    
    CGRect rect = self.scrollViewDetail.frame;
    rect.origin.x = 320;
    self.scrollViewDetail.frame = rect;
    
    [self initializeArrays];
    
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    
    [self.navBar setBounds:CGRectMake(0, 0, 320, 81)];
    [self.navBar setBarTintColor:[UIColor blackColor]];
    
    [self setScreenTitle];
    
    view1 = [[UIView alloc] initWithFrame:CGRectZero];
    
    tmpArray = [[NSMutableArray alloc] init];
    tmpSecondArray = [[NSMutableArray alloc] init];
    
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 280, 21)];
    self.lblTitle.text = self.excerciseName;
    [view1 addSubview:self.lblTitle];
    
    [self setMainArray];
    
    view1.frame = CGRectMake(10, 0, 300, (top + 21 + ((mainArray.count - 1) * 44) + 50));
    
    // set gradient background for viewBg
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view1.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHexString:@"#e8e8e8"] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [view1.layer insertSublayer:gradient atIndex:0];
    
    // check here mainArray's 1st element is blank or not
    if ([mainArray[0] isEqualToString:@""]) {
        // don't add label of description
        startValue = 1;
    } else {
        // add label of description
        startValue = 1;
        top = top - 15;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]};
        CGRect rect = [mainArray[0] boundingRectWithSize:CGSizeMake(203, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
        float heightToAdd = rect.size.height;
        description = [[UILabel alloc] initWithFrame:CGRectMake(10, top, view1.frame.size.width - 10, heightToAdd)];
        description.text = mainArray[0];
        description.numberOfLines = 0;
        description.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        description.textColor = [UIColor grayColor];
        
        [view1 addSubview:description];
        
        top = top + heightToAdd + 10;
    }

    for (int i = startValue; i < mainArray.count; i++) {
        [tmpArray addObject:mainArray[i]];
    }
    
    // add tableview here
    _tvExcersices =  [[UITableView alloc] initWithFrame:CGRectMake(0, top, view1.frame.size.width, ((mainArray.count - 1) * 44))];
    _tvExcersices.backgroundColor = [UIColor clearColor];
    
    self.tvExcersices.dataSource = self;
    self.tvExcersices.delegate = self;
    self.tvExcersices.scrollEnabled = NO;
    [view1 addSubview:_tvExcersices];
    
    [self.scrollView addSubview:view1];
    
    if ([self.dietPlan isEqualToString:@"vacation"]) {
        int tmp_top = 40;
        if ([self.excerciseName isEqualToString:@"Exercise"]) {
            //add functional 2 array
            view2 = [[UIView alloc] initWithFrame:CGRectZero];
            
            self.lblSecondTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 21)];
            self.lblSecondTitle.text = @"Alternate Exercise Program";
            [view2 addSubview:self.lblSecondTitle];
            
            view2.frame = CGRectMake(10, view1.frame.size.height + 10, 300, (tmp_top + 21 + ((secondArray.count - 1) * 44) + 50));
            
            // set gradient background for viewBg
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = view2.bounds;
            gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHexString:@"#e8e8e8"] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
            [view2.layer insertSublayer:gradient atIndex:0];
            
            //tmp_top = tmp_top - 15;
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]};
            CGRect rect = [secondArray[0] boundingRectWithSize:CGSizeMake(203, MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:attributes
                                                     context:nil];
            float heightToAdd = rect.size.height;
            secondDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, tmp_top, view2.frame.size.width - 10, heightToAdd)];
            secondDescription.text = secondArray[0];
            secondDescription.numberOfLines = 0;
            secondDescription.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
            secondDescription.textColor = [UIColor grayColor];
            
            [view2 addSubview:secondDescription];
            
            tmp_top = tmp_top + heightToAdd + 10;
            
            for (int i = startValue; i < secondArray.count; i++) {
                [tmpSecondArray addObject:secondArray[i]];
            }
            
            // add tableview here
            self.tvSecondExcercise =  [[UITableView alloc] initWithFrame:CGRectMake(0, tmp_top, view2.frame.size.width, ((secondArray.count - 1) * 44))];
            self.tvSecondExcercise.backgroundColor = [UIColor clearColor];
            
            self.tvSecondExcercise.dataSource = self;
            self.tvSecondExcercise.delegate = self;
            self.tvSecondExcercise.scrollEnabled = NO;
            [view2 addSubview:self.tvSecondExcercise];
            
            [self.scrollView addSubview:view2];
        }
    }
    
    float sizeOfContent = 0;
    UIView *lLast = [self.scrollView.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    
    sizeOfContent = wd+ht;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, sizeOfContent);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tvExcersices) {
        return tmpArray.count;
    } else {
        return tmpSecondArray.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (tableView == self.tvExcersices) {
        cell.textLabel.text = tmpArray[indexPath.row];
    } else {
        cell.textLabel.text = tmpSecondArray[indexPath.row];
    }
    
    cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 14.0];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 14, 16, 16)];
    imageView.image = [UIImage imageNamed:@"ic_about.png"];
    
    [cell.contentView addSubview:imageView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *tmpCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *tmpString = tmpCell.textLabel.text;
    
    [self drawScrollView:tmpString];
    
    CGRect newFrame = self.scrollViewDetail.frame;
    newFrame.origin.x = 0;
    
    [UIView animateWithDuration:0.7f
                          delay:0.0f
                        options: UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         [self.scrollView setAlpha:0.0];
                         [self.scrollViewDetail setAlpha:1.0];
                         [self.scrollView setFrame:CGRectMake(-320, 71.0f, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
                         self.scrollViewDetail.frame = newFrame;
                     }
                     completion:nil];
}

#pragma mark - General Functions
- (IBAction)backButtonPressed:(id)sender {
    
    if (self.scrollView.alpha == 0) {
        [self setScreenTitle];
        
        CGRect newFrame = self.scrollView.frame;
        newFrame.origin.x = 0;
        
        [UIView animateWithDuration:0.7f
                              delay:0.0f
                            options: UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             [self.scrollViewDetail setAlpha:0.0];
                             [self.scrollView setAlpha:1.0];
                             [self.scrollViewDetail setFrame:CGRectMake(320, 71.0f, self.scrollViewDetail.frame.size.width, self.scrollViewDetail.frame.size.height)];
                             self.scrollView.frame = newFrame;
                         }
                         completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)drawScrollView:(NSString *)excercise {
    
    self.navItem.title = excercise;
    
    [self.scrollViewDetail.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSString *tmpImageName, *tmpDescription;
    
    [database open];
    
    FMResultSet *results = [database executeQuery:[NSString stringWithFormat:@"SELECT imageName,description FROM excerciseDescription WHERE excercise = '%@'", excercise]];
    
    while([results next]) {
        tmpImageName = [results stringForColumn:@"imageName"];
        tmpDescription = [results stringForColumn:@"description"];
    }
    
    [database close];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", tmpImageName]];
    [self.scrollViewDetail addSubview:imageView];
    
    // add name of excercise here
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(20, imageView.frame.size.height + 10, 300, 30)];
    lblName.text = excercise;
    
    [self.scrollViewDetail addSubview:lblName];
    
    // add description of excercise here
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]};
    CGRect rect = [tmpDescription boundingRectWithSize:CGSizeMake(203, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes
                                             context:nil];
    float heightToAdd = rect.size.height;
    
    UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(20, lblName.frame.origin.y + lblName.frame.size.height, 280, heightToAdd)];
    lblDesc.numberOfLines = 0;
    lblDesc.textColor = [UIColor grayColor];
    lblDesc.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    lblDesc.text = [NSString stringWithFormat:@"%@", tmpDescription];
    
    [self.scrollViewDetail addSubview:lblDesc];
    
    float sizeOfContent = 0;
    UIView *lLast = [self.scrollViewDetail.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    
    sizeOfContent = wd+ht;
    
    self.scrollViewDetail.contentSize = CGSizeMake(self.scrollViewDetail.frame.size.width, sizeOfContent);
}

-(void)initializeArrays {
    basic_1_cardio = @[@"Cardio 20-30 minutes. You can choose from one of the following or do all 3. (10 mins each)", @"Stationary Bike", @"Walking Workout", @"Elliptical Workout"];
    
    basic_1_whole_body = @[@"15 to 20 repetitions. 1 set each. Minimum rest period between two sets", @"Squats", @"Leg Press", @"Leg Extension", @"Seated Leg Curl", @"Back Extension", @"Lat Pull Down", @"Chest Press", @"Cable Overhead Press", @"Dumbbell Arm Curl", @"Cable Triceps Extension"];
    
    basic_2_lower_body = @[@"15 repetitions. 1 to 2 sets each. 1-2 min rest period between two sets", @"Squats", @"Lunges", @"Leg Press", @"Leg Extension", @"Prone Leg Curl", @"Standing Calf Raises", @"Seated Calf Raises"];
    
    basic_2_upper_body = @[@"15 repetitions. 1 to 2 sets each. 1-2 min rest period between two sets", @"Back Extension", @"Lat Pull Down", @"Seated Row", @"Chest Press", @"Chest-Pec Fly", @"Dumbbell Shrugs", @"Reverse Pec Fly", @"Cable Overhead Press", @"Cable Front Raises", @"Cable Lateral Raises", @"Barbell Biceps Curl", @"Cable Triceps Extension"];
    
    basic_2_wed_cardio = @[@"Cardio and Abs. Cardio 20-30 minutes. You can choose from one of the following or do all 3. (10 mins each)", @"Stationary Bike", @"Walking Workout", @"Elliptical Workout", @"Crunches", @"Reverse Crunches"];
    
    basic_2_sun_cardio = @[@"", @"Stationary Bike", @"Walking Workout", @"Elliptical Workout"];
    
    basic_2_nc_abs = @[@"", @"Crunches", @"Reverse Crunches"];
    
    int1_lower_body = @[@"12 to 15 repetitions. 2 to 3 sets. 2 min rest period between two sets", @"Squats", @"Lunges", @"Leg Press", @"Leg Extension", @"Prone Leg Curl", @"Standing Calf Raises", @"Seated Calf Raises"];
    
    int1_upper_1 = @[@"12 to 15 repetitions. 2 to 3 sets. 2 min rest period between two sets", @"Back Extension", @"Lat Pull Down", @"One Arm Dumbbell Row", @"Seated Row", @"Barbell Shrugs", @"Reverse Pec Fly", @"Dumbbell Arm Curl", @"Dumbbell Hammer Curls", @"Reverse Cable Curls"];
    
    int1_upper_2 = @[@"12 to 15 repetitions. 2 to 3 sets. 2 min rest period between two sets", @"Decline Bench Press", @"Flat Bench Chest Press", @"Incline Bench Press", @"Cable Cross Over", @"Barbell Overhead Press", @"Front Raises", @"Lateral Raises", @"Dumbbell Tricep Extension", @"Cable Kickbacks"];
    
    int1_cardio_abs = @[@"Cardio and Abs. Cardio 45 minutes. You can choose from one of the following or do all 3. (15 mins each)", @"Stationary Bike", @"Walking Workout", @"Elliptical Workout", @"Crunches", @"Reverse Crunches", @"Oblique Crunches"];
    
    int2_chest_etc = @[@"12 to 15 repetitions. 2 to 3 sets. 1 min rest period between two sets", @"Squats", @"Lunges", @"Step Ups", @"Stiff Leg Dead Lift", @"Standing Calf Raises", @"Seated Calf Raises", @"Decline Bench Press", @"Flat Bench Chest Press", @"Incline Bench Press", @"Cable Cross Over", @"Clean And Press", @"Lateral Raises", @"Bent Over Lateral Raises", @"Barbell Overhead Press", @"Dumbbell Tricep Kickback"];
    
    int2_back_etc = @[@"12 to 15 repetitions. 2 to 3 sets. 1 min rest period between two sets", @"Pull Ups-Chin Ups", @"Conventional Dead Lift", @"Bent Over Barbell Row", @"One Arm Dumbbell Row", @"Lat Pull Down", @"Supination Curl", @"Preacher Curls", @"Seated Leg Curl", @"Prone Leg Curl"];
    
    //int2_abs = @[@"", @"Crunches", @"Reverse Crunches", @"Oblique Crunches", @"Plank"];
    
    adv1_legs = @[@"8-12 repetitions. 2 to 5 sets. 2 min rest period between two sets", @"Jump Squats", @"Dynamic Lunges", @"Leg Press", @"Leg Extension", @"Stiff Leg Dead Lift", @"Prone Leg Curl", @"Standing Calf Raises", @"Seated Calf Raises"];
    
    adv1_back = @[@"8-12 repetitions. 2 to 5 sets. 2 min rest period between two sets", @"Bent Over Barbell Row", @"Pull Ups-Chin Ups", @"Cable Seated Row", @"Conventional Dead Lift", @"Bent Over Barbell Row", @"Dumbbell Shrugs", @"Rear Delt Fly", @"Clean And Press"];
    
    adv1_chest_b = @[@"8-12 repetitions. 2 to 5 sets. 2 min rest period between two sets", @"Push Ups", @"Decline Bench Press", @"Flat Bench Chest Press", @"Incline Bench Press", @"Cable Cross Over", @"Supination Curl", @"Preacher Curls", @"Dumbbell Hammer Curls", @"Reverse Cable Curls"];
    
    adv1_shoulder_t = @[@"8-12 repetitions. 2 to 5 sets. 2 min rest period between two sets", @"Overhead Press", @"Front Raises", @"Lateral Raises", @"Bent Over Lateral Raises", @"Close Grip Bench Press", @"Tricep Dips", @"Dumbbell Tricep Kickback"];
    
    adv1_cardio_abs = @[@"Cardio 45 minutes. You can choose from one of the following or do all 3. (15 mins each)", @"Stationary Bike", @"Walking Workout", @"Elliptical Workout", @"Incline Bench Leg Raises", @"Hanging Oblique Crunches", @"Plank"];
    
    adv1_abs = @[@"", @"Incline Bench Leg Raises", @"Hanging Oblique Crunches", @"Plank"];
    
    adv2_legs = @[@"8-12 repetitions. 2 to 5 sets. 2 min rest period between two sets. This being an athletic workout needs to be done with speed", @"Jump Squats", @"Dynamic Lunges", @"Leg Press", @"Leg Extension", @"Stiff Leg Dead Lift", @"Prone Leg Curl", @"Standing Calf Raises", @"Seated Calf Raises"];
    
    adv2_back = @[@"8-12 repetitions. 2 to 5 sets. 2 min rest period between two sets. This being an athletic workout needs to be done with speed", @"Bent Over Barbell Row", @"Pull Ups-Chin Ups", @"Cable Seated Row", @"Conventional Dead Lift", @"Bent Over Barbell Row", @"Dumbbell Shrugs", @"Rear Delt Fly", @"Clean And Press"];
    
    adv2_chest_b = @[@"8-12 repetitions. 2 to 5 sets. 2 min rest period between two sets. This being an athletic workout needs to be done with speed", @"Push Ups", @"Decline Bench Press", @"Flat Bench Chest Press", @"Incline Bench Press", @"Cable Cross Over", @"Supination Curl", @"Preacher Curls", @"Dumbbell Hammer Curls", @"Reverse Cable Curls"];
    
    adv2_shoulder_t = @[@"8-12 repetitions. 2 to 5 sets. 2 min rest period between two sets. This being an athletic workout needs to be done with speed", @"Overhead Press", @"Front Raises", @"Lateral Raises", @"Bent Over Lateral Raises", @"Close Grip Bench Press", @"Tricep Dips", @"Dumbbell Tricep Kickback"];
    
    adv2_cardio_abs = @[@"Cardio 45 minutes. You can choose from one of the following or do all 3. (15 mins each). This being an athletic workout needs to be done with speed", @"Stationary Bike", @"Walking Workout", @"Elliptical Workout", @"Incline Bench Leg Raises", @"Hanging Oblique Crunches", @"Plank"];
    
    functional1_workout = @[@"15-30 repetitions. 2 sets or upto failure. 1-2 min rest between two sets", @"Burpees", @"Clap Pushups", @"Step Up And Squat", @"Mountain Climber", @"Duck Walk", @"Inchworm Walk", @"Frog Jumps", @"Farmers Walk", @"Spider Man Walk", @"Pull Ups With Speed", @"Skipping With Speed"];
    
    functional2_workout = @[@"Involves using your own Body Weight for Resistance and Dumbbells, Barbells & Kettlebells if available", @"Squats With Figure Of 8", @"Step Ups With Lateral Press", @"Dead Lift With Shrugs", @"Squats With Overhead Press", @"Lunges With Bicep Curl", @"Standing Calf Raises With Reverse Curls", @"Bent Over Barbell Rowing With Dumbbell Kick Backs", @"Decline Bench Press With Crunches", @"Incline Bench Press With Leg Raises"];
    
    functional_cardio = @[@"", @"Walk / Jog"];
}

-(void)setScreenTitle {
    if ([self.pageTitle isEqualToString:@"Mon"]) {
        self.navItem.title = @"Monday";
    } else if ([self.pageTitle isEqualToString:@"Tue"]) {
        self.navItem.title = @"Tuesday";
    } else if ([self.pageTitle isEqualToString:@"Wed"]) {
        self.navItem.title = @"Wednesday";
    } else if ([self.pageTitle isEqualToString:@"Thu"]) {
        self.navItem.title = @"Thursday";
    } else if ([self.pageTitle isEqualToString:@"Fri"]) {
        self.navItem.title = @"Friday";
    } else if ([self.pageTitle isEqualToString:@"Sat"]) {
        self.navItem.title = @"Saturday";
    } else if ([self.pageTitle isEqualToString:@"Sun"]) {
        self.navItem.title = @"Sunday";
    }
}

-(void)setMainArray {
    if ([self.dietPlan isEqualToString:@"Basic 1"]) {
        if ([self.excerciseName isEqualToString:@"Cardio"]) {
            mainArray = [NSArray arrayWithArray:basic_1_cardio];
        } else if ([self.excerciseName isEqualToString:@"Whole Body Resistance Training"]) {
            mainArray = [NSArray arrayWithArray:basic_1_whole_body];
        }
    } else if ([self.dietPlan isEqualToString:@"Basic 2"] || [self.dietPlan isEqualToString:@"Basic 2 (No Cardio)"]) {
        if ([self.excerciseName isEqualToString:@"Lower Body Resistance Training"]) {
            mainArray = [NSArray arrayWithArray:basic_2_lower_body];
        } else if ([self.excerciseName isEqualToString:@"Upper Body Resistance Training"]) {
            mainArray = [NSArray arrayWithArray:basic_2_upper_body];
        } else if ([self.excerciseName isEqualToString:@"Cardio & Abs"]) {
            mainArray = [NSArray arrayWithArray:basic_2_wed_cardio];
        } else if ([self.excerciseName isEqualToString:@"Cardio / Rest"]) {
            mainArray = [NSArray arrayWithArray:basic_2_sun_cardio];
        } else if ([self.excerciseName isEqualToString:@"Abs"]) {
            mainArray = [NSArray arrayWithArray:basic_2_nc_abs];
        }
    } else if ([self.dietPlan isEqualToString:@"Advance 1"] || [self.dietPlan isEqualToString:@"Advance 1 (No Cardio)"]) {
        //Advance 1
        if ([self.excerciseName isEqualToString:@"Lower Body Resistance Training (Legs)"]) {
            mainArray = [NSArray arrayWithArray:adv1_legs];
        } else if ([self.excerciseName isEqualToString:@"Upper Body Resistance Training (back)"]) {
            mainArray = [NSArray arrayWithArray:adv1_back];
        } else if ([self.excerciseName isEqualToString:@"Cardio & Abs/ Core"]) {
            mainArray = [NSArray arrayWithArray:adv1_cardio_abs];
        } else if ([self.excerciseName isEqualToString:@"Upper Body Resistance Training (Chest + Biceps)"]) {
            mainArray = [NSArray arrayWithArray:adv1_chest_b];
        } else if ([self.excerciseName isEqualToString:@"Upper Body Resistance Training (Shoulder + Triceps)"]) {
            mainArray = [NSArray arrayWithArray:adv1_shoulder_t];
        } else if ([self.excerciseName isEqualToString:@"Abs/ Core"]) {
            mainArray = [NSArray arrayWithArray:adv1_abs];
        }
    } else if ([self.dietPlan isEqualToString:@"Advance 2"]) {
        //Advance 2
        if ([self.excerciseName isEqualToString:@"Lower Body Resistance Training (Legs)"]) {
            mainArray = [NSArray arrayWithArray:adv2_legs];
        } else if ([self.excerciseName isEqualToString:@"Upper Body Resistance Training (back)"]) {
            mainArray = [NSArray arrayWithArray:adv2_back];
        } else if ([self.excerciseName isEqualToString:@"Cardio & Abs/ Core"]) {
            mainArray = [NSArray arrayWithArray:adv2_cardio_abs];
        } else if ([self.excerciseName isEqualToString:@"Upper Body Resistance Training (Chest + Biceps)"]) {
            mainArray = [NSArray arrayWithArray:adv2_chest_b];
        } else if ([self.excerciseName isEqualToString:@"Upper Body Resistance Training (Shoulder + Triceps)"]) {
            mainArray = [NSArray arrayWithArray:adv2_shoulder_t];
        }
    } else if ([self.dietPlan isEqualToString:@"Intermediate 1"]) {
        if ([self.excerciseName isEqualToString:@"Lower Body Resistance Training"]) {
            mainArray = [NSArray arrayWithArray:int1_lower_body];
        } else if ([self.excerciseName isEqualToString:@"Upper Body Resistance Training (Back + Biceps)"]) {
            mainArray = [NSArray arrayWithArray:int1_upper_1];
        } else if ([self.excerciseName isEqualToString:@"Cardio & Core (Abs)"]) {
            mainArray = [NSArray arrayWithArray:int1_cardio_abs];
        } else if ([self.excerciseName isEqualToString:@"Upper Body Resistance Training (Chest + Shoulder + Triceps)"]) {
            mainArray = [NSArray arrayWithArray:int1_upper_2];
        }
    } else if ([self.dietPlan isEqualToString:@"Intermediate 2 (No Cardio)"]) {
        if ([self.excerciseName isEqualToString:@"Chest, Shoulders & Triceps + Quads & Calves"]) {
            mainArray = [NSArray arrayWithArray:int2_chest_etc];
        } else if ([self.excerciseName isEqualToString:@"Back & Biceps + Hamstrings & Abs"]) {
            mainArray = [NSArray arrayWithArray:int2_back_etc];
        }
    } else if ([self.dietPlan isEqualToString:@"Functional Training 1"] || [self.dietPlan isEqualToString:@"vacation"]) {
        //Functional Training 1
        if ([self.excerciseName isEqualToString:@"Exercise"]) {
            mainArray = [NSArray arrayWithArray:functional1_workout];
            secondArray = [NSArray arrayWithArray:functional2_workout];
        } else if ([self.excerciseName isEqualToString:@"Cardio"]) {
            mainArray = [NSArray arrayWithArray:functional_cardio];
        }
    } else if ([self.dietPlan isEqualToString:@"Functional Training 2"]) {
        //Functional Training 2
        if ([self.excerciseName isEqualToString:@"Exercise"]) {
            mainArray = [NSArray arrayWithArray:functional2_workout];
        } else if ([self.excerciseName isEqualToString:@"Cardio"]) {
            mainArray = [NSArray arrayWithArray:functional_cardio];
        }
    }
}

@end