//
//  ShopLandController.h
//  BletcShop
//
//  Created by Yuan on 16/3/15.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoiceAdminAlertView.h"

@interface ShopLandController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic,retain)NSArray* personInfoArray;
@property(nonatomic,weak)UIButton *getCodeBtn;
@property(nonatomic,weak)UITextField *proText;
@property BOOL ifCIASuccess;
@property (nonatomic,assign) BOOL ifRemeber;
@property(nonatomic,weak)UIButton *valBtn;
@property(nonatomic)NSInteger state;
@property (nonatomic , strong) NSArray *data_code;

@property(nonatomic,weak)ChoiceAdminAlertView *choiceAlertView;
@end
