//
//  PhotoCell.h
//  My Daily Fitness Guide
//
//  Created by Yogesh Suthar on 10/06/2014.
//  Copyright (c) 2014 Yogesh Suthar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell
@property (nonatomic, strong) NSString *imageName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
-(void)updateCell;
@end
