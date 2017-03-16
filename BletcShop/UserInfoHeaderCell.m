//
//  UserInfoHeaderCell.m
//  BletcShop
//
//  Created by Bletc on 2017/3/15.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "UserInfoHeaderCell.h"

@implementation UserInfoHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headImg.layer.cornerRadius = self.headImg.width/2;
    self.headImg.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
