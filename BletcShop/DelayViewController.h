//
//  DelayViewController.h
//  BletcShop
//
//  Created by Bletc on 16/4/13.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DelayViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,weak)UITableView *myTable;
@property (nonatomic) NSString *orderDate;
@property (nonatomic,retain)UITextField *startText;
@property (nonatomic,retain)UITextField *endText;
@property (nonatomic,retain)UIDatePicker *datePicker;
@property (nonatomic,retain)UIPickerView *customPicker;
@property (nonatomic,retain)UIToolbar *toolbarCancelDone;



/**
 卡的信息
 */
@property (nonatomic , strong) NSDictionary *card_dic;

@end
