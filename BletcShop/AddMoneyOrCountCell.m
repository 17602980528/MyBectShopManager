//
//  AddMoneyOrCountCell.m
//  BletcShop
//
//  Created by Bletc on 2017/6/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AddMoneyOrCountCell.h"

@implementation AddMoneyOrCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textTF.borderStyle =UITextBorderStyleNone;
    self.btnBackView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
