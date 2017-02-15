//
//  NewBuyCardViewController.h
//  BletcShop
//
//  Created by apple on 16/11/16.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
enum OrderTypes{
    points,
    Wares
};
@interface NewBuyCardViewController : UIViewController
@property (nonatomic,retain)UITableView *myTable;

@property (nonatomic,retain)NSString *moneyString;
@property int orderInfoType;//1-买卡  2-续卡 3-充值 4-升级
@property enum OrderTypes Type;

@property (nonatomic,retain)NSString *allPoint;
@property float canUsePoint;
@property (nonatomic,retain)NSString *userCouponPrice;
@property (nonatomic,retain)UILabel *contentLabel;

@property (nonatomic , strong) NSDictionary *coup_dic;// 优惠券信息

@property (nonatomic , strong) NSDictionary *card_dic;// 卡的信息
@property(nonatomic,strong)NSArray *cardListArray;

@property(nonatomic,copy)NSString *pay_Type;

@property (nonatomic,copy)NSString *shop_name;// 店名

@end
