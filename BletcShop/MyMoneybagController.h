//
//  MyMoneybagController.h
//  BletcShop
//
//  Created by Yuan on 16/1/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HOST_IP @"192.168.0.117"
#define HOST_PORT 30001
#import "CustomIOSAlertView.h"
@interface MyMoneybagController : UIViewController<CustomIOSAlertViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic,retain)CustomIOSAlertView *alertView;

@property (nonatomic,retain)UITextField *moneyText;
@property (nonatomic,retain)UIView *demoView;
@property (nonatomic,retain)NSString *moneyString;
@property(nonatomic,weak)UITableView *myTable;

@property(nonatomic,strong)NSMutableArray *bankArray;
@property int choiceTag;

@end
