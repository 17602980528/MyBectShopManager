//
//  NewChangePsWordViewController.h
//  BletcShop
//
//  Created by apple on 16/11/19.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewChangePsWordViewController : UIViewController
@property (nonatomic,copy)NSString *type_login;// 用户 OR 商户

@property (nonatomic,strong)UITextField *oldPswText;
@property (nonatomic,strong)UITextField *pswdText;
@end
