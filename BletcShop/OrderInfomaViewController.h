//
//  OrderInfomaViewController.h
//  BletcShop
//
//  Created by Bletc on 16/7/27.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
enum OrderTypes{
    points,
    Wares
};
@interface OrderInfomaViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
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

@end
