//
//  CardmarketDetailVC.m
//  BletcShop
//
//  Created by Bletc on 2017/1/16.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CardmarketDetailVC.h"
#import "CardMarketCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "UPPaymentControl.h"
#import "LandingController.h"

@interface CardmarketDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *table_View;
    UIView *buyView;
    
    UIButton *selectBtn;
    NSString *priceString;
    
    UITextField *priceTextField;
    UILabel *serviceLab;
    UILabel *zheLab;
    UILabel *allpayLab;

    NSString *serviceCharge_s;//手续费
    NSString *chargeMoney;//折后价
    NSString *allPayMoney;//总价

    
}
@property(nonatomic,strong)UILabel *moneyLabel;


@end

@implementation CardmarketDetailVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:ORDER_PAY_NOTIFICATION object:nil];//监听一个通知

    
   
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    //[buyView removeFromSuperview];
    CGRect frame = buyView.frame;
    frame.origin.y = SCREENHEIGHT;
    buyView.frame = frame;
    
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
        
//        
//        PaySuccessVc *VC = [[PaySuccessVc alloc]init];
//        VC.orderInfoType = self.orderInfoType;
//        VC.card_dic = self.card_dic;
//        VC.type_new = self.level;
//        VC.money_str = [self.actualMoney substringFromIndex:5];
//        
//        [self.navigationController pushViewController:VC animated:YES];
        
        
        
        
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"您已成功支付啦!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
                [alert show];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃当前交易?" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"去支付", nil];
        alert.tag =1111;
        [alert show];
        
    }
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"卡市";
    self.view.backgroundColor = RGB(240, 240, 240);

    priceString = [NSString stringWithFormat:@"%.2f",[_model.card_remain floatValue]*[_model.rate floatValue]*0.01];

    [self initTableView];
    
}

-(void)initTableView{
 
    
    table_View = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, SCREENHEIGHT-10-49) style:UITableViewStyleGrouped];
    table_View.dataSource = self;
    table_View.delegate = self;
    table_View.separatorStyle= UITableViewCellSeparatorStyleNone;
    table_View.estimatedRowHeight = 92;
    table_View.bounces = NO;
    
    [self.view addSubview: table_View];
    
    
    
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-49-64, SCREENWIDTH, 49)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    
    UIButton *jiesuanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    jiesuanBtn.frame=CGRectMake(SCREENWIDTH-90, 0, 90, 49);
    [jiesuanBtn setTitle:@"我想要" forState:UIControlStateNormal];
    jiesuanBtn.backgroundColor=NavBackGroundColor;
    [jiesuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footView addSubview:jiesuanBtn];
    [jiesuanBtn addTarget:self action:@selector(goJieSuan) forControlEvents:UIControlEventTouchUpInside];
    

    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-100, 49)];
    moneyLabel.text=[NSString stringWithFormat:@"付款:%@",priceString];
    self.moneyLabel=moneyLabel;
    moneyLabel.textAlignment=NSTextAlignmentRight;
    moneyLabel.font=[UIFont systemFontOfSize:15.0f];
    [footView addSubview:moneyLabel];
    
    if ([_model.method isEqualToString:@"share"]) {
        moneyLabel.hidden = YES;
    }

    [self creatBuyView];
  
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    
    return self.model.cellHight;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CardMarketCell *cell = [CardMarketCell creatCellWithTableView:tableView];
    cell.model = self.model;
//    cell.pricelab.hidden = YES;
    
    return cell;
}

-(void)creatBuyView{
    
    buyView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT)];
    buyView.backgroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:0.7];
    
    
    UIWindow *curent_window = [UIApplication sharedApplication].keyWindow;
    
    [curent_window addSubview: buyView];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT- 340, SCREENWIDTH, 500)];
    backView.backgroundColor = [UIColor whiteColor];
    [buyView addSubview:backView];
    
    UIImageView *cancelImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 14, 15, 15)];
