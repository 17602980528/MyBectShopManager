//
//  CustomeAlertView.m
//  BletcShop
//
//  Created by apple on 16/7/23.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CustomeAlertView.h"

@implementation CustomeAlertView

-(id)init{
    self=[super init];
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
        
        _view1=[[UIView alloc]initWithFrame:CGRectMake(0, 81, SCREENWIDTH, 80)];
        _view1.backgroundColor=[UIColor grayColor];
        
        _lab1=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 80, 40)];
        _lab1.textAlignment=1;
        //_lab1.textColor=[UIColor cyanColor];
        _lab1.text=@"版式1";
        _lab1.userInteractionEnabled=YES;
        [_view1 addSubview:_lab1];
        
        UITapGestureRecognizer *gesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1:)];
        
        [_view1 addGestureRecognizer:gesture1];
    
        
        UIImageView *image1=[[UIImageView alloc]initWithFrame:CGRectMake(100, 5, SCREENWIDTH-100-10, 70)];
        image1.image=[UIImage imageNamed:@"custom1"];
        [_view1 addSubview:image1];
        [self addSubview:_view1];
        
        _view2=[[UIView alloc]initWithFrame:CGRectMake(0, 161, SCREENWIDTH, 80)];
        //view2.backgroundColor=[UIColor blueColor];
        
        _lab2=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 80, 40)];
        _lab2.textAlignment=1;
        _lab2.text=@"版式2";
        _lab2.userInteractionEnabled=YES;
        [_view2 addSubview:_lab2];
        UITapGestureRecognizer *gesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2:)];
        [_view2 addGestureRecognizer:gesture2];
        
        UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(100, 5, SCREENWIDTH-100-10, 70)];
        image2.image=[UIImage imageNamed:@"custom2"];
        [_view2 addSubview:image2];
        [self addSubview:_view2];
        
        _view3=[[UIView alloc]initWithFrame:CGRectMake(0, 241, SCREENWIDTH, 80)];
        
        _lab3=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 80, 40)];
        _lab3.textAlignment=1;
        _lab3.text=@"版式3";
        _lab3.userInteractionEnabled=YES;
        [_view3 addSubview:_lab3];
        UITapGestureRecognizer *gesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap3:)];
        [_view3 addGestureRecognizer:gesture3];
        
        UIImageView *image3=[[UIImageView alloc]initWithFrame:CGRectMake(100, 5, SCREENWIDTH-100-10, 70)];
        image3.image=[UIImage imageNamed:@"custom3"];
        [_view3 addSubview:image3];
        [self addSubview:_view3];
        
        
        _view4=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_view3.frame), SCREENWIDTH, 80)];
        
        _lab4=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 80, 40)];
        _lab4.textAlignment=1;
        _lab4.text=@"版式4";
        _lab4.userInteractionEnabled=YES;
        [_view4 addSubview:_lab4];
        
        UITapGestureRecognizer *gesture4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap4:)];
        [_view4 addGestureRecognizer:gesture4];
        
        UIImageView *image4=[[UIImageView alloc]initWithFrame:CGRectMake(100, 5, SCREENWIDTH-100-10, 70)];
        image4.image=[UIImage imageNamed:@"custom4.jpg"];
        [_view4 addSubview:image4];
        [self addSubview:_view4];
        
        
        UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_view4.frame)+5, SCREENWIDTH-20, 1)];
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
//    _lab1.text=@"版式1";
//    _lab2.text=@"版式2";
//    _lab3.text=@"版式3";
    //_lab2.textColor=[UIColor blackColor];
    //_lab3.textColor=[UIColor blackColor];
    //_lab1.text=@"已选中";
    //_lab1.textColor=[UIColor cyanColor];
    _state=0;
    _view1.backgroundColor=[UIColor grayColor];
    _view2.backgroundColor=[UIColor whiteColor];
    _view3.backgroundColor=[UIColor whiteColor];
    _view4.backgroundColor=[UIColor whiteColor];

}

-(void)tap2:(UITapGestureRecognizer *)gesture{
//    _lab1.text=@"版式1";
//    _lab2.text=@"版式2";
//    _lab3.text=@"版式3";
    //_lab1.textColor=[UIColor blackColor];
    //_lab3.textColor=[UIColor blackColor];
   // _lab2.text=@"已选中";
    //_lab2.textColor=[UIColor cyanColor];
    _state=1;
    _view2.backgroundColor=[UIColor grayColor];
    _view1.backgroundColor=[UIColor whiteColor];
    _view3.backgroundColor=[UIColor whiteColor];
    _view4.backgroundColor=[UIColor whiteColor];

}
-(void)tap3:(UITapGestureRecognizer *)gesture{
//    _lab1.text=@"版式1";
//    _lab2.text=@"版式2";
//    _lab3.text=@"版式3";
    //_lab2.textColor=[UIColor blackColor];
    //_lab1.textColor=[UIColor blackColor];
    //_lab3.text=@"已选中";
    //_lab3.textColor=[UIColor cyanColor];
    _state=2;
    _view3.backgroundColor=[UIColor grayColor];
    _view1.backgroundColor=[UIColor whiteColor];
    _view2.backgroundColor=[UIColor whiteColor];
    _view4.backgroundColor=[UIColor whiteColor];


}

-(void)tap4:(UITapGestureRecognizer *)gesture{
    //    _lab1.text=@"版式1";
    //    _lab2.text=@"版式2";
    //    _lab3.text=@"版式3";
    //_lab2.textColor=[UIColor blackColor];
    //_lab1.textColor=[UIColor blackColor];
    //_lab3.text=@"已选中";
    //_lab3.textColor=[UIColor cyanColor];
    _state=3;
    _view4.backgroundColor=[UIColor grayColor];
    _view1.backgroundColor=[UIColor whiteColor];
    _view2.backgroundColor=[UIColor whiteColor];
    _view3.backgroundColor=[UIColor whiteColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
