//
//  ExperienceCardGoToPayVC.h
//  BletcShop
//
//  Created by Bletc on 2017/6/28.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExperienceCardGoToPayVC : UIViewController
@property (nonatomic,copy) void (^refresheDate)();// 返回时刷新数据

@property (nonatomic , strong) NSDictionary *card_dic;// <#Description#>

@end
