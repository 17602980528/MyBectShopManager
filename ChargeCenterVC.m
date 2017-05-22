//
//  ChargeCenterVC.m
//  BletcShop
//
//  Created by Bletc on 16/9/29.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ChargeCenterVC.h"
#import "ChargeToAccountVC.h"
#import "LZDCashViewController.h"
#import "LZDCountsViewController.h"
#import "MJXAViewController.h"
#import "ScanViewController.h"

#import "ReveiveMoneyQRInfoVC.h"


@interface ChargeCenterVC ()<ScanViewControllerDelegate>
{
    NSArray *arr;
}
@end

@implementation ChargeCenterVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"结算中心";
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"扫描二维码"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saoMa) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    for (int i = 0; i <2; i ++) {
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(15, 15+i*((SCREENHEIGHT-64-49-45)/2+15), SCREENWIDTH-30, (SCREENHEIGHT-64-49-45)/2);
        button1.backgroundColor = [UIColor whiteColor];
        
        button1.tag = i;
        [button1 addTarget:self action:@selector(choseClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button1];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.center = CGPointMake(button1.center.x, button1.center.y-30);
        btn.userInteractionEnabled = NO;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.bounds = CGRectMake(0, 0, SCREENWIDTH*0.25, SCREENWIDTH*0.25);
        btn.layer.cornerRadius = btn.width/2;
        btn.layer.masksToBounds = YES;
        [self.view addSubview:btn];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, btn.bottom+20, SCREENWIDTH, 20)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = RGB(51, 51, 51);
        lab.font = [UIFont boldSystemFontOfSize:18];
        [self.view addSubview:lab];

 
        if (i==0) {
            [btn setTitle:@"收" forState:0];
            btn.backgroundColor = RGB(277, 196, 0);
            lab.text = @"我要收款";
            
            
        }else{
            [btn setTitle:@"入" forState:0];
            btn.backgroundColor = RGB(0, 185, 25);
            lab.text = @"现金入账";

        }
    }
}

-(void)choseClick:(UIButton*)sender{
    
//    NSString *stateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"wangyongle"];
//    
//#ifdef DEBUG
//    stateStr = @"login_access";
//    
//    
//#else
//    
//    
//#endif
//    
//    if ([stateStr isEqualToString:@"incomplete"]) {
//        //去完善信息界面
//        [self showTiShi:@"信息不完善,是否去完善?" LeftBtn_s:@"取消" RightBtn_s:@"确定"];
//        
//    }else if ([stateStr isEqualToString:@"user_not_auth"]){
//        
//        [self showTiShi:@"用户尚未审核，我们将在三个工作日，完成审核" LeftBtn_s:@"取消" RightBtn_s:@"修改"];
//        
//        //            [self use_examine];
//    }else if ([stateStr isEqualToString:@"user_auth_fail"]){
//        
//        [self showTiShi:@"审核未通过，请重新修改" LeftBtn_s:@"取消" RightBtn_s:@"修改"];
//        
//        
//        
//    }else if ([stateStr isEqualToString:@"user_auth_fail"]){
//        //正在审核中
//        UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"正在审核中" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [altView show];
//        
//    }else if ([stateStr isEqualToString:@"login_access"]){
    
        switch (sender.tag) {
                
            case 0:
                //收款二维码
            {
                ReveiveMoneyQRInfoVC *VC = [[ReveiveMoneyQRInfoVC alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
               
            }
                break;
            case 1:
                //现金结算
            {
                ChargeToAccountVC *VC = [[ChargeToAccountVC alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
                
            }
                break;
                
            default:
                break;
        }
        
//    }
    
    
}

-(void)showTiShi:(NSString *)content LeftBtn_s:(NSString*)left RightBtn_s:(NSString*)right{
    
    
    UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:left otherButtonTitles:right, nil];
    
    altView.tag =9999;
    [altView show];
    
}

-(void)saoMa{
    ScanViewController *VC = [[ScanViewController alloc]init];
    VC.shopOrUser=@"shop";
    VC.delegate=self;
    [self.navigationController pushViewController:VC animated:YES];

}
-(void)sendResult:(NSString *)state{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:state message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}
@end
