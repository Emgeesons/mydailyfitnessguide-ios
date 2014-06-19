//
//  VIPViewController.m
//  My Daily Fitness Guide
//
//  Created by Yogesh Suthar on 19/06/2014.
//  Copyright (c) 2014 Yogesh Suthar. All rights reserved.
//

#import "VIPViewController.h"
#import "SWRevealViewController.h"

@interface VIPViewController () <UIWebViewDelegate> {
    UIActivityIndicatorView *activityIndicator;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation VIPViewController

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
    
    // set left side navigation button
    UIButton *btnMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    [btnMenu setBackgroundImage:[UIImage imageNamed:navigationImage] forState:UIControlStateNormal];
    [btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * menuButton = [[UIBarButtonItem alloc] initWithCustomView:btnMenu];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.title = @"VIP Pass";
    
    //start an animator symbol for the webpage loading to follow
    UIActivityIndicatorView *progressWheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    progressWheel.hidesWhenStopped = YES;
    progressWheel.center = self.webView.center;
    
    activityIndicator = progressWheel;
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
    
    NSString *urlAddress = vipPass;
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [activityIndicator stopAnimating];
    [DatabaseExtra errorInConnection];
}

- (void)webViewDidFinishLoad:(UIWebView *)thisWebView
{
    //stop the activity indicator when done loading
    [activityIndicator stopAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
