//
//  LastRegistViewController.h
//  BletcShop
//
//  Created by Bletc on 16/4/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"

@interface LastRegistViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,CustomIOSAlertViewDelegate>
@property (nonatomic,retain)UITableView *infoTableView;
@property (nonatomic,retain)UITextField *bankText;//银行账户
@property (nonatomic,retain)UITextField *phonePswText;//手机查询密码
@property (nonatomic,retain)UITextField *otherText;//附加情况说明
@property (nonatomic,retain)UITextField *nameText;//紧急联系人1
@property (nonatomic,retain)UITextField *phoneText;//紧急联系人1
@property (nonatomic,retain)UITextField *nameText1;//紧急联系人2
@property (nonatomic,retain)UITextField *phoneText1;//紧急联系人2
@property (nonatomic,retain)UITextField *nameText2;//紧急联系人3
@property (nonatomic,retain)UITextField *phoneText2;//紧急联系人3
@property (nonatomic,retain)UITextField *idenCardText;//身份证
@property (nonatomic,retain)UITextField *realNameText;//真实姓名
@property (nonatomic,retain)UITextField *openBankText;//开户行

@property (nonatomic,retain)UILabel *licenceLabel;//有无营业执照
@property (nonatomic,retain)UILabel *propertyLabel;//房产证明或租赁合同
@property (nonatomic,retain)UIImageView *imageView;
@property (nonatomic,retain)UIImageView *imageView1;
@property (nonatomic,retain)UIImageView *imageView2;
@property (nonatomic,retain)UIImageView *imageView3;
@property (nonatomic,retain)UIImageView *imageView4;
@property (nonatomic,retain)UIImageView *imageView5;
@property (nonatomic,retain)UIImageView *imageView6;
@property (nonatomic,retain)UIImageView *imageView11;
@property (nonatomic,retain)NSString *licenceString;//有无营业执照
@property (nonatomic,retain)NSString *propertyString;//房产证明或租赁合同
@property BOOL isFullScreen;
@property int indexTag;

@property (nonatomic,retain)NSString *phoneString;//手机号
@property (nonatomic,retain)NSString *pswString;//密码
@property (nonatomic,retain)NSString *nibNameString;//n昵称
@property (nonatomic,retain)NSString *personString;//推荐人
@property (nonatomic,retain)NSString *addressString;//营业地址
@property (nonatomic,retain)NSString *shopNameString;//店铺地址
@property (nonatomic,retain)NSString *tradeString;//所属行业


@property (nonatomic,retain)NSString *addressPhoto;

@property (nonatomic,retain)UITableView *licenceTableView;
@property (nonatomic,retain)UITableView *propertyTableView;

@property BOOL ifLicence;
@property BOOL ifProperty;
//
@property BOOL ifImageView;
@property BOOL ifImageView1;
@property BOOL ifImageView2;
@property BOOL ifImageView3;
@property BOOL ifImageView4;
@property BOOL ifImageView5;
@property BOOL ifImageView6;
@property BOOL ifImageView11;
@property (nonatomic,retain)UIButton *registBtn;

@property (nonatomic,retain)UIView *demoView;
@end
