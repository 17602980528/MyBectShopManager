//
//  MyMoneybagController.m
//  BletcShop
//
//  Created by Yuan on 16/1/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MyMoneybagController.h"
#import "AsyncSocket.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "BindBankCardViewController.h"
#import "MoneyBagChoiceTypeViewController.h"
#import "OrderInfomaViewController.h"
#import "NewRechargeViewController.h"

#import "MyRedBagVC.h"
#import "GetMoneyViewController.h"
#import "GetMoneyNowVC.h"
#import "MoneybagDetailVC.h"
#import "PlatCouponsVC.h"

@interface MyMoneybagController ()
{
    UILabel *numLabel;
}
@end

@implementation MyMoneybagController

-(NSMutableArray *)bankArray{
    if (!_bankArray) {
        _bankArray = [NSMutableArray array];
    }
    return _bankArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self postSocketMoney];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);

    self.choiceTag = 0;
//    self.title = @"我的钱包";
    
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    topView.backgroundColor =NavBackGroundColor;
    [self.view addSubview:topView];
    
    UIImageView*backImg=[[UIImageView alloc]init];
    backImg.frame=CGRectMake(9, 30, 12, 20);
//    backImg.image=[UIImage imageNamed:@"arraw_left"];
    backImg.image=[UIImage imageNamed:@"leftArrow"];
    [topView addSubview:backImg];
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, +20, SCREENWIDTH, 44)];
    label.text=@"我的钱包";
    label.font=[UIFont systemFontOfSize:19];
    label.textAlignment=NSTextAlignmentCenter;
//    label.textColor=RGB(51, 51, 51);
    label.textColor = [UIColor whiteColor];
    [topView addSubview:label];
    
    LZDButton*backTi=[LZDButton creatLZDButton];
    backTi.frame=CGRectMake(0, 20, SCREENWIDTH*0.2, 44);
    backTi.block = ^(LZDButton*btn){
        [self.navigationController popViewControllerAnimated:YES];
        
    };
    [topView addSubview:backTi];
    
    
    LZDButton*mingxi=[LZDButton creatLZDButton];
    mingxi.frame=CGRectMake(SCREENWIDTH - 55, 20, 50, 44);
    [mingxi setTitle:@"明细" forState:0];
    mingxi.titleLabel.font = [UIFont systemFontOfSize:15];
    mingxi.block = ^(LZDButton*btn){
        MoneybagDetailVC *VC = [[MoneybagDetailVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
        
    };
    [topView addSubview:mingxi];

    
    [self initSubViews];

}
-(void)postSocketMoney
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:@"remain" forKey:@"type"];

    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        self.moneyString = [NSString getTheNoNullStr:result[@"remain"] andRepalceStr:@"0.00"];
        self.moneyString = [self.moneyString stringByReplacingOccurrencesOfString:@"元" withString:@""];
        numLabel.text = [NSString stringWithFormat:@"%@元",self.moneyString];

        [self postSocketBank];

    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

/**
 获取银行卡
 */
-(void)postSocketBank
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/bank/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result%@", result);
        NSMutableArray *arr = [result copy];
        self.bankArray = arr;
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

-(void)initSubViews
{
    NSLog(@"initSubViews");
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 126)];
//    backView.backgroundColor = RGB(0,162,255);
    backView.backgroundColor = NavBackGroundColor;
    [self.view addSubview:backView];

   
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 17, 150, 12)];
    moneyLabel.font = [UIFont systemFontOfSize:15];
    moneyLabel.text = @"商消乐钱包余额:";
    moneyLabel.textColor = RGB(255,255,255);
    [backView addSubview:moneyLabel];
    
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, moneyLabel.bottom+40, SCREENWIDTH-26, 34)];
    numLabel.textAlignment=1;
    numLabel.font = [UIFont systemFontOfSize:45];
     numLabel.textColor = RGB(255,255,255);
    [backView addSubview:numLabel];
    //充值
    
    UIButton *rechargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,backView.bottom,SCREENWIDTH,44)];
    [rechargeBtn setTitle:@"   充值" forState:UIControlStateNormal];
     [rechargeBtn setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
    rechargeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    rechargeBtn.backgroundColor = [UIColor whiteColor];
    [rechargeBtn addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:rechargeBtn];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-10-7.5, (44-15)/2, 7.5, 15)];
    imageView1.image = [UIImage imageNamed:@"arraw_right"];
    [rechargeBtn addSubview:imageView1];
    //体现
    
    UIButton *withdrawuBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,rechargeBtn.bottom+1,SCREENWIDTH,44)];
    //rechargeBtn.frame = CGRectMake(SCREENWIDTH/6+15,55,SCREENWIDTH/6-15,20);
    [withdrawuBtn setTitle:@"   提现" forState:UIControlStateNormal];
    [withdrawuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    withdrawuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    [withdrawuBtn addTarget:self action:@selector(rigmAction) forControlEvents:UIControlEventTouchUpInside];
    withdrawuBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    withdrawuBtn.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:withdrawuBtn];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-10-7.5, (44-15)/2, 7.5, 15)];
    imageView2.image = [UIImage imageNamed:@"arraw_right"];
    [withdrawuBtn addSubview:imageView2];

    
    UIButton *redBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,withdrawuBtn.bottom+1,SCREENWIDTH,44)];
    //rechargeBtn.frame = CGRectMake(SCREENWIDTH/6+15,55,SCREENWIDTH/6-15,20);
    [redBtn setTitle:@"   红包" forState:UIControlStateNormal];
    [redBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    redBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [redBtn addTarget:self action:@selector(redClick) forControlEvents:UIControlEventTouchUpInside];
    redBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    redBtn.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:redBtn];
    
    UIImageView *imageView_red = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-10-7.5, (44-15)/2, 7.5, 15)];
    imageView_red.image = [UIImage imageNamed:@"arraw_right"];
    [redBtn addSubview:imageView_red];
    

