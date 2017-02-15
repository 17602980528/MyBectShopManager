//
//  CashListCell.m
//  BletcShop
//
//  Created by Bletc on 16/9/19.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CashListCell.h"

@implementation CashListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-1, SCREENWIDTH, 1)];
    view.backgroundColor = RGB(234, 234, 234);
    [self.contentView addSubview:view];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
