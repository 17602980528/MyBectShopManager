//
//  MoneyBagChoiceTypeViewController.h
//  BletcShop
//
//  Created by Bletc on 16/7/12.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyBagChoiceTypeViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)UITableView *myTable;
@property (nonatomic,retain)NSMutableArray *imageArr;
@property (nonatomic,retain)NSMutableArray *nameArr;
@property (nonatomic,retain)NSString *moneyString;
@property (nonatomic,retain)NSString *pay_Type;//（支付类型）=> “null"（不抵额）,"voucher”（用代金卷抵额）,“integral”（用乐点抵额）
@property (nonatomic,retain)NSString *actualMoney;//实付金额
@property (nonatomic,retain)NSMutableArray *couponArr;//所选代金券

@property (nonatomic , strong) NSDictionary *coup_dic;// 所选代金券

@property (nonatomic,retain)NSString *point;//所使用的乐点
@end
