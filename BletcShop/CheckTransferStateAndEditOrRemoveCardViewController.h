//
//  CheckTransferStateAndEditOrRemoveCardViewController.h
//  BletcShop
//
//  Created by apple on 17/1/11.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckTransferStateAndEditOrRemoveCardViewController : UIViewController
@property(nonatomic)NSInteger index;// 0 转让1 分享
@property(nonatomic,copy)NSString *disCount;
@property(nonatomic,copy)NSString *realMoney;
@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic)NSInteger state; // 0 从卡信息页面进入 1 从设置界面进入
@end
