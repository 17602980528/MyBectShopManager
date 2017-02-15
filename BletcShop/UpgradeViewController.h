//
//  UpgradeViewController.h
//  BletcShop
//
//  Created by Bletc on 16/4/13.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpgradeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property(nonatomic,weak)UITableView *myTable;
@property (nonatomic,retain)NSString *cardType;//卡要提升的的级别
@property(nonatomic,retain)NSMutableArray *pickArray;

@property(nonatomic,retain)NSMutableArray *resultArray;//点击升级按钮 返回数据
@property(nonatomic,weak)UILabel *cardLable;
@property(nonatomic,retain)UIPickerView* cardTypePickerView;
@property BOOL ifCard;
@property(nonatomic,retain)NSDictionary *cardNow_dic;//当前卡级别及金额
@property(nonatomic,retain)UILabel *moneyText;//当前卡级别及金额
@property(nonatomic,retain)NSString *adviceString;//提示
@property(nonatomic,retain)UITextView *adviceText;//当前卡级别及金额
@property(nonatomic,retain)NSMutableArray *otherArray;//超过本卡级别的卡

@property float cha;

/**
 卡的信息
 */
@property (nonatomic , strong) NSDictionary *card_dic;




@end
