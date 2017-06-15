//
//  NoVipCardCustomView.m
//  BletcShop
//
//  Created by apple on 2017/6/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NoVipCardCustomView.h"

@implementation NoVipCardCustomView
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        self.bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //self.bgImageView.backgroundColor=RGB(235, 235, 235);
        self.bgImageView.layer.cornerRadius=5.0f;
        self.bgImageView.clipsToBounds=YES;
        self.bgImageView.image=[UIImage imageNamed:@"abc_card"];
        [self addSubview:self.bgImageView];
        
        self.centerLable=[[UILabel alloc]init];
        self.centerLable.center=self.bgImageView.center;
        self.centerLable.bounds=CGRectMake(3, 0, self.bgImageView.width-6, 0.17*self.bgImageView.height);
        self.centerLable.backgroundColor=RGB(187, 194, 197);
        self.centerLable.font=[UIFont systemFontOfSize:17.0f];
        self.centerLable.textColor=[UIColor whiteColor];
        self.centerLable.textAlignment=NSTextAlignmentCenter;
        self.centerLable.text=@"提示：暂无会员卡";
        [self.bgImageView addSubview:self.centerLable];
        
        self.bottomLable=[[UILabel alloc]initWithFrame:CGRectMake(0,   self.centerLable.bottom+5, frame.size.width, 0.1*self.bgImageView.height)];
        self.bottomLable.backgroundColor=[UIColor clearColor];
        self.bottomLable.textAlignment=NSTextAlignmentCenter;
        self.bottomLable.font=[UIFont systemFontOfSize:12.0f];
        self.bottomLable.textColor=RGB(65, 65, 65);
        self.bottomLable.text=@"请点击右上角添加按钮进行添加";
        [self.bgImageView addSubview:self.bottomLable];
    }
    return self;
}
@end
