//
//  NewRechargeViewController.m
//  BletcShop
//
//  Created by apple on 16/11/21.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewRechargeViewController.h"
#import "MyMoneybagController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "UPPaymentControl.h"
#import "NewRechargeSuccessVC.h"

@interface NewRechargeViewController ()<UIAlertViewDelegate,UITextFieldDelegate>

@end

@implementation NewRechargeViewController
{
    NSInteger payIndex;
    UIButton *chooseState;
    UIButton *chooseState2;
    UITextField *moneyTextFD;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:ORDER_PAY_NOTIFICATION object:nil];//监听一个通知
    
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)getOrderPayResult:(NSNotification*)notification{
    BOOL payResult = NO;
    if ([notification.object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *result = (NSDictionary*) notification.object;
        
        payResult = [result[@"resultStatus"] integerValue]==9000 ? YES:NO;
        
        [self showtishi:payResult];
    }
    else if ([notification.object isKindOfClass:[NSString class]]){
        NSString *result = (NSString*) notification.object;
        
        payResult = [result isEqualToString:@"success"] ? YES:NO;
        [self showtishi:payResult];
        
    }
    
    
}
-(void)showtishi:(BOOL)payResult{
    
    if (payResult) {
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"您已成功支付啦!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        
//        [alert show];
        NewRechargeSuccessVC *VC = [[NewRechargeSuccessVC alloc]init];
        VC.money_s = [NSString stringWithFormat:@"¥%@",moneyTextFD.text];
        [self.navigationController pushViewController:VC animated:YES];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃当前交易?" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"去支付", nil];
        alert.tag =1111;
        [alert show];

        
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    payIndex=-1;
    
    self.view.backgroundColor=RGB(240, 240, 240);
    self.navigationItem.title=@"充值";
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 132+2)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 65, 44)];
    priceLabel.text=@"金额(￥)";
    priceLabel.textAlignment=NSTextAlignmentLeft;
    priceLabel.font=[UIFont systemFontOfSize:16.0f];
    [backView addSubview:priceLabel];
    
    moneyTextFD=[[UITextField alloc]initWithFrame:CGRectMake(82, 0, SCREENWIDTH-82, 44)];
    moneyTextFD.placeholder=@"请输入充值金额";
    moneyTextFD.keyboardType=UIKeyboardTypeEmailAddress;
    moneyTextFD.textColor=[UIColor blueColor];
    moneyTextFD.delegate = self;
    moneyTextFD.font=[UIFont systemFontOfSize:16.0f];
    [backView addSubview:moneyTextFD];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(12, 44, SCREENWIDTH-24, 1)];
    lineView1.backgroundColor=RGB(234, 234, 234);
    [backView addSubview:lineView1];
    
    UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(12, 45+7, 30, 30)];
    imageView1.image=[UIImage imageNamed:@"alipay_img.png"];
    [backView addSubview:imageView1];
    UILabel *alipayLab = [[UILabel alloc]initWithFrame:CGRectMake(imageView1.right+10, imageView1.top, 100, imageView1.height)];
    alipayLab.text = @"支付宝支付";
    alipayLab.textColor = RGB(51, 51, 51);
    alipayLab.font = [UIFont systemFontOfSize:15];
    [backView addSubview:alipayLab];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(12, 89, SCREENWIDTH-24, 1)];
    lineView2.backgroundColor=RGB(234, 234, 234);
    [backView addSubview:lineView2];
    
    UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(12, 90+7, 30, 30)];
    imageView2.image=[UIImage imageNamed:@"unionpay_img.png"];
    [backView addSubview:imageView2];
    
    UILabel *uPpayLab = [[UILabel alloc]initWithFrame:CGRectMake(imageView2.right+10, imageView2.top, 100, imageView2.height)];
    uPpayLab.text = @"银联支付";
    uPpayLab.textColor = RGB(51, 51, 51);
    uPpayLab.font = [UIFont systemFontOfSize:15];
    [backView addSubview:uPpayLab];

    
    UIButton *confirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame=CGRectMake(12, 10+134+37, SCREENWIDTH-24, 49);
    confirmBtn.backgroundColor=NavBackGroundColor;
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font=[UIFont systemFontOfSize:18.0f];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.cornerRadius = 5;
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, lineView1.bottom +45*i, SCREENWIDTH, 45);
        button.tag  = i+1;
        [backView addSubview:button];
        
        if (i==0) {
            [button addTarget:self action:@selector(alipPay:) forControlEvents:UIControlEventTouchUpInside];

        }
        if (i==1) {
            [button addTarget:self action:@selector(unionPay:) forControlEvents:UIControlEventTouchUpInside];
            
        }

    }
    
    
    chooseState=[[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-50, 40+7, 40, 40)];
    [chooseState setBackgroundImage:[UIImage imageNamed:@"settlement_unchoose_n"] forState:UIControlStateNormal];
    chooseState.tag=1;
    [backView addSubview:chooseState];
    [chooseState addTarget:self action:@selector(alipPay:) forControlEvents:UIControlEventTouchUpInside];
    
    chooseState2=[[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-50, 85+7, 40, 40)];
    [chooseState2 setBackgroundImage:[UIImage imageNamed:@"settlement_unchoose_n"] forState:UIControlStateNormal];
    chooseState2.tag=2;
    [backView addSubview:chooseState2];
    [chooseState2 addTarget:self action:@selector(unionPay:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)alipPay:(UIButton *)sender{
    payIndex=chooseState.tag;
    [chooseState setBackgroundImage:[UIImage imageNamed:@"settlement_choose_n"] forState:UIControlStateNormal];
    [chooseState2 setBackgroundImage:[UIImage imageNamed:@"settlement_unchoose_n"] forState:UIControlStateNormal];
}
-(void)unionPay:(UIButton *)sender{
    payIndex=chooseState2.tag;
    [chooseState2 setBackgroundImage:[UIImage imageNamed:@"settlement_choose_n"] forState:UIControlStateNormal];
    [chooseState setBackgroundImage:[UIImage imageNamed:@"settlement_unchoose_n"] forState:UIControlStateNormal];
}

-(void)goPay{
    [moneyTextFD resignFirstResponder];
    if (moneyTextFD.text.length==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请输入金额", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        [hud hideAnimated:YES afterDelay:2.f];
    }else{
       
        
        
        if (payIndex==1) {
            //alipay
            [self initAlipayInfo];
        }else if (payIndex==2){
            //yinlian pay
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            appdelegate.moneyText=moneyTextFD.text;
            [self postPaymentsRequest];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"请选择支付方式", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            [hud hideAnimated:YES afterDelay:2.f];
        }
    }
    
}
-(void)postPaymentsRequest
{
    
    NSString *url = @"http://101.201.100.191//upacp_demo_app/demo/api_05_app/TPConsume.php";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:appdelegate.userInfoDic[@"nickname"] forKey:@"nickname"];
    
    NSDateFormatter* matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date  = [NSDate date];
    NSString *NowDate = [matter stringFromDate:date];
    [params setObject:NowDate forKey:@"datetime"];
    
    [params setObject:@"余额充值" forKey:@"type"];
    [params setObject:moneyTextFD.text forKey:@"sum"];
    [params setObject:@"null" forKey:@"pay_type"];
    
    
    NSInteger actMoney1 =[moneyTextFD.text floatValue]*100;
    NSString *actMoney = [[NSString alloc]initWithFormat:@"%ld",actMoney1];
    [params setObject:actMoney forKey:@"txnAmt"];
    
    
    NSLog(@"params---%@",params);
    
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSArray *arr = result;
        
#ifdef DEBUG
        [[UPPaymentControl defaultControl] startPay:[arr objectAtIndex:0] fromScheme:@"blectShop" mode:@"01" viewController:self];
        
        
#else
        [[UPPaymentControl defaultControl] startPay:[arr objectAtIndex:0] fromScheme:@"blectShop" mode:@"00" viewController:self];
        
        
#endif
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(void)initAlipayInfo{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSLog(@"%@",appdelegate.nowpayCardArray);
    appdelegate.whoPay = 3;//我的钱包充值
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = kAlipayPartner;
    order.sellerID = kAlipaySeller;
    int x= arc4random()%100000;
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@",@"null",@"余额充值",appdelegate.userInfoDic[@"uuid"],moneyTextFD.text,appdelegate.userInfoDic[@"nickname"] ];
    
    NSString *outtrade =[[NSString alloc]initWithFormat:@"%@%5d",dateString,x];
    NSLog(@"%@",outtrade);
    order.outTradeNO = outtrade; //订单ID（由商家自行制定）
    order.subject = @"充值"; //商品标题
    //order.productDescription = wareOrderInfo.orderDescription; //商品描述
    //float price =[self.moneyText.text floatValue];
    order.totalFee = moneyTextFD.text;
    order.notifyURL =  kAlipayCallBackURL; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"blectShop";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(kAlipayPrivateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
         {
             NSLog(@"reslut = %@",resultDic);
             NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
             if (orderState==9000) {
                 //支付成功,这里放你们想要的操作
                 
                 NewRechargeSuccessVC *VC = [[NewRechargeSuccessVC alloc]init];
                 VC.money_s = [NSString stringWithFormat:@"¥%@",moneyTextFD.text];
                 [self.navigationController pushViewController:VC animated:YES];
//                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"您已成功支付啦!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                 
//                 [alert show];
                 
             }else{
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃当前交易?" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"去支付", nil];
                 alert.tag =1111;
                 [alert show];
                 
             }
             
             
         }];
        
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag ==1111) {
        if (buttonIndex ==1) {
            
            if (payIndex==1) {
                [self initAlipayInfo];
            }else if (payIndex==2){
                [self postPaymentsRequest];
            }
            
        }
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
