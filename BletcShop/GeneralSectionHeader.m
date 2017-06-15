//
//  GeneralSectionHeader.m
//  BletcShop
//
//  Created by Bletc on 2017/6/6.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "GeneralSectionHeader.h"

@implementation GeneralSectionHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}
-(void)initSubviews{
    
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.bounds = CGRectMake(0, 0, 7, 14);
    imgView.center = CGPointMake(17.5, 44/2);
    imgView.image = [UIImage imageNamed:@"形状 2"];
    [self addSubview:imgView];
    self.leftImg = imgView;
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, SCREENWIDTH-65, 44)];
    titleLab.textColor = RGB(154,154,154);
    titleLab.text = @"系列1";
    titleLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLab];
    
    self.titleLab = titleLab;
    
    UIImageView *addImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-15-14, (44-15)/2, 15, 15)];
    addImg.image = [UIImage imageNamed:@"lzdAddCardImg"];
    
    [self addSubview:addImg];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREENWIDTH-50, 0, 50, 44);
    [self addSubview:btn];
    
    self.addBtn = btn;

    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 44-1, SCREENWIDTH, 1)];
    line.backgroundColor = RGB(217,217,217);
    [self addSubview:line];
}

-(void)setFold:(BOOL)fold{
    
    _fold = fold;
    
    if (fold) {
        self.leftImg.image = [UIImage imageNamed:@"形状 2"];
        self.leftImg.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.titleLab.textColor = RGB(226,102,102);

    }else{
        self.leftImg.image = [UIImage imageNamed:@"形状 1 拷贝"];
        self.titleLab.textColor = RGB(154,154,154);
        self.leftImg.transform = CGAffineTransformMakeRotation(0);



    }
}
@end
