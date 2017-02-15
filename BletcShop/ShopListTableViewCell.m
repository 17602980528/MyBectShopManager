//
//  ShopListTableViewCell.m
//  BletcShop
//
//  Created by Bletc on 16/8/4.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShopListTableViewCell.h"

@implementation ShopListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    //CGContextSetStrokeColorWithColor(context, COLORWHITE.CGColor);
    //CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    //下分割线
    CGContextSetStrokeColorWithColor(context,[UIColor grayColor].CGColor);
    CGContextStrokeRect(context,CGRectMake(0, rect.size.height, rect.size.width,0.3));
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
