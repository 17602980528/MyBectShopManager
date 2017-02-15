//
//  UILabel+extension.m
//  BletcShop
//
//  Created by Bletc on 2016/11/10.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "UILabel+extension.h"

@implementation UILabel (extension)
+(CGSize)getSizeWithLab:(UILabel*)lable andMaxSize:(CGSize)size{
    
    CGSize SZ = [lable.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:lable.font} context:nil].size ;
    
    return SZ
    ;
}

@end
