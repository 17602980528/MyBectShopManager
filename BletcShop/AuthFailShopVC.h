//
//  NewMiddleViewController.h
//  BletcShop
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthFailShopVC : UIViewController
@property (nonatomic,retain)UIView *landView;
@property (nonatomic,strong)NSMutableArray *tradeArray;

@property(nonatomic,retain)UIButton *haveBtn;
@property(nonatomic,retain)UIButton *noneBtn;
@property(nonatomic,retain)UIButton *agreeBtn1;
@property(nonatomic,retain)UIButton *agreeBtn2;
@property(nonatomic,retain)UIImageView *imageView1;
@property(nonatomic,retain)UIImageView *imageView2;
@property(nonatomic,retain)UIImageView *imageView3;
@property(nonatomic,retain)UIImageView *imageView4;
@property(nonatomic,retain)UIImageView *imageView5;
@property(nonatomic,retain)UIImageView *imageView6;
@property(nonatomic)NSInteger indexTag;

//是否上传过的一种状态
@property BOOL ifImageView1;
@property BOOL ifImageView2;
@property BOOL ifImageView3;
@property BOOL ifImageView4;
@property BOOL ifImageView5;
@property BOOL ifImageView6;
//需要传递的参数

//本页面需要传往下个页面的元素
@property(nonatomic,retain)UILabel *locationLab;//当前地区
@property(nonatomic,strong)UITextField *detailAddressTF;//街道
@property(nonatomic,strong)UITextField *adddetailnewAddressTF;//详细地址----real
@property(nonatomic,strong)UITextField *company_nameTF;//公司名称
@property(nonatomic,strong)UITextField *company_styleTF;

@property(nonatomic,retain)UITextField *agencyNameTF;//店铺名称
@property(nonatomic,retain)UILabel *kindLab;//行业
@property(nonatomic,retain)UITextField *reasonTF;//营业执照说明

@property (nonatomic , strong) UITextField *store_textf;// 联系方式

@property(nonatomic,retain)UILabel *houseProvide1;
@property(nonatomic,retain)UILabel *houseProvide2;
@end
