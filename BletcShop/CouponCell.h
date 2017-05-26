//
//  CouponCell.h
//  BletcShop
//
//  Created by Bletc on 2017/3/3.
//  Copyright © 2017年 bletc. All rights reserved.
//


static NSString *identifier = @"couponCellId";
#import <UIKit/UIKit.h>


@interface CouponCell : UITableViewCell

@property(nonatomic,strong)CAGradientLayer *gradientLayer;


@property (nonatomic , strong) UILabel *shopNamelab;// 店名

@property (nonatomic , strong) UILabel *couponMoney;// 价格
@property (nonatomic , strong) UILabel *deadTime;// 限制时间
@property (nonatomic , strong) UILabel *limitLab;// 满多少可用
@property (nonatomic , strong) UIImageView *headImg;// 头像
@property (nonatomic , strong) UIImageView *showImg;// 过期
@property (nonatomic , strong) UIImageView *onlineState;//线上线下
+(instancetype)couponCellWithTableView:(UITableView*)tableView;

@end
