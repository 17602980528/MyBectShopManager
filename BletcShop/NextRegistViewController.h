//
//  NextRegistViewController.h
//  BletcShop
//
//  Created by Bletc on 16/4/1.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
@interface NextRegistViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CustomIOSAlertViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,retain)NSMutableArray *tradeArray;
@property (nonatomic,retain)UILabel *choiceTradeLabel;//所属行业
@property (nonatomic,retain)NSString *tradeString;
@property (nonatomic,retain)UITableView *listTable;

@property(nonatomic,weak)UITextField *nibText;//昵称
@property(nonatomic,weak)UITextField *personText;//推荐人
@property(nonatomic,weak)UITextField *addressText;//店铺地址
@property(nonatomic,weak)UITextField *shopNameText;//店铺名称
@property (nonatomic,retain)UILabel *cityLabel;//所属省市区
@property (nonatomic,retain)NSString *phoneString;//手机号
@property (nonatomic,retain)NSString *pswString;//密码
@property BOOL ifOpen;

@property (nonatomic,retain)UIView *landView;

@property (nonatomic,retain)UIView *demoView;
@end
