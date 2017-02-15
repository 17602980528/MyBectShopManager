//
//  DelayShopViewController.h
//  BletcShop
//
//  Created by Bletc on 16/5/6.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
@interface DelayShopViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,retain) UITableView *myTableView;

@property (nonatomic , strong) NSMutableArray *wait_A;// 待确认
@property (nonatomic , strong) NSMutableArray *sure_A;// 已确认
@property (nonatomic , strong) NSMutableArray *confuse_A;// 已拒绝


@property (nonatomic , strong) NSMutableArray  *data_A;// 数据源数组

@property NSInteger selectTag;
@end
