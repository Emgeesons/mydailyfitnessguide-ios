//
//  PhotoViewController.h
//  My Daily Fitness Guide
//
//  Created by Yogesh Suthar on 10/06/2014.
//  Copyright (c) 2014 Yogesh Suthar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewAccessibilityDelegate, UIScrollViewDelegate>
@property (nonatomic) NSInteger imagePosition;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItemBottom;

@end
