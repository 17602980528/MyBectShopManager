//
//  PackageOtherTableViewCell.m
//  BletcShop
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PackageOtherTableViewCell.h"

@implementation PackageOtherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cardImageView.layer.cornerRadius=3.0f;
    self.cardImageView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.cardImageView.layer.borderWidth=0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
