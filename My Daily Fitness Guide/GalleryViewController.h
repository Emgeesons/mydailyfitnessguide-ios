//
//  GalleryViewController.h
//  My Daily Fitness Guide
//
//  Created by Yogesh Suthar on 09/06/2014.
//  Copyright (c) 2014 Yogesh Suthar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryViewController : UIViewController
- (IBAction)backButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
