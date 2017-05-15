//
//  CommenShowPublishAdvertInfosVC.m
//  BletcShop
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CommenShowPublishAdvertInfosVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "UPPaymentControl.h"
@interface CommenShowPublishAdvertInfosVC ()
{
    NSArray *dataSourse_A;
    NSArray *data_A;
    UIView *buyView;
    UIButton *selectBtn;
}
@property(nonatomic,strong)NSArray *section1_A;
@property(nonatomic,strong)NSArray *section2_A;
@end

@implementation CommenShowPublishAdvertInfosVC

-(NSArray *)section1_A{
    if (!_section1_A) {
        _section1_A = @[@"商家名称",@"广告类型",@"广告地区",@"活动类型",@"广告位置"];
    }
    return _section1_A;
}
-(NSArray *)section2_A{
    if (!_section2_A) {
        _section2_A = @[@"提交日期",@"收费方式",@"购买次数 ",@"实付金额"];
    }
    return _section2_A;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:ORDER_PAY_NOTIFICATION object:nil];//监听一个通知
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    CGRect frame = buyView.frame;
    frame.origin.y = SCREENHEIGHT;
    buyView.frame = frame;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"广告列表";
    NSLog(@"====>>>%@",self.infoDic);
    dataSourse_A = @[self.section1_A,self.section2_A];
    NSString *type=self.infoDic[@"pay_type"];
    NSString *counts=self.infoDic[@"pay_content"];
    if ([type isEqualToString:@"click"]) {
        type=@"按点击量";
        counts=[NSString stringWithFormat:@"%@次",counts];
    }else{
        type=@"按天数";
        counts=[NSString stringWithFormat:@"%@天",counts];
    }
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([_infoDic[@"mark"] isEqualToString:@"near"]) {
        data_A = @[@[appdelegate.shopInfoDic[@"store"],_infoDic[@"advert_cate"],_infoDic[@"address"],@"周边",_infoDic[@"position"]],@[_infoDic[@"datetime"],type,counts,_infoDic[@"sum"]]];
    }else{
        data_A = @[@[appdelegate.shopInfoDic[@"store"],_infoDic[@"advert_cate"],_infoDic[@"address"],_infoDic[@"advert_type"],_infoDic[@"position"]],@[_infoDic[@"datetime"],type,counts,_infoDic[@"sum"]]];
    }
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = RGB(240, 240, 240);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 35 ;
    
    [self creatBuyView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataSourse_A.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else{
        return SCREENHEIGHT -64- tableView.contentSize.height;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT -64- tableView.contentSize.height);
        view.backgroundColor = [UIColor whiteColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(25, 20, SCREENWIDTH-50, 44);
        button.backgroundColor = NavBackGroundColor;
        [button setTitle:@"立即支付" forState:0];
        button.layer.cornerRadius = 4;
        [button addTarget:self action:@selector(gotopay) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        if ([self.applyState isEqualToString:@"WAIT_FOR_PAY"]) {
            button.hidden=NO;
        }else{
            button.hidden=YES;
        }
        return view;
    }else return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = dataSourse_A[section];
    
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GotopayFor";
    UILabel *leftLab;
    UILabel *rightLab;
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        leftLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
        leftLab.font = [UIFont systemFontOfSize:15];
        leftLab.textColor = RGB(102,102,102);
        leftLab.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:leftLab];
        
        
        rightLab = [[UILabel alloc]initWithFrame:CGRectMake(leftLab.right+15, 0, SCREENWIDTH-leftLab.right-15, leftLab.height)];
        rightLab.font = [UIFont systemFontOfSize:15];
        rightLab.textColor = RGB(102,102,102);
        rightLab.textAlignment = NSTextAlignmentLeft;
        rightLab.text = @"西安市高新区富鱼路";
        
        [cell.contentView addSubview:rightLab];
        
        
    }
    
    leftLab.text = dataSourse_A[indexPath.section][indexPath.row];
    rightLab.text = data_A[indexPath.section][indexPath.row];
    
    if (indexPath.section==1 && indexPath.row ==5) {
        rightLab.textColor = RGB(215,32,32);
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//弹出pay页面
-(void)gotopay{
    
    [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = buyView.frame;
            frame.origin.y = 0;
            buyView.frame = frame;
        }];
   
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
    pricelab.text = [NSString stringWithFormat:@"%@元",_infoDic[@"sum"]];
    pricelab.textColor = RGB(51,51,51);
    pricelab.font = [UIFont systemFontOfSize:21];
    pricelab.textAlignment = NSTextAlignmentRight;
    [backView addSubview:pricelab];
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buyButton.frame = CGRectMake(49, 340-44-20, SCREENWIDTH-49*2, 44);
    buyButton.backgroundColor = NavBackGroundColor;
    [buyButton setTitle:@"付款" forState:0];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:17];
    buyButton.layer.cornerRadius = 4;
    [backView addSubview:buyButton];
    [buyButton addTarget:self action:@selector(goBuy) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)cancleClick{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = buyView.frame;
        frame.origin.y = SCREENHEIGHT;
        buyView.frame = frame;
    }];
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
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"您已成功支付啦!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
        if (_dele && [_dele respondsToSelector:@selector(refreshTableView)]){
            [_dele refreshTableView];
        }
        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃当前交易?" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"去支付", nil];
        alert.tag =1111;
        [alert show];
        
    }
    
    
}
-(void)goBuy{
    [self gotoPay];
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
//    NSString *url ;
//    url = @"http://101.201.100.191/upacp_demo_app/demo/api_05_app/AdvertPay.php";
    
#ifdef DEBUG
    NSString *url = @"http://101.201.100.191//unionpay/demo/api_05_app/AdvertPay.php";
    
    
#else
    NSString *url = @"http://101.201.100.191//upacp_demo_app/demo/api_05_app/AdvertPay.php";
    
    
#endif
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setValue:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setValue:_infoDic[@"mark"] forKey:@"type"];
    if ([_infoDic[@"mark"] isEqualToString:@"near"]) {
        [params setValue:_infoDic[@"address"] forKey:@"id"];
    }else{
         [params setValue:_infoDic[@"id"] forKey:@"id"];
    }
    [params setValue:_infoDic[@"position"] forKey:@"position"];
    NSString *money=[NSString stringWithFormat:@"%ld",[_infoDic[@"sum"]integerValue]*100];
    [params setValue:money forKey:@"sum"];
    [params setValue:_infoDic[@"advert_cate"] forKey:@"des"];
    
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
    order.subject = _infoDic[@"advert_cate"]; //商品标题
    order.notifyURL =  @"http://101.201.100.191/alipay/advert_notify_urlphp"; //回调URL
    order.totalFee = _infoDic[@"sum"];
    NSString *idss;
    if ([_infoDic[@"mark"] isEqualToString:@"near"]) {
        idss=_infoDic[@"address"];
    }else{
        idss=_infoDic[@"id"];
    }
    order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#",_infoDic[@"advert_cate"],idss,appdelegate.shopInfoDic[@"muid"],_infoDic[@"position"]];
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
