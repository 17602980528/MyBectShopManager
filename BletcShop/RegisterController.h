//
//  RegisterController.h
//  BletcShop
//
//  Created by Yuan on 16/2/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"

@interface RegisterController : UIViewController<UITextFieldDelegate,CustomIOSAlertViewDelegate>
@property(nonatomic,weak)UIButton *getCodeBtn;

@property(nonatomic,weak)UIButton *valBtn;
@end
