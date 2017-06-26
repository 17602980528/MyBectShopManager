//
//  TimeLimitVipCardVC.h
//  BletcShop
//
//  Created by apple on 2017/6/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLimitVipCardVC : UIViewController

/**
 卡的信息
 */
@property (nonatomic , strong) NSDictionary *card_dic;


@property(nonatomic,copy)  void(^block)();
@end
