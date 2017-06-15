//
//  CALayer+LZDLayColor.m
//  BletcShop
//
//  Created by Bletc on 2017/6/15.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CALayer+LZDLayColor.h"

@implementation CALayer (LZDLayColor)
- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
