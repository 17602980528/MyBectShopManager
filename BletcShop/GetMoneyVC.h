//
//  GetMoneyVC.h
//  BletcShop
//
//  Created by Bletc on 16/9/20.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^GetMoneyVCBlock)();

@interface GetMoneyVC : UIViewController
@property (nonatomic,copy)NSString *sum_string;//可提取余额
@property (nonatomic,copy)NSString *acount;//卡号
@property (nonatomic,copy)GetMoneyVCBlock block;//


@end
