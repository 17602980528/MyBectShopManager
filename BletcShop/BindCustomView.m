//
//  BindCustomView.m
//  BletcShop
//
//  Created by apple on 17/2/17.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "BindCustomView.h"

@implementation BindCustomView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:0.4];
        self.AlertView=[[UIView alloc]init];
        self.AlertView.backgroundColor=[UIColor whiteColor];
        self.AlertView.bounds=CGRectMake(0, 0, SCREENWIDTH-50, 224*(SCREENWIDTH-50)/325.0);
        self.AlertView.center=CGPointMake(self.center.x, self.center.y-74);//self.center;
        [self addSubview:self.AlertView];
        
        CGFloat alertViewWidth=self.AlertView.frame.size.width;
        CGFloat alertViewHeight=self.AlertView.frame.size.height;
        
        self.noticeLable=[[UILabel alloc]init];
        self.noticeLable.frame=CGRectMake(0, 0, alertViewWidth,36*alertViewHeight/224.0 );
        self.noticeLable.backgroundColor=RGB(234, 234, 234);
        self.noticeLable.textAlignment=NSTextAlignmentCenter;
        self.noticeLable.text=@"温馨提示";
        self.noticeLable.textColor=RGB(102, 102, 102);
        [self.AlertView addSubview:self.noticeLable];
        self.imageView=[[UIImageView alloc]init];
        self.imageView.image=[UIImage imageNamed:@"勾选"];
        self.imageView.frame=CGRectMake(alertViewWidth/2.0-(45*alertViewHeight/224.0)/2, self.noticeLable.bottom+10*alertViewHeight/224.0, 45*alertViewHeight/224.0, 45*alertViewHeight/224.0);
        [self.AlertView addSubview:self.imageView];
        
        self.changeSuccessNotice=[[UILabel alloc]initWithFrame:CGRectMake(0, self.imageView.bottom+10*alertViewHeight/224.0, alertViewWidth, 16*alertViewHeight/224.0)];
        self.changeSuccessNotice.textAlignment=NSTextAlignmentCenter;
        self.changeSuccessNotice.text=@"手机号码修改成功";
        self.changeSuccessNotice.textColor=RGB(51, 51, 51);
        [self.AlertView addSubview:self.changeSuccessNotice];
        
        self.phoneLable=[[UILabel alloc]init];
        self.phoneLable.frame=CGRectMake(0, self.changeSuccessNotice.bottom+11*alertViewHeight/224.0, alertViewWidth, 13*alertViewHeight/224.0);
        self.phoneLable.textAlignment=NSTextAlignmentCenter;
        self.phoneLable.textColor=RGB(51, 51, 51);
        self.phoneLable.text=@"您的新手机号：18702968352";
        self.phoneLable.font=[UIFont systemFontOfSize:14.0f];
        [self.AlertView addSubview:self.phoneLable];
        
        self.completeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.completeBtn.frame=CGRectMake(50*alertViewWidth/325.0, self.phoneLable.bottom+21*alertViewHeight/224.0f,alertViewWidth-100*alertViewWidth/325.0 , 44*alertViewHeight/224.0);
        [self.completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        self.completeBtn.backgroundColor=RGB(0, 162, 255);
        [self.completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.completeBtn.titleLabel.font=[UIFont systemFontOfSize:18.0f];
        [self.AlertView addSubview:self.completeBtn];
        
    }
    return self;
}
@end