//    cancelImg.backgroundColor = [UIColor redColor];
    cancelImg.image = [UIImage imageNamed:@"card_icon_close"];
    [backView addSubview:cancelImg];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 38)];
    titleLab.text = @"支付方式";;
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textColor = RGB(51,51,51);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.userInteractionEnabled = YES;
    [backView addSubview:titleLab];
    
    
   

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, titleLab.bottom, SCREENWIDTH-24, 1)];
    line.backgroundColor = RGB(234,234,234);
    [backView addSubview:line];
    
    
    for (int i = 0; i <2; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, line.bottom+51*i+(51-31)/2, 31, 31)];
        [backView addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, line.bottom+51*i, 100, 51)];
        lable.textColor = RGB(51,51,51);
        lable.font = [UIFont systemFontOfSize:15];
        lable.numberOfLines=0;
        [backView addSubview:lable];
        
      
        
        UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, line.bottom+51*i, SCREENWIDTH, 51);
        [button addTarget:self action:@selector(chosePayType:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        button.tag = i;
        
        UIImageView *image_select = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-30-13, (51-30)/2, 30, 30)];
        [button addSubview:image_select];
        
        if (i ==0) {
            lable.text = @"支付宝支付";
            image_select.image = [UIImage imageNamed:@"settlement_choose_n"];
                
            imageView.image = [UIImage imageNamed:@"settlement_alipay_n"];
            
            selectBtn = button;
            
        }else{
            lable.text = @"银联支付";
            imageView.image = [UIImage imageNamed:@"settlement_unionpay_n"];
            image_select.image = [UIImage imageNamed:@"settlement_unchoose_n"];
            
            }
            
            
        }
        
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleClick)];
    [titleLab addGestureRecognizer:tap];
    
    
    
    UILabel *moneylab = [[UILabel alloc]initWithFrame:CGRectMake(17, line.bottom +51*2+20, 150, 14)];
    moneylab.text = @"支付金额：";
    moneylab.textColor = RGB(51,51,51);
    moneylab.font = [UIFont systemFontOfSize:15];
    [backView addSubview:moneylab];
    
    
   
    
    UILabel *pricelab = [[UILabel alloc]initWithFrame:CGRectMake(0, line.bottom +51*2+17, SCREENWIDTH-24, 19)];
    pricelab.text = [NSString stringWithFormat:@"%@元",priceString];
    pricelab.textColor = RGB(51,51,51);
    pricelab.font = [UIFont systemFontOfSize:21];
    pricelab.textAlignment = NSTextAlignmentRight;
    [backView addSubview:pricelab];
    
    
    if ([_model.method isEqualToString:@"share"]) {
        moneylab.text = @"输入支付金额：";;
        pricelab.hidden = YES;
        
        priceTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, line.bottom +51*2+17, SCREENWIDTH-24, 19)];
        priceTextField.placeholder = @"请输入消费金额";
        priceTextField.delegate = self;
        priceTextField.textColor = RGB(51,51,51);
        priceTextField.font = [UIFont systemFontOfSize:15];
        priceTextField.textAlignment = NSTextAlignmentRight;
        priceTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        priceTextField.returnKeyType = UIReturnKeyDone;
        [backView addSubview:priceTextField];
        
        zheLab = [[UILabel alloc]initWithFrame:CGRectMake(17, moneylab.bottom +15, 300, 14)];
        zheLab.text = @"折后价格:0.00";
        zheLab.font = [UIFont systemFontOfSize:13];
        zheLab.textColor = RGB(51, 51, 51);
        [backView addSubview:zheLab];
        
        serviceLab = [[UILabel alloc]initWithFrame:CGRectMake(17, zheLab.bottom +10, 150, 14)];
        serviceLab.text = [NSString stringWithFormat:@"手续费(%@%%):0.00",_model.rate];
        serviceLab.font = [UIFont systemFontOfSize:13];
        serviceLab.textColor = RGB(51, 51, 51);
        [backView addSubview:serviceLab];
    
    
         allpayLab = [[UILabel alloc]initWithFrame:CGRectMake(17, moneylab.bottom +15, SCREENWIDTH - 30, 20)];
        allpayLab.text = @"实际支付:0.00";
        allpayLab.font = [UIFont systemFontOfSize:21];
        allpayLab.textColor = RGB(51, 51, 51);
        allpayLab.textAlignment = NSTextAlignmentRight;
        [backView addSubview:allpayLab];
        
        NSMutableAttributedString *mbas = [[NSMutableAttributedString alloc]initWithString:allpayLab.text];
        [mbas setAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} range:NSMakeRange(0, 5)];
        allpayLab.attributedText = mbas;
    }
  
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buyButton.frame = CGRectMake(49, 340-44-20, SCREENWIDTH-49*2, 44);
    buyButton.backgroundColor = NavBackGroundColor;
    [buyButton setTitle:@"付款" forState:0];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:17];
    buyButton.layer.cornerRadius = 4;
    [backView addSubview:buyButton];
    [buyButton addTarget:self action:@selector(goBuy) forControlEvents:UIControlEventTouchUpInside];
    

    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = buyView.frame;
        frame.origin.y = -150;
        buyView.frame = frame;
    }];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    float mm = [priceTextField.text floatValue]*[_model.rule floatValue]*0.01;
    
    chargeMoney = [NSString stringWithFormat:@"%.2f",mm];

    
    zheLab.text = [NSString stringWithFormat:@"折后价格:%@",chargeMoney];

    float serviceCharge = [priceTextField.text floatValue]*[_model.rate floatValue]*0.01;
    
   serviceCharge_s = [NSString stringWithFormat:@"%.2f",serviceCharge];
    
    serviceLab.text = [NSString stringWithFormat:@"手续费(%@%%):%@",_model.rate,serviceCharge_s];
    
    allPayMoney = [NSString stringWithFormat:@"%.2f",mm +serviceCharge];
    
    allpayLab.text = [NSString stringWithFormat:@"实际支付:%@",allPayMoney];
    
    NSMutableAttributedString *mbas = [[NSMutableAttributedString alloc]initWithString:allpayLab.text];
    [mbas setAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} range:NSMakeRange(0, 5)];
    allpayLab.attributedText = mbas;

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self goJieSuan];

    return  YES;
}

