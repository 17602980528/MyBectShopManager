//
//  BussinessView.m
//  BletcShop
//
//  Created by Yuan on 16/2/3.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "BussinessView.h"

@implementation BussinessView



-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH/3, SCREENWIDTH/3-10)];
        UIButton *Btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        Btn1.frame = CGRectMake(30, 20, (SCREENWIDTH-180)/3,(2*SCREENWIDTH/3-20-80 )/2);
        
        [Btn1 setImage:[UIImage imageNamed:@"yuyue"] forState:UIControlStateNormal];
        self.Btn1 = Btn1;
        [view1 addSubview:Btn1];
        [self addSubview:view1];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(view1.width, 0, 1, view1.width*2-20+1)];
        line1.backgroundColor = [UIColor grayColor];
        [self addSubview:line1];
        
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/3 +1, 0, SCREENWIDTH/3, SCREENWIDTH/3-10)];
        UIButton *Btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        Btn2.frame = CGRectMake(30, 20, (SCREENWIDTH-180)/3,(2*SCREENWIDTH/3-20-80 )/2);
        [Btn2 setImage:[UIImage imageNamed:@"huiyuan"] forState:UIControlStateNormal];
        [view2 addSubview:Btn2];
        [self addSubview:view2];
        self.Btn2 = Btn2;
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(view1.width+view2.width+1, 0, 1, view1.width*2-20+1)];
        line2.backgroundColor = [UIColor grayColor];
        [self addSubview:line2];
        
        
        UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH*2/3+2, 0, SCREENWIDTH/3, SCREENWIDTH/3-10)];
        UIButton *Btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        Btn3.frame = CGRectMake(30, 20, (SCREENWIDTH-180)/3,(2*SCREENWIDTH/3-20-80 )/2);
        [Btn3 setImage:[UIImage imageNamed:@"shenji"] forState:UIControlStateNormal];
        [view3 addSubview:Btn3];
        [self addSubview:view3];
        self.Btn3 = Btn3;
        
        UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH/3+1, SCREENWIDTH/3, SCREENWIDTH/3-10)];
        UIButton *Btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        Btn4.frame = CGRectMake(30, 20, (SCREENWIDTH-180)/3,(2*SCREENWIDTH/3-20-80 )/2);
        [Btn4 setImage:[UIImage imageNamed:@"yanqi"] forState:UIControlStateNormal];
        [view4 addSubview:Btn4];
        [self addSubview:view4];
        self.Btn4 = Btn4;
        
        UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/3 +1, SCREENWIDTH/3 + 1, SCREENWIDTH/3, SCREENWIDTH/3-10)];
        UIButton *Btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        Btn5.frame = CGRectMake(30, 20, (SCREENWIDTH-180)/3,(2*SCREENWIDTH/3-20-80 )/2);
        [Btn5 setImage:[UIImage imageNamed:@"jici"] forState:UIControlStateNormal];
        [view5 addSubview:Btn5];
        [self addSubview:view5];
        self.Btn5 = Btn5;
        
        UIView *view6 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH*2/3+2, SCREENWIDTH/3 + 1, SCREENWIDTH/3, SCREENWIDTH/3-10)];
        UIButton *Btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Btn6 setImage:[UIImage imageNamed:@"tuihuo"] forState:UIControlStateNormal];
        Btn6.frame = CGRectMake(30, 20, (SCREENWIDTH-180)/3,(2*SCREENWIDTH/3-20-80 )/2);//Btn1.frame = CGRectMake(20, 20, (SCREENWIDTH-120)/3,(2*SCREENWIDTH/3-40-80 )/2);
        [view6 addSubview:Btn6];
        [self addSubview:view6];
        self.Btn6 = Btn6;
        
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, view1.height, self.width, 1)];
        line3.backgroundColor = [UIColor grayColor];
        
        UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, view6.height *2 + 1, self.width, 1)];
        line4.backgroundColor = [UIColor grayColor];
        line1.alpha = 0.3;
        line2.alpha = 0.3;
        line3.alpha = 0.3;
        line4.alpha = 0.3;
        [self addSubview:line4];
        [self addSubview:line3];
        
        
    }
    return self;
}
@end


