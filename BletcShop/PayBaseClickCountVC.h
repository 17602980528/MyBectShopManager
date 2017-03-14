//
//  PayBaseClickCountVC.h
//  BletcShop
//
//  Created by apple on 17/3/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValuePickerView.h"
@interface PayBaseClickCountVC : UIViewController
@property(nonatomic,copy)NSString *selectedTime;
@property(nonatomic)NSInteger record;
@property(nonatomic,strong)UIView *bgView;
@property (nonatomic, strong) ValuePickerView *pickerView;
@end
