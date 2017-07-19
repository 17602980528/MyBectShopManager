//
//  BuyCardChoicePayViewController.m
//  BletcShop
//
//  Created by Bletc on 16/6/22.
//  Copyright © 2016年 bletc. All rights reserved.
//

/**
 *  支付方式
 *
 *
 */
#import "BuyCardChoicePayViewController.h"
#import "CardInfoViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "UPPaymentControl.h"
@interface BuyCardChoicePayViewController ()
{
    NSArray *orderType_A;////1-买卡  2-续卡 3-充值 4-升级
}
@end

@implementation BuyCardChoicePayViewController

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

//       DebugLog(@"notification-----%@",notification);
}
-(void)showtishi:(BOOL)payResult{
    
    if (payResult) {
        
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
    // Do any additional setup after loading the view.
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
    if (indexPath.row==0) {
//        [self.navigationController popViewControllerAnimated:NO];

        
        [self initAlipayInfo];
        
    }else if (indexPath.row==1) {
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        appdelegate.paymentType =1;

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
    [params setObject:appdelegate.cardInfo_dic[@"code"] forKey:@"code"];
    [params setObject:appdelegate.cardInfo_dic[@"level"] forKey:@"level"];
    [params setObject:appdelegate.cardInfo_dic[@"type"] forKey:@"cate"];

    
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
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSLog(@"appdelegate.cardInfo_dic==%@",appdelegate.cardInfo_dic);
    appdelegate.whoPay =1;//办卡
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
    dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    //    NSInteger date = (long long int)time;
    NSString *outtrade =[[NSString alloc]initWithFormat:@"%@%5d",dateString,x];
    NSLog(@"%@",outtrade);
    order.outTradeNO = outtrade; //订单ID（由商家自行制定）
    order.subject = @"办卡"; //商品标题
    if ([self.pay_Type isEqualToString:@"voucher"]) {
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@#%@",self.pay_Type,@"办卡",appdelegate.cardInfo_dic[@"code"],appdelegate.cardInfo_dic[@"level"],appdelegate.cardInfo_dic[@"type"],appdelegate.cardInfo_dic[@"card_image_url"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],appdelegate.cardInfo_dic[@"price"],self.coup_dic[@"type"]];

    }else if ([self.pay_Type isEqualToString:@"integral"]) {

        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@#%@",self.pay_Type,@"办卡",appdelegate.cardInfo_dic[@"code"],appdelegate.cardInfo_dic[@"level"],appdelegate.cardInfo_dic[@"type"],appdelegate.cardInfo_dic[@"card_image_url"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],appdelegate.cardInfo_dic[@"price"],self.point];

    }else if ([self.pay_Type isEqualToString:@"null"])
    {
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@",self.pay_Type,@"办卡",appdelegate.cardInfo_dic[@"code"],appdelegate.cardInfo_dic[@"level"],appdelegate.cardInfo_dic[@"type"],appdelegate.cardInfo_dic[@"card_image_url"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],appdelegate.cardInfo_dic[@"price"]];
    }
    

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
            NSLog(@"BuyCardChoicePayViewControllerreslut = %@",resultDic);
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            if (orderState==9000) {
//                //支付成功,这里放你们想要的操作
//            CardInfoViewController *setPrizeVC = [[CardInfoViewController alloc]init];;
//                //初始化其属性
//                setPrizeVC.isPaySuccess = 0;
//                //传递参数过去
//                setPrizeVC.isPaySuccess = 1;
//            [setPrizeVC postRequest];
//                //使用popToViewController返回并传值到上一页面
////                [self.navigationController popToViewController:setPrizeVC animated:true];
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"您已成功支付啦!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                
                [alert show];

            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                
                [alert show];

            }
            
            
            
        }];
        
        //self.navigationController popViewControllerAnimated:YES];
//        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//        if (appdelegate.isAli) {
//            NSLog(@"顶顶顶顶顶顶顶顶顶顶顶顶顶顶");
//        }
        
        //       [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
