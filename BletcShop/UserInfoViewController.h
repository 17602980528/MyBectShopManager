//
//  UserInfoViewController.h
//  BletcShop
//
//  Created by Bletc on 16/4/12.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
#import "NewModelImageViewController.h"
@interface UserInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CustomIOSAlertViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NewModelImageViewControllerDelegate>
@property(nonatomic,weak)UITableView *Mytable;
@property (nonatomic,retain)CustomIOSAlertView *alertView;
@property (nonatomic,retain)UITextField *nameText;
@property NSInteger selectRow;
@property (nonatomic,retain) UIButton *boyBtn;
@property (nonatomic,retain) UIButton *girlBtn;
@property (nonatomic,retain)UITextField *ageText;
@property (nonatomic,retain)UITextField *pswText;
@property (nonatomic,retain)UITextField *pswdText;
@property (nonatomic,retain)UITextField *oldPswText;
@property (nonatomic,retain)UIImageView *imageView;
//时间
@property (nonatomic,retain)UIPickerView *customPicker;
@property (nonatomic,retain)UIToolbar *toolbarCancelDone;
@property BOOL isFullScreen;
@property long long int date;//发送图片的时间戳
@property (nonatomic , strong) UIImageView *backGroundImageView;// <#Description#>

@end
