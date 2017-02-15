//
//  CardManagerViewController.h
//  BletcShop
//
//  Created by Bletc on 16/4/13.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardManagerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *CardInfotable;

@property (nonatomic,retain)NSMutableArray *cardInfoArray2;

/**
卡的信息
 */
@property (nonatomic , strong) NSDictionary *card_dic;

@end
