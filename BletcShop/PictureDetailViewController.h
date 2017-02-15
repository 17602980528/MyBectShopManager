//
//  PictureDetailViewController.h
//  BletcShop
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
#import "UIImageView+WebCache.h"
@interface PictureDetailViewController : UIViewController<CustomIOSAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,retain) UITableView *myTableView;
@property(nonatomic,weak)UIScrollView *Bjsc;//背景滑动视图
@property(nonatomic,weak)UIScrollView *listView;
@property(nonatomic,strong)NSArray *data;
@property(nonatomic,weak)UIView *listView1;
@property(nonatomic,weak)UIView *NewView;
@property(nonatomic,weak)UIView *TopView;

@property (nonatomic,retain)CustomIOSAlertView *alertView;
@property (nonatomic,retain)UIView *demoView;
@property BOOL isFullScreen;
@property (nonatomic,retain)UITextField *contentText;
@property (nonatomic,retain)UIImageView *imageView;

@property BOOL isImageSuccess;
@property long long int date;//发送图片的时间戳

@property int deleteTag;
@property(nonatomic,strong)NSMutableDictionary *nowArray;

@end
