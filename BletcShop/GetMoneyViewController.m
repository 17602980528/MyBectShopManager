//
//  GetMoneyViewController.m
//  BletcShop
//
//  Created by Bletc on 2016/11/11.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "GetMoneyViewController.h"
#import "AddBankAccountVC.h"

@interface GetMoneyViewController ()

@end

@implementation GetMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"钱包提现";
    self.view.backgroundColor = RGB(240, 240, 240);
    UIImageView *image_view = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-215)/2, 80, 215, 110)];
    
//    image_view.image = [UIImage imageNamed:@"QQ20161219-0"];
    [self.view addSubview:image_view];
    
    UIView *backView0 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 167, image_view.height)];
    backView0.backgroundColor = RGB(205, 205, 205);
    backView0.layer.cornerRadius = 4;
    backView0.layer.masksToBounds = YES;
    [image_view addSubview:backView0];
    
    UIView *backView1 = [[UIView alloc]initWithFrame:CGRectMake(20, 24, 167, 28.5)];
    backView1.backgroundColor = self.view.backgroundColor ;
       [image_view addSubview:backView1];
    
    UIView *backView2 = [[UIView alloc]initWithFrame:CGRectMake(16, backView1.bottom+16, 42, 21)];
    backView2.backgroundColor = self.view.backgroundColor;
    backView2.layer.cornerRadius = 2;
    backView2.layer.masksToBounds = YES;
    [backView0 addSubview:backView2];

    
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, image_view.bottom+36, SCREENWIDTH, 15)];
    lable.text = @"还没有绑定银行卡，快添加一张吧";
    lable.textColor = RGB(153,153,153);
    lable.font = [UIFont systemFontOfSize:15];
    lable.textAlignment= NSTextAlignmentCenter;
    [self.view addSubview:lable];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREENWIDTH/2-50, lable.bottom +20, 100, 44);
    [button setTitle:@"添加银行卡" forState:0];
    [button setTitleColor:RGB(17,141,240) forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(addbankAccount) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
-(void)addbankAccount{
    AddBankAccountVC *VC = [[AddBankAccountVC alloc]init];
    VC.whoPush = @"GetMoneyViewController";
    
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
