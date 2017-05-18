//
//  ShopRegisterController.h
//  BletcShop
//
//  Created by Yuan on 16/3/15.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopRegisterController : UIViewController<UITextFieldDelegate,CustomIOSAlertViewDelegate,UIAlertViewDelegate>
{
    UIActivityIndicatorView *activity;
}

@property(nonatomic,strong)UITextField *phoneText;
@property(nonatomic,strong)UITextField *proText;
@property(nonatomic,strong)UITextField *passwordText;
@property(nonatomic,strong)UITextField *passwordText2;
//@property(nonatomic,strong)UITextField *showQuanTextfield;
@property(nonatomic,strong)UIButton *getCodeBtn;
@property(nonatomic,strong)UIButton *valBtn;
@property BOOL ifCIASuccess;
@property (nonatomic,strong)UIView *demoView;
@property (nonatomic , strong) NSArray *data_code;

@end
