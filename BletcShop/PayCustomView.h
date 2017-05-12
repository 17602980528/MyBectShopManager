//
//  PayCustomView.h
//  BletcShop
//
//  Created by apple on 2017/5/12.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPasswordView.h"
@interface PayCustomView : UIView
@property (nonatomic, strong) SYPasswordView *pasView;
@property (nonatomic,strong) UIButton *forgotButton;
@property (nonatomic,copy)NSString *pass;
@property (nonatomic,assign)id delegate;
@end
@protocol PayCustomViewDelegate <NSObject>

-(void)confirmPassRightOrWrong:(NSString *)pass;

@end
