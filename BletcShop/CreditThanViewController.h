//
//  CreditThanViewController.h
//  BletcShop
//
//  Created by Bletc on 16/6/17.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
@interface CreditThanViewController : UIViewController
@property(nonatomic,retain)UIView *myView;
@property(nonatomic,retain)NSMutableArray *moneyArray;//
@property(nonatomic,weak)UILabel *nowLable;//
@property(nonatomic,weak)UILabel *shengyuLable;//
@property(nonatomic,weak)UILabel *tixianLable;//
@property(nonatomic,strong)NSDictionary *data_dic;//


@end
