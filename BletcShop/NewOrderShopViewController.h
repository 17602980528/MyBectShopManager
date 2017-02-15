//
//  NewOrderShopViewController.h
//  BletcShop
//
//  Created by apple on 16/12/17.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewOrderShopViewController : UIViewController

@property (nonatomic,retain) UITableView *myTableView;
@property (nonatomic , strong) NSMutableArray *wait_A;// 待确认
@property (nonatomic , strong) NSMutableArray *sure_A;// 已确认
@property (nonatomic , strong) NSMutableArray *confuse_A;// 已拒绝
@property (nonatomic , strong) NSMutableArray  *data_A;// 数据源数组
@property NSInteger selectTag;

@end
