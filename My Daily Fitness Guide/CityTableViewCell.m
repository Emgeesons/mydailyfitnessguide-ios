//
//  CityTableViewCell.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 15/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "CityTableViewCell.h"

@implementation CityTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)mapClicked:(id)sender {
    [self.delegate mapPressed:self.map.latitude longitude:self.map.longitude title:self.map.title address:self.map.address];
}

- (IBAction)mailClicked:(id)sender {
    [self.delegate mailPressed:self.btnMail.titleLabel.text];
}

- (IBAction)calClicked:(id)sender {
    [self.delegate callPressed:self.btnCall.callString];
}
@end
