//
//  NewNextViewController.h
//  BletcShop
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
@interface NewNextViewController : UIViewController
@property (nonatomic,retain)UIView *landView;
@property (nonatomic,retain)UIView *demoView;
@property(nonatomic,weak)UITextField *personText;//推荐人
@property(nonatomic)NSInteger indexTag;
@property (nonatomic,retain)NSString *nibNameString;
@property BOOL isFullScreen;
@property (nonatomic,retain)UIImageView *imageView;//正面
@property (nonatomic,retain)UIImageView *imageView1;//反面
@property (nonatomic,retain)UIImageView *imageView3;//手持
@property BOOL ifImageView;
@property BOOL ifImageView1;
@property BOOL ifImageView2;
@property (nonatomic,retain)UITextField *phonePswText;//手机查询授权
@property (nonatomic,retain)UITextField *idenCardText;//身份证
@property(nonatomic,retain)UITextField *nickTextTF;//昵称
@property(nonatomic,retain)UITextField *realNameTF;//姓名
@property(nonatomic,retain)UITextField *addressTF;//住宅地址
@property(nonatomic,retain)UITextField *kaihuTF;//开户行
@property(nonatomic,retain)UITextField *zhanghaoTF;//银行账号
@property (nonatomic,retain)NSString *phoneString;//手机号
@property (nonatomic,retain)NSString *pswString;//密码
@end
