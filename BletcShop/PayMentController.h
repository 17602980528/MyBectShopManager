//
//  UPGradeVC.h
//  BletcShop
//
//  Created by Bletc on 2016/11/19.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayMentController : UIViewController
/**
 卡的信息
 */
@property (nonatomic , strong) NSDictionary *card_dic;

@property(copy,nonatomic)NSString   *level;//卡的级别

@property(nonatomic,strong)NSMutableArray *resultArray;//点击升级按钮 返回数据

@property (nonatomic,retain)NSString *moneyString;

@property int orderInfoType;//1-买卡  2-续卡 3-充值 4-升级

@end
