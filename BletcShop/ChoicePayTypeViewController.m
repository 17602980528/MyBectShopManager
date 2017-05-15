//
//  ChoicePayTypeViewController.m
//  BletcShop
//
//  Created by Bletc on 16/6/22.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ChoicePayTypeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "RechargeViewController.h"
#import "UPPaymentControl.h"
@interface ChoicePayTypeViewController ()
{
    NSArray *orderType_A;////1-买卡  2-续卡 3-充值 4-升级

}
@end

@implementation ChoicePayTypeViewController


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
        
        if (self.orderInfoType==4) {
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

            NSMutableDictionary  *card_dic = [NSMutableDictionary dictionaryWithDictionary:appdelegate.cardInfo_dic];
            
            [card_dic setValue:appdelegate.payCardType forKey:@"card_level"];
            appdelegate.cardInfo_dic =  card_dic;
            
        }

        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"您已成功支付啦!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _inittable];
    self.navigationItem.title = @"支付方式";
    orderType_A = @[@"",@"办卡",@"续卡",@"充值",@"升级"];

}
-(void)_inittable
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = 104;
    table.bounces = NO;
    self.myTable = table;
    [self.view addSubview:table];
}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 3;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *imgArr1 = @[@"alipay_img",@"unionpay_img",@"wechat_img"];
    NSArray *fontArr1 = @[@"支付宝支付",@"银联支付",@"微信支付"];
    if (indexPath.row==2) {
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        imageView.image = [UIImage imageNamed:imgArr1[indexPath.row]];
        [cell addSubview:imageView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 1000, 50)];
        label.text =fontArr1[indexPath.row];
        label.font = [UIFont systemFontOfSize:13];
        [cell addSubview:label];
        
    }else{
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 40)];
        imageView.image = [UIImage imageNamed:imgArr1[indexPath.row]];
        [cell addSubview:imageView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 1000, 50)];
        label.text =fontArr1[indexPath.row];
        label.font = [UIFont systemFontOfSize:13];
        [cell addSubview:label];
    }
    
    UIView *lineAdv = [[UIView alloc]initWithFrame:CGRectMake(0, 70, SCREENWIDTH, 0.3)];
    lineAdv.backgroundColor = [UIColor grayColor];
    lineAdv.alpha = 0.3;
    [cell addSubview:lineAdv];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appdelegate.paymentType = self.orderInfoType;
    if (indexPath.row==0) {

        
        
        [self initAlipayInfo];
        
    }else if (indexPath.row==1) {
       
        
        [self postPaymentsRequest];
    }
    else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //            hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"功能尚未开通,敬请期待", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }
    
}

/**
 银联支付
 */
