//
//  ShopUserInfoViewController.h
//  BletcShop
//
//  Created by Bletc on 16/6/23.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
@interface ShopUserInfoViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource,CustomIOSAlertViewDelegate,UITextFieldDelegate>
@property(nonatomic,weak)UITableView *Mytable;
@property (nonatomic,retain)CustomIOSAlertView *alertView;
@property NSInteger selectRow;//选择行

@property (nonatomic,retain)UITextField *addressText;
@property (nonatomic,retain)UITextField *pswText;
@property (nonatomic,retain)UITextField *pswdText;
@property (nonatomic,retain)UITextField *oldPswText;
@end