//    //优惠券
    
    UIButton *priviBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,redBtn.bottom+10,SCREENWIDTH,44)];
    [priviBtn setTitle:@"   优惠券" forState:UIControlStateNormal];
    priviBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [priviBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    priviBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    priviBtn.backgroundColor = [UIColor whiteColor];
    [priviBtn addTarget:self action:@selector(priviBtnCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:priviBtn];
    
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-10-7.5, (44-15)/2, 7.5, 15)];
    imageView3.image = [UIImage imageNamed:@"arraw_right"];
    [priviBtn addSubview:imageView3];

}
-(void)bindBankCard
{
    BindBankCardViewController *bindBankCardView = [[BindBankCardViewController alloc]init];
    [self.navigationController pushViewController:bindBankCardView animated:YES];
}

/**
 提现
 */
-(void)rigmAction
{
    
    
    if (self.bankArray.count>0) {
        GetMoneyNowVC *VC = [[GetMoneyNowVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];

        
    }else
    {
        GetMoneyViewController *VC = [[GetMoneyViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}
-(void)rechargeAction
{
    NewRechargeViewController *VC = [[NewRechargeViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
//    self.choiceTag =0;
//    [self NewAddAction];
}
-(void)NewAddAction
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    self.alertView = alertView;
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView]];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定", @"取消", nil]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:NO];
    
    // And launch the dialog
    [alertView show];

}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] init];
    if (self.choiceTag==0) {
        demoView.frame=CGRectMake(0, 0, SCREENWIDTH-40, 50);
        self.demoView = demoView;
        UILabel *shangjiaLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 100, 30)];
        shangjiaLabel.text = @"充值金额";
        shangjiaLabel.font = [UIFont systemFontOfSize:15];
        [demoView addSubview:shangjiaLabel];
        UITextField *shangjiaText = [[UITextField alloc]initWithFrame:CGRectMake(140, 10, 120, 30)];
        shangjiaText.text = @"";
        shangjiaText.keyboardType = UIKeyboardTypeNumberPad;
        shangjiaText.layer.borderWidth = 0.3;
        shangjiaText.delegate = self;
        shangjiaText.tag = 101;
        self.moneyText = shangjiaText;
        [demoView addSubview:shangjiaText];
        shangjiaText.font = [UIFont systemFontOfSize:10];
        //添加点击事件

    }
    
    return demoView;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    [self.moneyText resignFirstResponder];
    [alertView close];

    if (buttonIndex==0) {
        if(self.choiceTag==0){
        [self CreateAction];

        }
                
            }

}



-(void)CreateAction
{
    if ([self.moneyText.text isEqualToString:@""]||[self.moneyText.text isEqualToString:@"(null)"]||self.moneyText.text == nil ||[self.moneyText.text floatValue]<=0.0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请填写充值金额", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }
    else{
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        appdelegate.moneyText = self.moneyText.text;
        OrderInfomaViewController *orderInfoView = [[OrderInfomaViewController alloc]init];
        orderInfoView.moneyString = self.moneyText.text;
        
        orderInfoView.orderInfoType=3;
        
        [self.navigationController pushViewController:orderInfoView animated:YES];

        
    }
}

-(void)priviBtnCard{

    
    PlatCouponsVC *VC = [[PlatCouponsVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    
//    hud.label.text = NSLocalizedString(@"暂未开放!", @"HUD message title");
//    hud.label.font = [UIFont systemFontOfSize:13];
//    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
//    [hud hideAnimated:YES afterDelay:1.f];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
        [self.moneyText resignFirstResponder];
        [self.alertView close];

}

-(void)redClick{
    
    
    MyRedBagVC *VC = [[MyRedBagVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
