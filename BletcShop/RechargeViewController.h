//
//  RechargeViewController.h
//  BletcShop
//
//  Created by Bletc on 16/4/13.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"

@interface RechargeViewController : UIViewController<UITextFieldDelegate>
@property(nonatomic,strong)UILabel *moneyText;


/**
 卡的信息
 */
@property (nonatomic , strong) NSDictionary *card_dic;

@end
