//
//  SawtoothView.m
//  text1
//
//  Created by Bletc on 2017/2/18.
//  Copyright © 2017年 bletc. All rights reserved.
//


#import "SawtoothView.h"

@interface SawtoothView ()
{
    int waveCount;
    UIColor *bgColor;
    UIColor *viewTopColor;
    CGFloat viewHeight;
}

@end
@implementation SawtoothView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
#pragma mark - 第一步：获取上下文
    //获取绘图上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
#pragma mark - 第二步：构建路径
    if (waveCount <= 0) {
        waveCount = 30;//默认30个
    }
    
    
    //单个波浪线的宽度
    CGFloat itemWidth = self.frame.size.width/(waveCount*2+1);
    //单个波浪线的高度
    CGFloat itemHeight = itemWidth/2;
    //整个view的大小
    if (viewHeight <= 0) {
        viewHeight = 50;//默认50大小
    }
    
    //背景色
    if (bgColor == nil) {
        bgColor = [UIColor blackColor];
    }
    
    if (viewTopColor == nil) {
        viewTopColor = [UIColor orangeColor];
    }
    
    //移动到起始点,从左上画到右上
    CGContextMoveToPoint(ctx, 0, itemHeight);
    
    CGContextAddLineToPoint(ctx, itemWidth, itemHeight);

    
    for (int i = 0; i<waveCount; i++) {
        int nextX = i*itemWidth*2+itemWidth;
        

        CGContextAddArc(ctx, nextX+itemWidth/2, itemHeight, itemWidth/2, 0, M_PI, 1);

        CGContextAddLineToPoint(ctx, nextX+itemWidth, itemHeight);
        CGContextAddLineToPoint(ctx, nextX+itemWidth*2, itemHeight);


    }
    
    
    //右上移动到右下角
    CGContextAddLineToPoint(ctx, self.frame.size.width, viewHeight);
    
    //右下角画到左下角
//    for(int i = waveCount+1;i > 0;i--){
//        int preX = (i-1)*itemWidth;
//        CGContextAddLineToPoint(ctx, preX - itemWidth*0.5, viewHeight);
//        CGContextAddLineToPoint(ctx, preX - itemWidth, viewHeight - itemHeight);
//    }
    
    CGContextAddLineToPoint(ctx, 0, viewHeight);
#pragma mark - 第三步：将路径画到view上
    //    CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
    CGContextSetFillColorWithColor(ctx, bgColor.CGColor);
    CGContextFillPath(ctx);
    
    
//    //开始画顶部的填充图
//    CGContextMoveToPoint(ctx, 0, itemHeight);
//    for (int i = 0 ; i<waveCount; i++) {
//        int nextX = (i+1)*itemWidth;
//        CGContextAddLineToPoint(ctx, nextX - itemWidth*0.5, 0);
//        CGContextAddLineToPoint(ctx, nextX, itemHeight);
//    }
//    CGContextSetFillColorWithColor(ctx, viewTopColor.CGColor);
//    CGContextAddLineToPoint(ctx, self.frame.size.width, 0);
//    CGContextAddLineToPoint(ctx, 0, 0);
//    CGContextFillPath(ctx);
}
/**
 *  设置波浪线背景颜色、波浪个数、波浪view的高度
 *
 *  @param color  填充颜色
 *  @param topColor 顶部颜色
 *  @param count  波浪个数
 */

- (void)setColor:(UIColor *)color  waveCount:(int)count;
{
    
    bgColor = color;
    waveCount = count;
    viewHeight = self.frame.size.height;
    
    [self setNeedsDisplay];
}

@end
