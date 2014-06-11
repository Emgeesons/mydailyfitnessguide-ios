//
//  PhotoCell.m
//  My Daily Fitness Guide
//
//  Created by Yogesh Suthar on 10/06/2014.
//  Copyright (c) 2014 Yogesh Suthar. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PhotoCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
}

-(void)updateCell {
    //NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [[docPaths objectAtIndex:0] stringByAppendingPathComponent:@"/gallery"];
    NSString *filename = [NSString stringWithFormat:@"%@/%@", dataPath, self.imageName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:filename];
    
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView setImage:image];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
