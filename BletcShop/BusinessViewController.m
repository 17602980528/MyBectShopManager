//
//  BusinessViewController.m
//  BletcShop
//
//  Created by Yuan on 16/1/28.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "BusinessViewController.h"
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

#import "AuthFailShopVC.h"

#import "PushAdverViewController.h"


#import "SHOPVIPCARDVC.h"

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
    arr_imgS = @[@"广告推送",@"店铺管理",@"资金提现",@"管理员设置",@"商家介绍",@"会员延期",@"授信额度",@"预约处理",@"优惠券"];
    
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
    
    
}

-(void)creatSubviews{
    
    UIView *TopView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 160)];
    TopView.backgroundColor = NavBackGroundColor;
    [self.view addSubview:TopView];
    
    NSArray *title_a = @[@"会员卡管理",@"数据报表"];
    NSArray *img_a = @[@"bu_vvip_icon-1",@"bu_report_icon-1"];

    for (int i=0 ; i< title_a.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*SCREENWIDTH/2, 0, SCREENWIDTH/2, TopView.height);
        [btn addTarget:self action:@selector(topbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [TopView addSubview:btn];
        
        UIImageView *imgV = [[UIImageView alloc]init];
        imgV.bounds = CGRectMake(0, 0, 50, 50);
        imgV.center = CGPointMake(btn.center.x, btn.center.y-15);
        imgV.image = [UIImage imageNamed:img_a[i]];
        [TopView addSubview:imgV];
        
//        if (i==1) {
//            imgV.bounds = CGRectMake(0, 0, 35, 35);
//        }
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
    
    UIView *huixin = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bottomView.width,10 )];
    huixin.backgroundColor = RGB(234, 234, 234);
    [bottomView addSubview:huixin];

    
    NSArray *imgS = @[@"bu_ad_icon",@"bu_st_icon",@"bu_carsh_icon",@"bu_setting_icon",@"bu_com_icon",@"bu_vip_icon",@"bu_card_icon",@"bu_time_icon",@"bu_discant_icon"];
    for (int i = 0; i <arr_imgS.count; i ++) {
        int X = i %4;
        int Y = i /4;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(X * SCREENWIDTH/4, 20+Y *(SCREENWIDTH/4+10), SCREENWIDTH/4, SCREENWIDTH/4);
        [bottomView addSubview:btn];
        [btn addTarget:self action:@selector(goMineBussy:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        bottomView.contentSize = CGSizeMake(0, btn.bottom);
        UIView *shuxxian = [[UIView alloc]initWithFrame:CGRectMake(btn.width-1, 5, 1, btn.width-10)];
        shuxxian.backgroundColor = RGB(234, 234, 234);
        [btn addSubview:shuxxian];
        
        if (i==0 || i ==4) {
            
            UIView *hengxian = [[UIView alloc]initWithFrame:CGRectMake(12, btn.bottom+3, bottomView.width-24,1 )];
            hengxian.backgroundColor = RGB(234, 234, 234);
            [bottomView addSubview:hengxian];

        }
       
        
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
    

    NewShopIntroduceViewController *VC = [[NewShopIntroduceViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
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
//            VipManagerViewController *vipManagerView = [[VipManagerViewController alloc]init];
//            [self.navigationController pushViewController:vipManagerView animated:YES];
            
            PUSH(SHOPVIPCARDVC)
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


#pragma  mark 会员卡管理,数据报表

-(void)topbtnClick:(UIButton*)sender{
    
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *stateStr = app.shopInfoDic[@"state"];
    
    
    //        NSString *stateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"wangyongle"];
    
    
    
    
#ifdef DEBUG
//    stateStr = @"complete_not_auth";
    
    
#else
    
    
#endif
    
    //管理会员卡
    if (sender.tag==0) {
        if ([stateStr isEqualToString:@"incomplete"]) {
            //去完善信息界面
            
            UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"店铺上未认证!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"预付保险认证",@"快速认证", nil];
            
            altView.tag =9998;
            [altView show];
            
            
            
        }else
            
            if ([stateStr isEqualToString:@"null"]) {
                //去完善信息界面
                UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"尚未审核,是否去修改?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"预付保险认证",@"快速认证", nil];
                
                altView.tag =9998;
                [altView show];
                
                
            }else if ([stateStr isEqualToString:@"complete_not_auth"]){
                
                [self showTiShi:@"尚未完成预付保险认证!" LeftBtn_s:@"取消" RightBtn_s:@"去认证"];
                
                //            [self use_examine];
            }else if ([stateStr isEqualToString:@"false"]){
                
                
                
                UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"审核未通过，请重新修改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"预付保险认证",@"快速认证", nil];
                
                altView.tag =9998;
                [altView show];
                
                
                
            }else if ([stateStr isEqualToString:@"auditing"]){
                UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"正在审核中" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                
                [altView show];
                
            }else if ([stateStr isEqualToString:@"true"]){
                
                
                    [self vipManagerView];
                    
                    
                    
                
            }

    }
    
    //数据报表
    if (sender.tag==1) {
        if ([stateStr isEqualToString:@"incomplete"]) {
            //去完善信息界面
            
            UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息不完善,是否去完善或认证?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去完善",@"去认证", nil];
            
            altView.tag =9998;
            [altView show];
            
            
            
        }else
            
            if ([stateStr isEqualToString:@"null"]) {
                //去完善信息界面
                UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"尚未审核,是否去修改?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改完善信息",@"修改认证信息", nil];
                
                altView.tag =9998;
                [altView show];
                
                
            }else if ([stateStr isEqualToString:@"complete_not_auth"]){
                

                
                          [self gotoDataTable];
                
                
            }else if ([stateStr isEqualToString:@"false"]){
                
                
                
                UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"审核未通过，请重新修改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改完善信息",@"修改认证信息", nil];
                
                altView.tag =9998;
                [altView show];
                
                
                
            }else if ([stateStr isEqualToString:@"auditing"]){
                UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"正在审核中" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                
                [altView show];
                
            }else if ([stateStr isEqualToString:@"true"]){
                
                
                [self gotoDataTable];
                
                
                
                
            }
        
    }
    
    
    

}

#pragma mark 小分类点击

-(void)goMineBussy:(UIButton*)sender{
    
    
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    NSString *stateStr = app.shopInfoDic[@"state"];
    
    
//        NSString *stateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"wangyongle"];
    
    

    
#ifdef DEBUG
//    stateStr = @"";


#else
    
    
#endif
    
    
    if ([stateStr isEqualToString:@"incomplete"]) {
        //去完善信息界面
        
        UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"店铺上未认证!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"预付保险认证",@"快速认证", nil];
        
        altView.tag =9998;
        [altView show];

        
        
    }else
    
        if ([stateStr isEqualToString:@"null"]) {
            //去完善信息界面
            UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"尚未审核,是否去修改?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"预付保险认证",@"快速认证", nil];
            
            altView.tag =9998;
            [altView show];
            
            
        }else if ([stateStr isEqualToString:@"false"]){
            
            
            
            UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"审核未通过，请重新修改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"预付保险认证",@"快速认证", nil];
            
            altView.tag =9998;
            [altView show];

           

        }else if ([stateStr isEqualToString:@"auditing"]){
            UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"正在审核中" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [altView show];
            
        }else if ([stateStr isEqualToString:@"true"] ||[stateStr isEqualToString:@"complete_not_auth"]){

            
            
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
            
            DelayShopViewController *delayView = [[DelayShopViewController alloc]init];
            
            [self.navigationController pushViewController:delayView animated:YES];
            
            
            
            
        }
            break;

        case 6:
        {
            
            UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂未开放!" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
            
            [altView show];
            
            
//            CreditThanViewController *creditView = [[CreditThanViewController alloc]init];
//             [self.navigationController pushViewController:creditView animated:YES];

        }
            break;
        case 7:
        {
            
            [self orderView];

          
            
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
    if (alertView.tag==9999) {
        if (buttonIndex==1) {
            NewNextViewController *firstVC=[[NewNextViewController alloc]init];
            
            [self presentViewController:firstVC animated:YES completion:nil];
        }
       
    }else if(alertView.tag==9998){
        
        if (buttonIndex==1) {
            NewNextViewController *firstVC=[[NewNextViewController alloc]init];
            
            [self presentViewController:firstVC animated:YES completion:nil];
        }
        
        if (buttonIndex==2) {
            AuthFailShopVC *firstVC=[[AuthFailShopVC alloc]init];
            
            [self presentViewController:firstVC animated:YES completion:nil];
        }

    }
    
       
    
}
    
@end
