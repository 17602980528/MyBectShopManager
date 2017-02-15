//
//  BindBankCardViewController.h
//  BletcShop
//
//  Created by Bletc on 16/6/17.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
@interface BindBankCardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CustomIOSAlertViewDelegate>
@property(nonatomic,retain)UIView *myView;
@property(nonatomic,retain)NSMutableArray *cardArray;//
@property(nonatomic,weak)UILabel *cardNumLable;//卡号
@property(nonatomic,weak)UILabel *openLable;//开户行

//@property BOOL ifOrderTime;

@property(nonatomic,weak)UITableView *Cardtable;
@property(nonatomic,strong)NSArray *data;

@property (nonatomic,retain)UIView *demoView;
@property (nonatomic,retain)UITextField *nameText;
@property (nonatomic,retain)UITextField *openBankText;
@property (nonatomic,retain)UITextField *cardNumText;
@end
