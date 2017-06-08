//
//  CountPAYViewController.m
//  BletcShop
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CountPAYViewController.h"
#import "SoundPaly.h"
#import "ChangePayPassVC.h"
#import "PayCustomView.h"
#import "AccessCodeVC.h"
@interface CountPAYViewController ()<UITextFieldDelegate,UIAlertViewDelegate,PayCustomViewDelegate>
{
    UITextField *textTF;
    NSInteger count;
    PayCustomView *view;
}
@end

@implementation CountPAYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"按次结算";
    NSLog(@"%@",self.card_dic);
    
    NSArray *array= [self.card_dic[@"price"] componentsSeparatedByString:@"元"];
    
    self.all=[array[0] floatValue];
    
    UIButton *redBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [redBtn setImage:[UIImage imageNamed:@"grey_red"] forState:UIControlStateNormal];
    redBtn.frame=CGRectMake(40, 75, 50, 50);
    redBtn.layer.borderWidth=1.0;
    redBtn.layer.borderColor=[[UIColor grayColor]CGColor];
    [redBtn addTarget:self action:@selector(redBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redBtn];
    //右加
    UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"grey_add"] forState:UIControlStateNormal];
    addBtn.frame=CGRectMake(SCREENWIDTH-40-50, 75, 50, 50);
    addBtn.layer.borderWidth=1.0;
    addBtn.layer.borderColor=[[UIColor grayColor]CGColor];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    //立即购买
    UIButton *buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame=CGRectMake(0, 160, SCREENWIDTH, 40);
    buyBtn.backgroundColor=NavBackGroundColor;
    [buyBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:buyBtn];
    //显示次数的label
    textTF=[[UITextField alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-25, 75, 50, 50)];
    textTF.textAlignment=1;
    textTF.text=@"0";
    textTF.delegate=self;
    textTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:textTF];
    //    countLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-25, 75, 50, 50)];
    //    countLab.textColor=[UIColor redColor];
    //    countLab.text=[[NSString alloc]initWithFormat:@"%ld",(long)count];
    //    countLab.font=[UIFont systemFontOfSize:20.0f];
    //    countLab.textAlignment=1;
    [self.view addSubview:textTF];
    
}
-(void)redBtnClick{
    if (count!=0) {
        count--;
        textTF.text=[[NSString alloc]initWithFormat:@"%ld",(long)count];
    }
}
-(void)addBtnClick{
    int lastPerson = [self.card_dic[@"rule"] intValue];
    if (count<lastPerson) {
        count++;
        textTF.text=[[NSString alloc]initWithFormat:@"%ld",(long)count];
    }
}


/**
 确认支付
 */
-(void)buyClick{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *pay_passwd= [NSString getTheNoNullStr:appdelegate.userInfoDic[@"pay_passwd"] andRepalceStr:@""];
    
    NSString *oneString = self.card_dic[@"price"];
    
    
    NSString *allString = self.card_dic[@"card_remain"];;
    
    
    double onePrice = [oneString doubleValue];
    double allPrice = [allString doubleValue];
    
    int cishu =[self.card_dic[@"rule"] intValue];
    int time = (int)(onePrice/(allPrice/cishu));
    NSLog(@"-----%ld---%d",[textTF.text integerValue],time);
    
    if ([textTF.text integerValue]>0 &&  [textTF.text integerValue]<=time) {
        
        if ([pay_passwd isEqualToString:@"未设置"]) {
            
            UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有设置支付密码!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
            alt.tag = 888;
            [alt show];
            
        }else{
            
            self.payCount=[textTF.text intValue];
            
            view=[[PayCustomView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            view.delegate=self;
            [view.forgotButton addTarget:self action:@selector(forgetPayPass) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:view];
        }
        
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"可消费次数不足", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        [hud hideAnimated:YES afterDelay:2.f];
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==888) {
        NSLog(@"去设置");
        if (buttonIndex==1) {
            ChangePayPassVC *vc=[[ChangePayPassVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (alertView.tag==999) {
        //支付成功提示框
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
        
    }else{
        //得到输入框
        
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
    
    
    int cishu =[self.card_dic[@"rule"] intValue];
    float pay = (self.all/cishu)*self.payCount;
    [params setObject:@"计次卡" forKey:@"cardType"];
    
    
    
    [params setObject:[[NSString alloc] initWithFormat:@"%.2f",pay] forKey:@"sum"];
    
    NSLog(@"paramer===%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"self.payCardArray%@", result);
         
         
         if ([result[@"result_code"] intValue]==1) {
             SoundPaly *sound=[SoundPaly sharedManager:@"sms-received1" type:@"caf"];
             [sound play];
             
             UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付成功,是否返回上一页面?" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"取消", nil];
             altView.tag =999;
             
             [altView show];
             
             
             //发送订单详情,获取店名
             
             //             [self getShopName];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"error=%@", error);
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
    
    
    NSString *orderInfoMessage = [[NSString alloc]initWithFormat:@"%@%@结算次数%@%@",self.card_dic[@"merchant"],PAY_USCS,PAY_NP,textTF.text];
    
    
    int cishu =[self.card_dic[@"rule"] intValue];
    float pay = (self.all/cishu)*self.payCount;
    
    [params setObject:[[NSString alloc] initWithFormat:@"%.2f",pay] forKey:@"sum"];
    
    
    
    [params setObject:orderInfoMessage forKey:@"content"];
    NSDateFormatter* matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date  = [NSDate date];
    NSString *NowDate = [matter stringFromDate:date];
    [params setObject:NowDate forKey:@"datetime"];
    
    NSLog(@"发送订单---%@",params);
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


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}
-(void)dismissSelf{
    [self.navigationController popViewControllerAnimated:YES];
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
    
}


@end
