//
//  OrderViewController.h
//  BletcShop
//
//  Created by Bletc on 16/5/19.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,weak)UITextField *orderClassLable;//预约项目lable
@property(nonatomic,weak)UITextField *orderDateLable;//日期
@property(nonatomic,weak)UITextField *orderTimeLable;//时间
@property(nonatomic,retain)NSMutableArray *allClassArray;//可预约项目
@property(nonatomic,retain)NSMutableArray *timeArray;//可预约时间
//@property BOOL ifOrderDate;
//日期
@property (nonatomic,retain)UIPickerView *customPicker;
@property (nonatomic,retain)UIToolbar *toolbarCancelDone;


/**
 卡的信息
 */
@property (nonatomic , strong) NSDictionary *card_dic;

@end
