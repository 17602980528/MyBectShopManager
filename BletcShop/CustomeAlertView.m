//
//  CustomeAlertView.m
//  BletcShop
//
//  Created by apple on 16/7/23.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CustomeAlertView.h"
#import "UIImageView+WebCache.h"

@interface CustomeAlertView ()
{
    UIView *oldView;
}

@end
@implementation CustomeAlertView


-(instancetype)initWithArray:(NSArray *)array{
    self = [super init];
    
    if (self) {
       
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-60, 10, 120, 60)];
        label.text=@"选择板式";
        label.textAlignment=1;
        label.font=[UIFont systemFontOfSize:21.0f];
        [self addSubview:label];
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 80, SCREENWIDTH-20, 1)];
        line.backgroundColor=[UIColor grayColor];
        line.alpha=0.3;
        [self addSubview:line];
        
        
        for (int i = 0; i <array.count; i ++) {
            
            NSDictionary *dic = array[i];
            
            
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 81+i*81, SCREENWIDTH, 80)];
            view.backgroundColor=[UIColor whiteColor];
            
            view.tag = [dic[@"id"] intValue];
            
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 80, 40)];
            lab.textAlignment=1;
            lab.text=dic[@"tip"];
            lab.userInteractionEnabled=YES;
            [view addSubview:lab];
            
            UITapGestureRecognizer *gesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1:)];
            
            [view addGestureRecognizer:gesture1];
            
            
            UIImageView *image1=[[UIImageView alloc]initWithFrame:CGRectMake(100, 5, SCREENWIDTH-100-10, 70)];
            NSURL*url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOP_INTRODUCE_IMAGE,dic[@"image_url"]]];
            [image1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon2"]];
            image1.backgroundColor=[UIColor whiteColor];
            [view addSubview:image1];
            [self addSubview:view];

            if (i==0) {
                oldView = view;
                view.backgroundColor = [UIColor grayColor];
                _state = view.tag;
            }
            
            
        }
        UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(10, (array.count+1)*81+5, SCREENWIDTH-20, 1)];
        line2.backgroundColor=[UIColor grayColor];
        line2.alpha=0.3;
        [self addSubview:line2];
        
        UIButton *button1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button1.frame=CGRectMake(SCREENWIDTH/2-80-30, CGRectGetMaxY(line2.frame), 80, 40);
        [button1 setTitle:@"确认" forState:UIControlStateNormal];
        button1.tag=1;
        [button1 addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];

        UIButton *button2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button2.frame=CGRectMake(SCREENWIDTH/2+30, CGRectGetMaxY(line2.frame), 80, 40);
        [button2 setTitle:@"取消" forState:UIControlStateNormal];
        button2.tag=2;
        [button2 addTarget:self action:@selector(btnClick2:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button1];
        [self addSubview:button2];
        
    }
    
    return self;
}

-(void)btnClick1:(UIButton *)btn{
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(ClickBtnAtIndex:state:)]) {
        [_delegate ClickBtnAtIndex:btn.tag state:_state];
    }
}
-(void)btnClick2:(UIButton *)btn{
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(ClickBtnAtIndex:state:)]) {
        [_delegate ClickBtnAtIndex:btn.tag state:_state];
    }
}

-(void)tap1:(UITapGestureRecognizer *)gesture{
    
    if (oldView !=gesture.view) {
        
        gesture.view.backgroundColor = [UIColor grayColor];
        oldView.backgroundColor = [UIColor whiteColor];
        
        _state =gesture.view.tag;
        
        
        oldView = gesture.view;
    }

    
}



@end
