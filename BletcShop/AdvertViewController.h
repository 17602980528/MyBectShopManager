//
//  AdvertViewController.h
//  BletcShop
//
//  Created by Bletc on 16/4/19.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
@interface AdvertViewController : UIViewController<CustomIOSAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationBarDelegate>
@property (nonatomic,retain) UITableView *myTableView;
@property (nonatomic,retain)UISegmentedControl *segmentControl;
@property(nonatomic,weak)UIScrollView *Bjsc;//背景滑动视图
@property (nonatomic,retain)NSString *quyuString;
@property (nonatomic,retain)UILabel *quyuLabel;//区域
@property (nonatomic,strong)UIPickerView* pickerView;
@property (nonatomic,retain)NSArray *areaArray;
@property BOOL isFullScreen;
@property (nonatomic,retain)UIImageView *imageView;
@property (nonatomic,retain)UITextField *startText;
@property (nonatomic,retain)UITextField *onLionText;
//时间选择
@property (nonatomic,retain)UIDatePicker *datePicker;

@property (nonatomic,retain)UIPickerView *customPicker;
@property (nonatomic,retain)UIToolbar *toolbarCancelDone;


@property (nonatomic , strong) UIToolbar *toolbar;// for 广告位
@property (nonatomic , strong) UILabel *place_lab;



@property (nonatomic,strong)UIPickerView *customPickerOnLine;
@property (nonatomic,retain)UIToolbar *toolbarCancelDoneOnLine;
@property (nonatomic,retain)NSArray *onLineDay;
@property (nonatomic,retain)NSArray *onLineHour;
@property (nonatomic,retain)UITextField *zaixianText;

@property BOOL ifTextYear;

//广告弹出视图
@property (nonatomic,retain)UIView *demoView;

@property (nonatomic,retain)UITextField *startText1;
@property (nonatomic,retain)UITextField *onLionText1;
@property BOOL ifoneView;
@property (nonatomic,retain)CustomIOSAlertView *alertView;
@property int indexPathRow;
//二级广告弹出视图
@property (nonatomic,retain)UILabel *placeLabel;//广告位
@property (nonatomic,retain)UITextField *startText2;
@property (nonatomic,retain)UITextField *onLionText2;
@property (nonatomic,retain)UITextField *contentText2;
@property (nonatomic,retain)UIPickerView *placePickerView;
@property (nonatomic,retain)NSArray *placeArray;

//是否打开地区选择
@property BOOL ifArea;
//广告选择是否打开
@property BOOL ifPlace;

@end