-(void)chosePayType:(UIButton*)sender{
    
    for (UIView *subV  in selectBtn.subviews) {
        if ([subV isKindOfClass:[UIImageView class]]) {
            UIImageView *imgV = (UIImageView *)subV;
            imgV.image = [UIImage imageNamed:@"settlement_unchoose_n"];
        }
        
    }

    for (UIView *subV  in sender.subviews) {
        if ([subV isKindOfClass:[UIImageView class]]) {
            UIImageView *imgV = (UIImageView *)subV;
            imgV.image = [UIImage imageNamed:@"settlement_choose_n"];
        }
        
    }
    selectBtn = sender;
    
    
}
-(void)cancleClick{
    
    if (priceTextField) {
        [priceTextField resignFirstResponder];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = buyView.frame;
        frame.origin.y = SCREENHEIGHT;
        buyView.frame = frame;
    }];
}
-(void)goJieSuan{
    
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (!appdelegate.IsLogin) {
        LandingController *landVc = [[LandingController alloc]init];
        [self.navigationController pushViewController:landVc animated:YES];
    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = buyView.frame;
            frame.origin.y = 0;
            buyView.frame = frame;
        }];

    }
   }

//付款
-(void)goBuy{
    
    NSLog(@"=====%ld",selectBtn.tag);
    
    
    if (priceTextField ) {
        
        if ( (priceTextField.text.length ==0)) {
            [self showHint:@"请输入金额"];

        } else if (![NSString isPureInt:priceTextField.text]  && ![NSString isPureFloat:priceTextField.text]){
            [self showHint:@"请输入数字"];
            
        }else{
            
            if ([chargeMoney floatValue] >[_model.card_remain floatValue]) {
                [self showHint:@"会员卡余额不足!"];
                
                
            }else{
                
                [self gotoPay];

            }

        }
    }
    else{
        
        [self gotoPay];
        
    }
    
    
   
    
}