-(void)postPaymentsRequest
{
    orderType_A = @[@"",@"办卡",@"续卡",@"充值",@"升级"];
#ifdef DEBUG
    NSString *url = @"http://101.201.100.191//unionpay/demo/api_05_app/TPConsume.php";
    
    
#else
    NSString *url = @"http://101.201.100.191//upacp_demo_app/demo/api_05_app/TPConsume.php";
    
    
#endif
    
    
//    NSString *url = @"http://101.201.100.191//upacp_demo_app/demo/api_05_app/TPConsume.php";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.cardInfo_dic[@"merchant"] forKey:@"muid"];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
       [params setObject:appdelegate.cardInfo_dic[@"card_type"] forKey:@"cate"];
    
    //续卡
    if (self.orderInfoType==2) {
        
        [params setObject:appdelegate.cardInfo_dic[@"card_code"] forKey:@"cardCode"];
        [params setObject:appdelegate.cardInfo_dic[@"card_level"] forKey:@"cardLevel"];
        
    }
    //升级
    if (self.orderInfoType==4) {
        
        [params setObject:appdelegate.payCardType forKey:@"new_level"];
        
        [params setObject:appdelegate.cardInfo_dic[@"card_code"] forKey:@"cardCode"];
        [params setObject:appdelegate.cardInfo_dic[@"card_level"] forKey:@"cardLevel"];
        
    }

    
    
    [params setObject:orderType_A[self.orderInfoType] forKey:@"type"];
    //实际支付价格.没有×100
    [params setObject:self.moneyString forKey:@"sum"];
    [params setObject:self.pay_Type forKey:@"pay_type"];
    
    if ([self.pay_Type isEqualToString:@"voucher"]) {
        [params setObject:self.coup_dic[@"type"] forKey:@"content"];
        
    }else if ([self.pay_Type isEqualToString:@"integral"]) {
        
        [params setObject:self.point forKey:@"content"];
    }
    else{
    }
    //实付金额×100
    NSInteger actMoney1 =[self.actualMoney floatValue]*100;
    NSString *actMoney = [[NSString alloc]initWithFormat:@"%ld",actMoney1];
    [params setObject:actMoney forKey:@"txnAmt"];
    [params setObject:appdelegate.cardInfo_dic[@"card_image_url"] forKey:@"image_url"];
    
    
    NSLog(@"params-----%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        NSArray *arr = result;
        
#ifdef DEBUG
        [[UPPaymentControl defaultControl] startPay:[arr objectAtIndex:0] fromScheme:@"blectShop" mode:@"01" viewController:self];
        
        
#else
        [[UPPaymentControl defaultControl] startPay:[arr objectAtIndex:0] fromScheme:@"blectShop" mode:@"00" viewController:self];
        
        
#endif
        
        
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error%@", error);
        
    }];
    
}
- (void)handlePaymentResult:(NSURL*)url completeBlock:(UPPaymentResultBlock)completionBlock
{
    
}
-(void)initAlipayInfo{
    orderType_A = @[@"",@"办卡",@"续卡",@"充值",@"升级"];

    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    appdelegate.whoPay =self.orderInfoType;//办卡
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
    
    
    //    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    //    NSInteger date = (long long int)time;
    NSString *outtrade =[[NSString alloc]initWithFormat:@"%@%5d",dateString,x];
    NSLog(@"%@",outtrade);
    order.outTradeNO = outtrade; //订单ID（由商家自行制定）
    order.subject = orderType_A[self.orderInfoType]; //商品标题
    
    //升级
    if (self.orderInfoType==4) {
        if ([self.pay_Type isEqualToString:@"voucher"]) {
            
            
            order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@",self.pay_Type,orderType_A[self.orderInfoType],appdelegate.cardInfo_dic[@"card_code"],appdelegate.cardInfo_dic[@"card_level"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],self.moneyString,appdelegate.payCardType,self.coup_dic[@"type"]];

            
        }else if ([self.pay_Type isEqualToString:@"integral"]) {
            
            
            order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@",self.pay_Type,orderType_A[self.orderInfoType],appdelegate.cardInfo_dic[@"card_code"],appdelegate.cardInfo_dic[@"card_level"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],self.moneyString,appdelegate.payCardType,self.point];

            
        }else if ([self.pay_Type isEqualToString:@"null"])
        {
            
            order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@",self.pay_Type,orderType_A[self.orderInfoType],appdelegate.cardInfo_dic[@"card_code"],appdelegate.cardInfo_dic[@"card_level"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],self.moneyString,appdelegate.payCardType];
        }

        
    }else{
        
    if ([self.pay_Type isEqualToString:@"voucher"]) {
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@",self.pay_Type,orderType_A[self.orderInfoType],appdelegate.cardInfo_dic[@"card_code"],appdelegate.cardInfo_dic[@"card_level"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],appdelegate.cardInfo_dic[@"price"],self.coup_dic[@"type"]];

        
    }else if ([self.pay_Type isEqualToString:@"integral"]) {
        
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@",self.pay_Type,orderType_A[self.orderInfoType],appdelegate.cardInfo_dic[@"card_code"],appdelegate.cardInfo_dic[@"card_level"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],appdelegate.cardInfo_dic[@"price"],self.point];

        
    }else if ([self.pay_Type isEqualToString:@"null"])
    {
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@",self.pay_Type,orderType_A[self.orderInfoType],appdelegate.cardInfo_dic[@"card_code"],appdelegate.cardInfo_dic[@"card_level"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],appdelegate.cardInfo_dic[@"price"]];
    }
    
}

    NSLog(@"order.body====%@",order.body);
    
    //order.productDescription = wareOrderInfo.orderDescription; //商品描述
    //float price =[self.moneyText.text floatValue];
    order.totalFee = self.actualMoney;//[NSString stringWithFormat:@"%lf",price]; //商品价格
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
             NSLog(@"ChoicePayTypeViewControllerreslut = %@",resultDic);
             NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
             if (orderState==9000) {
                 //支付成功,这里放你们想要的操作
                
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"您已成功支付啦!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                 
                 [alert show];
                 
             }else{
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                 
                 [alert show];
                 
             }
             
                         
         }];
        
   
    }
    
}
- (void)processOrderWithPaymentResult:(NSURL *)resultUrl
                      standbyCallback:(CompletionBlock)completionBlock
{
    
}
- (void)payOrder:(NSString *)orderStr
      fromScheme:(NSString *)schemeStr
        callback:(CompletionBlock)completionBlock;
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

