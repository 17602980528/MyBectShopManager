//
//  BusinessViewController.m
//  BletcShop
//
//  Created by Yuan on 16/1/28.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "BusinessViewController.h"
#import "BussinessView.h"
#import "TwoBussinessView.h"
#import "ShopManagerViewController.h"
#import "AdvertViewController.h"
#import "RjgmViewController.h"
#import "AdminViewController.h"
#import "VipManagerViewController.h"
#import "DelayShopViewController.h"
#import "UpgradeShopViewController.h"
#import "NewNextViewController.h"
#import "OrderShopViewController.h"
#import "ShopAllInfoViewController.h"
#import "ChargeToAccountVC.h"
#import "CheckDataViewController.h"

#import "ShopLandController.h"
#import "NewShopIntroduceViewController.h"
#import "NewOrderShopViewController.h"


#import "NewShopManagerViewController.h"

#import "CreditThanViewController.h"
#import "AddCouponHomeVC.h"
//#import "AdvertisementHomeVC.h"


#import "PushAdverViewController.h"


@interface BusinessViewController ()<UIAlertViewDelegate>
{
    NSArray *arr_imgS;
}
@end

@implementation BusinessViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
 
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title = @"业务中心";
    arr_imgS = @[@"广告推送",@"店铺管理",@"资金提现",@"管理员设置",@"商家介绍",@"会员卡管理",@"授信额度",@"数据报表",@"优惠券"];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    topView.backgroundColor =NavBackGroundColor;
    [self.view addSubview:topView];
    
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, +20, SCREENWIDTH, 44)];
    label.text=@"业务中心";
    label.font=[UIFont systemFontOfSize:19];
    label.textAlignment=NSTextAlignmentCenter;
    //    label.textColor=RGB(51, 51, 51);
    label.textColor = [UIColor whiteColor];
    [topView addSubview:label];
    

    
    [self creatSubviews];
    
    
//    [self _initBtnView];
}