-(void)gotoPay{
    
    [self cancleClick];

        switch (selectBtn.tag) {
            case 0:
                [self initAlipayInfo];
                break;
            case 1:
                [self postPaymentsRequest];
                break;
                
                
            default:
                break;
        }

  
   
}


/**
 银联支付
 */
-(void)postPaymentsRequest
{
    
//    NSString *url = @"http://101.201.100.191//upacp_demo_app/demo/api_05_app/TPConsume.php";
    NSString *url ;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    [params setValue:appdelegate.userInfoDic[@"uuid"] forKey:@"b_uuid"];
    [params setValue:_model.uuid forKey:@"s_uuid"];
    [params setValue:_model.muid forKey:@"muid"];
    [params setValue:_model.card_code forKey:@"card_code"];
    [params setValue:_model.card_level forKey:@"card_level"];
    
    
    if ([_model.method isEqualToString:@"share"]) {
        NSLog(@"蹭卡");
        url = @"http://101.201.100.191//upacp_demo_app/demo/api_05_app/Share.php";
        
        [params setValue:_model.card_type forKey:@"card_type"];
        [params setValue:allPayMoney forKey:@"b_sum"];
        
        
        
        [params setValue:chargeMoney forKey:@"s_sum"];
        
    }else{
        NSLog(@"买二手卡");
        url = @"http://101.201.100.191//upacp_demo_app/demo/api_05_app/Transfer.php";
        
        [params setValue:priceString forKey:@"sum"];
        
    }
    
    
    
    
    NSLog(@"params-----%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"银联支付===%@", result);
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
    
    NSLog(@"UPPaymentResultBlock====%@",completionBlock);
    
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
    
    
    //    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    //    NSInteger date = (long long int)time;
    NSString *outtrade =[[NSString alloc]initWithFormat:@"%@%5d",dateString,x];
    NSLog(@"%@",outtrade);
    order.outTradeNO = outtrade; //订单ID（由商家自行制定）
    
    

    

    if ([_model.method isEqualToString:@"share"]) {
        NSLog(@"蹭卡");
        order.subject = @"蹭卡"; //商品标题

        order.notifyURL =  @"http://101.201.100.191/alipay/share_notify_url.php"; //回调URL
        
        
//        float serviceCharge = [priceTextField.text floatValue]*[_model.rate floatValue]*0.01;
//        NSString *serviceCharge_s = [NSString stringWithFormat:@"%f",serviceCharge];
        
        order.totalFee = allPayMoney;


        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@",_model.uuid,appdelegate.userInfoDic[@"uuid"],_model.muid,_model.card_code,_model.card_level,_model.card_type,priceTextField.text,chargeMoney];


    }else{
        NSLog(@"买二手卡");
        order.subject = @"购买二手卡"; //商品标题

        order.notifyURL =  @"http://101.201.100.191/alipay/transfer_notify_url.php"; //回调URL
        order.totalFee = priceString;
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@",_model.uuid,appdelegate.userInfoDic[@"uuid"],_model.muid,_model.card_code,_model.card_level,priceString];

    }

    
    NSLog(@"order.body====%@",order.body);
    
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
                 
//                 PaySuccessVc *VC = [[PaySuccessVc alloc]init];
//                 VC.orderInfoType = self.orderInfoType;
//                 VC.card_dic = self.card_dic;
//                 VC.money_str = [self.contentLabel.text substringFromIndex:4];
//                 
//                 [self.navigationController pushViewController:VC animated:YES];
                 
                 
                                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"您已成功支付啦!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                 
                                  [alert show];
                 
             }else{
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃当前交易?" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"去支付", nil];
                 alert.tag =1111;
                 [alert show];
//                 
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


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag ==1111) {
        if (buttonIndex ==1) {
            
            if (selectBtn.tag==0) {
                [self initAlipayInfo];
            }else if (selectBtn.tag==1){
                
                [self postPaymentsRequest];
            }
            
        }
    }
    
}

@end
