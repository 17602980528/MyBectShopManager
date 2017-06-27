//
//  NewShopComeInTableViewCell.m
//  BletcShop
//
//  Created by apple on 2017/6/27.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewShopComeInTableViewCell.h"

@implementation NewShopComeInTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shopKind.layer.borderWidth=1.0f;
    self.shopKind.layer.borderColor=[RGB(250, 110, 113)CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