-(void)creatSubviews{
    
    UIView *TopView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 160)];
    TopView.backgroundColor = NavBackGroundColor;
    [self.view addSubview:TopView];
    
    NSArray *title_a = @[@"会员延期",@"预约处理"];
    for (int i=0 ; i< title_a.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*SCREENWIDTH/2, 0, SCREENWIDTH/2, TopView.height);
        [btn addTarget:self action:@selector(topbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [TopView addSubview:btn];
        
        UIImageView *imgV = [[UIImageView alloc]init];
        imgV.bounds = CGRectMake(0, 0, 50, 50);
        imgV.center = CGPointMake(btn.center.x, btn.center.y-15);
        imgV.image = [UIImage imageNamed:title_a[i]];
        [TopView addSubview:imgV];
        
        if (i==1) {
            imgV.bounds = CGRectMake(0, 0, 35, 35);
        }
        UILabel *lab = [[UILabel alloc]init];
        lab.frame = CGRectMake(btn.left, 105, btn.width, 20);
        lab.text = title_a[i];
        lab.textColor =[UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:15];
        [TopView addSubview:lab];
        
//        DebugLog(@"---%f",lab.top);
        
    }
    
    
    UIScrollView *bottomView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TopView.bottom, SCREENWIDTH, SCREENHEIGHT-64-44-TopView.height)];
    [self.view addSubview:bottomView];
    
    NSArray *imgS = @[@"bu_ad_icon",@"bu_st_icon",@"bu_carsh_icon",@"bu_setting_icon",@"bu_com_icon",@"bu_vvip_icon",@"bu_card_icon",@"bu_report_icon",@"bu_discant_icon"];
    for (int i = 0; i <arr_imgS.count; i ++) {
        int X = i %4;
        int Y = i /4;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(X * SCREENWIDTH/4, 20+Y *(SCREENWIDTH/4+10), SCREENWIDTH/4, SCREENWIDTH/4);
        [bottomView addSubview:btn];
        [btn addTarget:self action:@selector(goMineBussy:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        bottomView.contentSize = CGSizeMake(0, btn.bottom);
        
        UIImageView *imgV = [[UIImageView alloc]init];
        imgV.bounds = CGRectMake(0, 0, btn.width/2.5, btn.width/2.5);
        imgV.center = CGPointMake(btn.center.x, btn.center.y-10);
        imgV.image =[UIImage imageNamed:imgS[i]];
        [bottomView addSubview:imgV];
        
        UILabel *lab = [[UILabel alloc]init];
        lab.frame = CGRectMake(btn.left, imgV.bottom+10, btn.width, 15);
        lab.text = arr_imgS[i];
        lab.textColor =[UIColor blackColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:13];
        [bottomView addSubview:lab];
    }
    
    
}
//商铺信息上传#import "ShopAllInfoViewController.h"
-(void)gotoShopAllInfoView
{
    
    
    NewShopIntroduceViewController *rjgmView = [[NewShopIntroduceViewController alloc]init];

//    ShopAllInfoViewController *rjgmView = [[ShopAllInfoViewController alloc]init];
    [self.navigationController pushViewController:rjgmView animated:YES];
}
//资金提现RjgmViewController
-(void)gotoRjgmView
{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    if ([[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:@"shopMg"]) {

            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有查看权限" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alertView show];

            NSLog(@"tgtgtgtgtg");
        }else
        {
            RjgmViewController *rjgmView = [[RjgmViewController alloc]init];
            [self.navigationController pushViewController:rjgmView animated:YES];
        }

    
}
//管理员设置AdminViewController
-(void)gotoAdminView
{
    AdminViewController *adminView = [[AdminViewController alloc]init];
    [self.navigationController pushViewController:adminView animated:YES];
}
//店铺管理
-(void)shopManagerView
{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

        if ([[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:@"shopMg"]) {

            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有查看权限" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alertView show];
            
            NSLog(@"tgtgtgtgtg");
        }else
        {
            NewShopManagerViewController *shopManagerView = [[NewShopManagerViewController alloc]init];
            [self.navigationController pushViewController:shopManagerView animated:YES];
        }
    
}
//会员制管理#import "VipManagerViewController.h"13482563692
-(void)vipManagerView
{    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

        if ([[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:@"shopMg"]) {

            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有查看权限" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alertView show];
            
            NSLog(@"tgtgtgtgtg");
        }else
        {
            VipManagerViewController *vipManagerView = [[VipManagerViewController alloc]init];
            [self.navigationController pushViewController:vipManagerView animated:YES];
        }

}
//广告推送AdvertViewController
-(void)advertView
{

    
    
    [self showHint:@"暂未开通!"];

//    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//        if ([[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:@"shopMg"]) {
//            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有查看权限" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
//            [alertView show];
//            
//            NSLog(@"tgtgtgtgtg");
//        }else
//        {
//            AdvertViewController *advertView = [[AdvertViewController alloc]init];
//            [self.navigationController pushViewController:advertView animated:YES];
//        }

    
    
}
-(void)orderView
{
    NewOrderShopViewController *orderView = [[NewOrderShopViewController alloc]init];
    [self.navigationController pushViewController:orderView animated:YES];
}
-(void)delayView
{
    DelayShopViewController *delayView = [[DelayShopViewController alloc]init];

    [self.navigationController pushViewController:delayView animated:YES];
}
-(void)upgradeView
{
    UpgradeShopViewController *upgradeView = [[UpgradeShopViewController alloc]init];
    [self.navigationController pushViewController:upgradeView animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//数据报表
-(void)gotoDataTable{
    CheckDataViewController *checkVC=[[CheckDataViewController alloc]init];
    [self.navigationController pushViewController:checkVC animated:YES];
}


-(void)topbtnClick:(UIButton*)sender{
    
    switch (sender.tag) {
        case 0:
        {
            
            DelayShopViewController *delayView = [[DelayShopViewController alloc]init];
            
            [self.navigationController pushViewController:delayView animated:YES];


        }
            break;
            
        case 1:
        {

            [self orderView];
            
            
        }
            break;
            

        default:
            break;
    }
}

-(void)goMineBussy:(UIButton*)sender{
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *bankAccount = [NSString getTheNoNullStr:app.shopInfoDic[@"account"] andRepalceStr:@""];
    NSString *bankName = [NSString getTheNoNullStr:app.shopInfoDic[@"name"] andRepalceStr:@""];
    NSString *bankAddress = [NSString getTheNoNullStr:app.shopInfoDic[@"bank"] andRepalceStr:@""];
    

        NSString *stateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"wangyongle"];
    
    

    NSLog(@"bankAccount==%@",bankAccount);
    
#ifdef DEBUG
    stateStr = @"login_access";


#else
    
    
#endif
    
    
    
        if ([stateStr isEqualToString:@"incomplete"]) {
            //去完善信息界面
            [self showTiShi:@"信息不完善,是否去完善?" LeftBtn_s:@"取消" RightBtn_s:@"确定"];

            
            
        }else if ([stateStr isEqualToString:@"user_not_auth"]){
            
            [self showTiShi:@"用户尚未审核，我们将在三个工作日，完成审核" LeftBtn_s:@"取消" RightBtn_s:@"修改"];
            
//            [self use_examine];
        }else if ([stateStr isEqualToString:@"user_auth_fail"]){
            
            [self showTiShi:@"审核未通过，请重新修改" LeftBtn_s:@"取消" RightBtn_s:@"修改"];
            
           

        }

        else if ([stateStr isEqualToString:@"login_access"]){

            
            
    switch (sender.tag) {
        case 0:
        {
//            [self advertView];
            PushAdverViewController *advertisementHomeVC=[[PushAdverViewController alloc]init];
            [self.navigationController pushViewController:advertisementHomeVC animated:YES];
            
        }
            break;
        case 1:
        {
            [self shopManagerView];

        }
            break;
        case 2:
        {
            [self gotoRjgmView];

        }
            break;
        case 3:
        {
            [self gotoAdminView];

        }
            break;

               case 4:

        {
            [self gotoShopAllInfoView];

        }
            break;
        case 5:
        {
            
            NSLog(@"-----%ld==%@==%@",bankAccount.length,bankName,bankAddress);
            if ((bankAccount.length!=19 && bankAccount.length!=16)||bankName.length==0||bankAddress.length==0){
                
                [self showTiShi:@"银行卡信息不完整，请填写" LeftBtn_s:@"取消" RightBtn_s:@"修改"];
                
                
                
            }
            else{
                
                [self vipManagerView];
                
            }
            
        }
            break;

        case 6:
        {
            CreditThanViewController *creditView = [[CreditThanViewController alloc]init];
             [self.navigationController pushViewController:creditView animated:YES];

        }
            break;
        case 7:
        {
            [self gotoDataTable];
            
        }
            break;
        case 8:
        {

//            ChargeToAccountVC *VC = [[ChargeToAccountVC alloc]init];
//            [self.navigationController pushViewController:VC animated:YES];
            AddCouponHomeVC *couponHomeVC=[[AddCouponHomeVC alloc]init];
            [self.navigationController pushViewController:couponHomeVC animated:YES];
 
            
        }
            break;

            
        default:
            break;
    }
        }

}



-(void)showTiShi:(NSString *)content LeftBtn_s:(NSString*)left RightBtn_s:(NSString*)right{
    
    
    UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:left otherButtonTitles:right, nil];
    
    altView.tag =9999;
    [altView show];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==9999&&buttonIndex==1) {
        NewNextViewController *firstVC=[[NewNextViewController alloc]init];
        
        [self presentViewController:firstVC animated:YES completion:nil];
    }
    
       
    
}
    
@end
