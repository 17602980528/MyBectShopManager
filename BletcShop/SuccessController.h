//
//  SuccessController.h
//  BletcShop
//
//  Created by Yuan on 16/2/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@interface SuccessController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView *picker;
    UIButton *button;
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    NSString *selectedProvince;
}

@property(nonatomic,copy)NSString *phoneNum;
@property(nonatomic,copy)NSString *passWord;
@property (nonatomic,retain)UIView *demoView;
@property int witchView;
@property (nonatomic,retain)UIToolbar *toolbarCancelDone;
@end
