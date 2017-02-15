//
//  MoreViewCell.m
//  BletcShop
//
//  Created by wuzhengdong on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MoreViewCell.h"

@implementation MoreViewCell


-(void)setData:(NSString *)data
{
    _data = data;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.textLabel.text = data;

//    cell的线
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.3)];
    topLine.backgroundColor = [UIColor grayColor];
    topLine.alpha = 0.3;
    [self addSubview:topLine];
    
    UIView *footLine = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREENWIDTH, 0.3)];
    footLine.backgroundColor = [UIColor grayColor];
    footLine.alpha = 0.3;
    [self addSubview:footLine];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
