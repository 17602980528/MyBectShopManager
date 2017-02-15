//
//  ChoiceAdminAlertView.m
//  BletcShop
//
//  Created by Bletc on 16/8/9.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ChoiceAdminAlertView.h"

@implementation ChoiceAdminAlertView
-(id)init{
    self=[super init];
    if (self) {
        self.layer.cornerRadius = 8;
        
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-20, 51)];
        label.backgroundColor = [UIColor colorWithRed:28.0f/255.0f green:52.0f/255.0f blue:51.f/255.0f alpha:1.0f];
        label.textColor = [UIColor whiteColor];
        label.text=@"登录身份";
        label.textAlignment=1;
        label.font=[UIFont systemFontOfSize:21.0f];
        [self addSubview:label];
        
        
        
        

        UIView *regiestView=[[UIView alloc]initWithFrame:CGRectMake(0, 50, (SCREENWIDTH-20)/2, 60)];
        regiestView.backgroundColor = [UIColor colorWithRed:28.0f/255.0f green:52.0f/255.0f blue:51.f/255.0f alpha:1.0f];
        [self addSubview:regiestView];
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 1)];
        line.backgroundColor=[UIColor whiteColor];
        line.alpha=0.3;
        [label addSubview:line];
        UIView *otherView=[[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-20)/2, 50, (SCREENWIDTH-20)/2, 60)];
        otherView.backgroundColor = [UIColor colorWithRed:28.0f/255.0f green:52.0f/255.0f blue:51.f/255.0f alpha:1.0f];
        [self addSubview:otherView];
        UIImageView *image1=[[UIImageView alloc]initWithFrame:CGRectMake(50, 10, 40, 40)];
        image1.image=[UIImage imageNamed:@"register_p"];
        [regiestView addSubview:image1];
       
        //注册人
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(100, 5, (SCREENWIDTH-20)/2-100, 50)];
        
        label1.textColor = [UIColor whiteColor];
        label1.text=@"注册人";
        label1.textAlignment=0;
        label1.font=[UIFont systemFontOfSize:16.0f];
        [regiestView addSubview:label1];
        label1.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRegiest)];
        [label1 addGestureRecognizer:gesture3];
        UITapGestureRecognizer *gesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRegiest)];
        image1.userInteractionEnabled = YES;
        [image1 addGestureRecognizer:gesture2];
        //管理员
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(100, 5, (SCREENWIDTH-20)/2-100, 50)];
        
        label2.textColor = [UIColor whiteColor];
        label2.text=@"管理员";
        label2.textAlignment=0;
        label2.font=[UIFont systemFontOfSize:16];
        [otherView addSubview:label2];
        label2.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAdmin)];
        [label2 addGestureRecognizer:gesture4];
        
        
        UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(50, 10, 40, 40)];
        image2.image=[UIImage imageNamed:@"admin_p"];
        [otherView addSubview:image2];
        image2.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture5=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAdmin)];
        [image2 addGestureRecognizer:gesture5];
        UIView *line2=[[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-20)/2, 55, 1, 50)];
        line2.backgroundColor=[UIColor whiteColor];
        line2.alpha=0.3;
        [regiestView addSubview:line2];
        
        if (SCREENWIDTH==320) {
            image1.frame =  CGRectMake(50-15, 10, 40, 40);
            image2.frame = image1.frame;
            
            label1.frame=CGRectMake(100-15, 5, (SCREENWIDTH-20)/2-100, 50);
            label2.frame = label1.frame;
        }
        
   }
    return self;
}
-(void)tapRegiest
{
    _state=0;
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(ChoiceAdminClick:)]) {
        [_delegate ChoiceAdminClick:_state];
    }
}
-(void)tapAdmin
{
    _state=1;
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(ChoiceAdminClick:)]) {
        [_delegate ChoiceAdminClick:_state];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
