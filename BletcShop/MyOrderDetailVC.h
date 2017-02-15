//
//  MyOrderDetailVC.h
//  BletcShop
//
//  Created by Bletc on 2016/11/22.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderDetailVC : UIViewController
@property (nonatomic , strong) NSDictionary *order_dic;// 订单信息
@property (nonatomic,copy)NSString *allPay;// 支付总额
@property (nonatomic,copy)NSString *pay_type_s;// 消费类型,计次还是金额.


@end
