//
//  PayCustomView.m
//  BletcShop
//
//  Created by apple on 2017/5/12.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PayCustomView.h"

@implementation PayCustomView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:0.3];
        UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-450, frame.size.width, 450)];
        whiteView.backgroundColor=[UIColor whiteColor];
        [self addSubview:whiteView];
        
        UIImageView *imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"card_icon_close"]];
        imageview.frame=CGRectMake(20, 12.5, 15, 15);
        [whiteView addSubview:imageview];
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        title.text=@"请输入支付密码";
        title.textAlignment=NSTextAlignmentCenter;
        [whiteView addSubview:title];
        
        UIButton *dismissButton=[UIButton buttonWithType:UIButtonTypeCustom];
        dismissButton.frame=title.frame;
        [dismissButton addTarget:self action:@selector(dismissCustomView) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:dismissButton];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, dismissButton.bottom, dismissButton.frame.size.width, 1)];
        lineView.backgroundColor=RGB(234, 234, 234);
        [whiteView addSubview:lineView];
        
        _pasView = [[SYPasswordView alloc] initWithFrame:CGRectMake(15, 70, frame.size.width - 30, 45)];
        _pasView.delegate=self;
        [_pasView.textField becomeFirstResponder];
        [whiteView addSubview:_pasView];
        
        _forgotButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _forgotButton.frame=CGRectMake(_pasView.right-120, _pasView.bottom+5, 120, 30);
        [_forgotButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [_forgotButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [whiteView addSubview:_forgotButton];
        _forgotButton.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        
    }
    return self;
}
-(void)passLenghtEqualsToSix:(NSString *)pass{
    self.pass=pass;
    if ([_delegate respondsToSelector:@selector(confirmPassRightOrWrong:)]) {
        [_delegate confirmPassRightOrWrong:pass];
    }
}
-(void)observationPassLength:(NSString *)pwd{
    
}
-(void)dismissCustomView{
    [self removeFromSuperview];
}
@end
