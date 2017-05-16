//
//  ChangeVipCardInfoVC.h
//  BletcShop
//
//  Created by apple on 2017/5/3.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeVipCardInfoVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,weak)UITableView *MyAddtable;

@property (nonatomic,retain)UITextField *phoneText;
//@property (nonatomic,retain)UITextField *codeText;//会员卡编号
@property (nonatomic,retain)UITextField *priceText;
@property (nonatomic,retain)UITextField *contentText;
@property (nonatomic , strong) UITextField *deadLineText;// 期限

@property (nonatomic,retain)UILabel *zhekouLabel;//折扣率
@property (nonatomic,retain)UILabel *zhekouLabel1;//折扣率
@property (nonatomic,retain)UITextField *zhekouText;//折扣率
@property (nonatomic,retain)UITextField *otherMoneyText;//额外金额
@property (nonatomic,retain)NSString *cardTypeString;//会员卡类型
@property (nonatomic,retain)NSString *cardLevelString;//会员卡级别
@property (nonatomic,retain)UILabel *cardTypeLabel;//店员类型label
@property (nonatomic,retain)UILabel *cardLevelLabel;//店员类型label


@property (nonatomic , strong) NSArray *deadLine_A;//有效期数组

@property (nonatomic , strong) NSDictionary *deadLine_dic;// <#Description#>


@property (nonatomic,retain)NSArray *typeArray;
@property (nonatomic,retain)NSArray *levelArray;
@property (nonatomic)BOOL ifTypePicker;
@property (nonatomic)BOOL ifLevelPicker;
@property(nonatomic,retain)UIButton *okButton;
@property(nonatomic,retain)UIButton *noButton;
@property BOOL isFullScreen;
@property(nonatomic,retain)UIView *topToolView;
@property (nonatomic,retain)UIImageView *imageView;
//相册还是默认
@property int choiceType;//0-相册相机 1-默认
//选择的默认卡片
@property (nonatomic,retain)NSDictionary *choiceCard;
//会员卡类型
@property(nonatomic,retain)UIButton *cardStyle1;
@property(nonatomic,retain)UIButton *cardStyle2;
@property(nonatomic)BOOL isOpen;
@property(nonatomic)BOOL isOpen2;
//会员卡级别
@property(nonatomic,retain)UIButton *levelBtn1;
@property(nonatomic,retain)UIButton *levelBtn2;
@property(nonatomic,retain)UIButton *levelBtn3;
@property(nonatomic,retain)UIButton *levelBtn4;
@property(nonatomic,retain)UIButton *levelBtn5;
@property(nonatomic,retain)UIButton *levelBtn6;
@property(nonatomic,retain)NSDictionary *codeDic;
@end
