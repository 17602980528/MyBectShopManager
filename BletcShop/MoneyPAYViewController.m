//
//  MoneyPAYViewController.m
//  BletcShop
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MoneyPAYViewController.h"
#import "SoundPaly.h"
#import "ChangePayPassVC.h"
#import "PayCustomView.h"
#import "AccessCodeVC.h"
@interface MoneyPAYViewController ()<UIAlertViewDelegate,PayCustomViewDelegate>
{
    UITextField *textTF;
    PayCustomView *view;
}
@end

@implementation MoneyPAYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"金额结算";
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 60, 120, 40)];
    label.text=@"输入金额:";
    label.textAlignment=1;
    [self.view addSubview:label];
    
    textTF=[[UITextField alloc]initWithFrame:CGRectMake(140, 60, SCREENWIDTH-180, 40)];
    textTF.borderStyle=UITextBorderStyleRoundedRect;
    textTF.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    textTF.placeholder=@"请输入消费金额";
    [self.view addSubview:textTF];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 160, SCREENWIDTH, 40);
    button.backgroundColor=NavBackGroundColor;
    //    button.layer.cornerRadius=8.0f;
    [button setTitle:@"确认支付" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)btnClick:(UIButton *)sender{
    [textTF resignFirstResponder];
    
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *pay_passwd= [NSString getTheNoNullStr:appdelegate.userInfoDic[@"pay_passwd"] andRepalceStr:@""];
    
    
    
    //判断输入的金额和卡的余额对比，如果小于，就弹出输入密码警告框，否就弹出提示，余额不够
    
    NSArray *array=[self.card_dic[@"card_remain"] componentsSeparatedByString:@"元"];
    //    NSLog(@"---%lf",)
    if ([textTF.text floatValue]>0&&[textTF.text floatValue]<=[array[0] floatValue]) {
        
        if ([pay_passwd isEqualToString:@"未设置"]) {
            
            UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有设置支付密码!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
            alt.tag = 888;
            [alt show];
            
        }else{
            
            view=[[PayCustomView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            view.delegate=self;
            [view.forgotButton addTarget:self action:@selector(forgetPayPass) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:view];
            
        }
        
    }else{
        if ([textTF.text isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"没有输入金额,请输入金额", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            [hud hideAnimated:YES afterDelay:2.f];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"输入金额大于当前卡余额", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            [hud hideAnimated:YES afterDelay:2.f];
        }
    }
    
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==888) {
        NSLog(@"去设置");
        if (buttonIndex==1) {
            ChangePayPassVC *vc=[[ChangePayPassVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
//    }else if (alertView.tag==999) {
//        //支付成功提示框
//        if (buttonIndex==0) {
//            [self.navigationController popViewControllerAnimated:YES];
//            
//            
//        }
//        
//    }else{
//        
        
    }
    
}

-(void)checkPayPassWd:(NSString *)payPassWd{
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/passwd/checkPayPasswd",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:payPassWd forKey:@"pay_passwd"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result---_%@",result);
        if ([result[@"result_code"] isEqualToString:@"access"]) {
            [view removeFromSuperview];
            [self postSocketCardPayAction];
            
        }else{
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"支付密码错误,请重新输入!";
            hud.mode = MBProgressHUDModeText;
            hud.label.font =[UIFont systemFontOfSize:13];
            [hud hideAnimated:YES afterDelay:1.5];
        }
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)postSocketCardPayAction
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/pay",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.card_dic[@"user"] forKey:@"uuid"];
    [params setObject:self.card_dic[@"merchant"] forKey:@"muid"];
    [params setObject:self.card_dic[@"card_code"] forKey:@"cardCode"];
    [params setObject:self.card_dic[@"card_level"] forKey:@"cardLevel"];
    
    [params setObject:@"储值卡" forKey:@"cardType"];
    NSString *payMoneyString = [NSString stringWithFormat:@"%.2f",[textTF.text floatValue]*[self.card_dic[@"rule"] floatValue]/100];
    
    [params setObject:payMoneyString forKey:@"sum"];
    
    NSLog(@"params===%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"self.payCardArray=result=%@", result);
         if ([result[@"result_code"] intValue]==1) {
             
             SoundPaly *sound=[SoundPaly sharedManager:@"sms-received1" type:@"caf"];
             [sound play];
             
             
             
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"支付成功,是否返回上一页面?" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 [self.navigationController popViewControllerAnimated:YES];

             }];
             
             UIAlertAction *sure = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             }];
             [alertController addAction:cancle];
             [alertController addAction:sure];
             
             
             [self presentViewController:alertController animated:YES completion:nil];


             //提交消费记录,先获取店铺名
             //             [self getShopName];
             
             
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
}
//发送订单详情

-(void)getShopName{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/accountGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.card_dic[@"merchant"] forKey:@"muid"];
    [params setValue:@"store" forKey:@"type"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result----%@",result);
        
        [self postOrderInfoWithShopName:result[@"store"]];
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}
-(void)postOrderInfoWithShopName:(NSString*)shopName
{
    
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/cnCmt",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.card_dic[@"user"] forKey:@"uuid"];
    
    
    
    NSString *orderInfoMessage = [[NSString alloc]initWithFormat:@"%@%@结算金额%@%@元",self.card_dic[@"merchant"],PAY_USCS,PAY_NP,textTF.text];
    
    [params setObject:orderInfoMessage forKey:@"content"];
    
    NSDateFormatter* matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date  = [NSDate date];
    NSString *NowDate = [matter stringFromDate:date];
    [params setObject:NowDate forKey:@"datetime"];
    [params setObject:textTF.text forKey:@"sum"];
    NSLog(@"params----%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result%@", result);
         if ([result[@"result_code"] intValue]==1) {
             ;
             
             
         }
         else
             [self postOrderInfoWithShopName:shopName];
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)confirmPassRightOrWrong:(NSString *)pass{
    [self checkPayPassWd:pass];
}
-(void)forgetPayPass{
    AccessCodeVC *vc=[[AccessCodeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
