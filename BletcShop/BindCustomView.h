//
//  BindCustomView.h
//  BletcShop
//
//  Created by apple on 17/2/17.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindCustomView : UIView
@property(nonatomic,strong)UIView *AlertView;
@property(nonatomic,strong)UILabel *noticeLable;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *changeSuccessNotice;
@property(nonatomic,strong)UILabel *phoneLable;
@property(nonatomic,strong)UIButton *completeBtn;
-(instancetype)initWithFrame:(CGRect)frame;
@end
