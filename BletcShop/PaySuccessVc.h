//
//  PaySuccessVc.h
//  BletcShop
//
//  Created by Bletc on 2016/11/23.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySuccessVc : UIViewController
@property int orderInfoType;//1-买卡  2-续卡 3-充值 4-升级
/**
 卡的信息
 */
@property (nonatomic , strong) NSDictionary *card_dic;

@property (nonatomic,copy)NSString *type_new;// 新的等级;

@property (nonatomic,copy)NSString *money_str;// 金额;


@end
