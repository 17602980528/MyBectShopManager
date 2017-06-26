//
//  PackageHomePageTableViewCell.m
//  BletcShop
//
//  Created by apple on 2017/6/24.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PackageHomePageTableViewCell.h"

@implementation PackageHomePageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cardImageView.layer.borderWidth=0.6f;
    self.cardImageView.layer.borderColor=[RGB(238,238,238)CGColor];
    self.cardImageView.layer.cornerRadius=3.0f;
    self.cardImageView.clipsToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
