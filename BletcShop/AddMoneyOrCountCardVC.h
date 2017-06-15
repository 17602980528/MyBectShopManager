//
//  AddMoneyOrCountCardVC.h
//  BletcShop
//
//  Created by Bletc on 2017/6/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMoneyOrCountCardVC : UIViewController

typedef void(^reloadAPIBlock)();

@property (nonatomic,copy)NSString *cardTypeName;// 添加计次还是储值卡
@property (nonatomic , strong) NSDictionary *series_dic;// 所选择的系列
@property (nonatomic , strong) NSDictionary *card_dic;// 会员卡的信息,修改时用来传值
@property (nonatomic,copy)reloadAPIBlock block;// 刷新数据

@property (nonatomic,copy)NSString *whoPush;// <#Description#>

@end
