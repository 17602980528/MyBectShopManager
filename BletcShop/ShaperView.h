//
//  ShaperView.h
//  BletcShop
//
//  Created by apple on 16/11/4.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShaperView : UIView
-(ShaperView *)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
@end
