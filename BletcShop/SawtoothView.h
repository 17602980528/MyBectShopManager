//
//  SawtoothView.h
//  text1
//
//  Created by Bletc on 2017/2/18.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SawtoothView : UIView


/**
 *  设置波浪线背景颜色、波浪个数、波浪view的高度
 *
 *  @param color  填充颜色
 *  @param topColor 顶部颜色
 *  @param count  波浪个数
 */
- (void)setColor:(UIColor *)color waveCount:(int)count;

@end
