//
//  UIBarButtonItem+projectButtons.m
//  Hinduja
//
//  Created by yogesh on 01/04/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "UIBarButtonItem+projectButtons.h"

@implementation UIBarButtonItem (projectButtons)

+ (UIBarButtonItem *)backArrowButtonWithTarget:(id)target action:(SEL)action
{
    UIImage *buttonImage = [UIImage imageNamed:@"back.png"];
    
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return customBarItem;
}

@end
