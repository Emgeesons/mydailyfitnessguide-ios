//
//  DosAndDontsViewController.h
//  My Daily Fitness Guide
//
//  Created by yogesh on 24/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DosAndDontsViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString *screenType;

- (IBAction)backButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
