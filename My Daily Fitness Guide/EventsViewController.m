//
//  EventsViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 16/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "EventsViewController.h"
#import "SWRevealViewController.h"

@interface EventsViewController () {
    UIActivityIndicatorView *activityIndicator;
    DatabaseExtra *d;
    float webViewHeight;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation EventsViewController

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
    
    self.title = @"Events";
    
    if (IsIphone5) {
        webViewHeight = 340;
    } else {
        webViewHeight = 250;
    }
    
    //initialize DatabaseExtra class
    d = [[DatabaseExtra alloc] init];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.scrollView.pagingEnabled = YES;
    
    [self.view addSubview:self.scrollView];
    
    // set left side navigation button
    UIButton *btnMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    [btnMenu setBackgroundImage:[UIImage imageNamed:navigationImage] forState:UIControlStateNormal];
    [btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * menuButton = [[UIBarButtonItem alloc] initWithCustomView:btnMenu];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // initialize activityIndicator and add it to view.
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(0, 0, 40, 40);
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    
    [self loadEvents];
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

-(void)loadEvents {
    //check connection
    if (!d.checkConnection) {
        [DatabaseExtra errorInConnection];
        return;
    }
    
    [activityIndicator startAnimating];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:eventsURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [activityIndicator stopAnimating];
        //NSLog(@"response %@", responseObject);
        
        NSDictionary *json = (NSDictionary *)responseObject;
        
        if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
            NSInteger countData =[[json objectForKey:@"event"] count];
            
            for (int i = 0; i < countData; i++) {
                NSDictionary *response = (NSDictionary *)[json objectForKey:@"event"][i];
                
                NSInteger imageCountData =[[response objectForKey:@"image"] count];
                
                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(((self.scrollView.frame.size.width)*i), 0,self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
                //v.backgroundColor = [UIColor colorWithHexString:BlueColor5];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 150)];
                
                if (imageCountData > 0) {
                    __weak UIImageView *weekImage = imageView;
                    
                    NSURL *url = [NSURL URLWithString:[response objectForKey:@"image"][0]];
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    UIImage *placeholderImage = [UIImage imageNamed:@"default_offers_events.png"];
                    
                    [imageView setImageWithURLRequest:request
                                     placeholderImage:placeholderImage
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  weekImage.image = image;
                                                  
                                              } failure:nil];
                }
                else {
                    imageView.image = [UIImage imageNamed:@"default_offers_events.png"];
                }
                
                UIWebView *testWebview = [[UIWebView alloc] initWithFrame:CGRectMake(10, 160, 300, webViewHeight)];
                testWebview.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
                
                NSString *path = [[NSBundle mainBundle] pathForResource:@"im_boundary" ofType:@"png"];
                NSString *htmlString = [NSString stringWithFormat:@"<html><body bgcolor='#f2f2f2'><h3>%@</h3><hr style=\"display: block; height: 1px; border: 0; border-top: 1px solid #ccc; margin-top:-10px;\">%@<img src=\"file://%@\"></body></html>",[response objectForKey:@"title"], [response objectForKey:@"description"], path];
                [testWebview loadHTMLString:htmlString baseURL:nil];
                
                [self longPress:testWebview];
                
                [v addSubview:imageView];
                [v addSubview:testWebview];
                
                [self.scrollView addSubview:v];
            }
            
            [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * countData, 0)];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [activityIndicator stopAnimating];
        [DatabaseExtra errorInConnection];
    }];
}

- (void)longPress:(UIView *)webView {
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
    
    // Making sure the allowable movement isn't too narrow
    longPress.allowableMovement=100;
    // This is important - the duration must be long enough to allow taps but not longer than the period in which the scroll view opens the magnifying glass
    longPress.minimumPressDuration=0.3;
    
    longPress.delaysTouchesBegan=YES;
    longPress.delaysTouchesEnded=YES;
    
    longPress.cancelsTouchesInView=YES; // That's when we tell the gesture recognizer to block the gestures we want
    
    [webView addGestureRecognizer:longPress]; // Add the gesture recognizer to the view and scroll view then release
    [webView addGestureRecognizer:longPress];
}

// I just need this for the selector in the gesture recognizer.
- (void)handleLongPress {
    
}


@end
