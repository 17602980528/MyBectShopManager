//
//  RechargeViewController.m
//  BletcShop
//
//  Created by Bletc on 16/4/13.
//  Copyright © 2016年 bletc. All rights reserved.
//


#import "RechargeViewController.h"
#import "PayMentController.h"
@interface RechargeViewController ()


@end

@implementation RechargeViewController

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
    
//    self.title = @"我要续卡";
    
    self.view.backgroundColor = RGB(240, 240, 240);
    
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    topView.backgroundColor =NavBackGroundColor;
    [self.view addSubview:topView];
    
    UIImageView*backImg=[[UIImageView alloc]init];
    backImg.frame=CGRectMake(9, 30, 12, 20);
    //    backImg.image=[UIImage imageNamed:@"arraw_left"];
    backImg.image=[UIImage imageNamed:@"leftArrow"];
    [topView addSubview:backImg];
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, +20, SCREENWIDTH, 44)];
    label.text=@"我要续卡";
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

    [self initSubViews];
    

}

-(void)initSubViews
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 126)];
    
//    backView.backgroundColor = RGB(0,162,255);
    backView.backgroundColor = NavBackGroundColor;

    [self.view addSubview:backView];
    
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 17, 150, 12)];
    moneyLabel.font = [UIFont systemFontOfSize:12];
    moneyLabel.text = @"卡内余额:(元)";
    moneyLabel.textColor = RGB(255,255,255);
    [backView addSubview:moneyLabel];
    
   UILabel*card_remain_lab = [[UILabel alloc]initWithFrame:CGRectMake(13, moneyLabel.bottom+40, SCREENWIDTH, 34)];
    card_remain_lab.font = [UIFont systemFontOfSize:36];
    card_remain_lab.textColor = RGB(255,255,255);
    card_remain_lab.text = [NSString stringWithFormat:@"%.2f",[self.card_dic[@"card_remain"] floatValue]];
    [backView addSubview:card_remain_lab];

    //充值
    
    UIButton *rechargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,backView.bottom+11,SCREENWIDTH,44)];
    [rechargeBtn setTitle:@"   金额" forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
    rechargeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    rechargeBtn.backgroundColor = [UIColor whiteColor];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:rechargeBtn];
    
    
    self.moneyText = [[UILabel alloc]initWithFrame:CGRectMake(0, rechargeBtn.top, SCREENWIDTH-13, rechargeBtn.height)];
    self.moneyText.font = [UIFont systemFontOfSize:15];
    self.moneyText.textColor = RGB(51,51,51);
    self.moneyText.textAlignment = NSTextAlignmentRight;
    self.moneyText.text = [NSString stringWithFormat:@"%.2f",[self.card_dic[@"price"] floatValue]];
    [self.view addSubview:self.moneyText];
    

    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(12, rechargeBtn.bottom+37, SCREENWIDTH-24, 49);
    sureBtn.layer.cornerRadius = 5;
    sureBtn.backgroundColor=NavBackGroundColor;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}



/**
 确定支付
 */
-(void)sureClick{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appdelegate.moneyText = self.moneyText.text;
    
    PayMentController *VC = [[PayMentController alloc]init];
    VC.moneyString = self.moneyText.text;
    VC.card_dic = self.card_dic;
    VC.orderInfoType = 2;
    [self.navigationController pushViewController:VC animated:YES];
  
    
}



@end
