//
//  SettlementViewController.m
//  BletcShop
//
//  Created by Bletc on 2016/11/17.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "SettlementViewController.h"
#import "MyCashCouponViewController.h"
#import "UIImageView+WebCache.h"
#import "CardInfoViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "UPPaymentControl.h"
enum OrderTypes{
    
    Wares,
    points

};
 enum PayTypes {
    Alipay,
    UPPay,
} ;
@interface SettlementViewController ()<UITableViewDelegate,UITableViewDataSource,ViewControllerBDelegate>
{
    NSArray *orderType_A;////1-买卡  2-续卡 3-充值 4-升级

}
@property(nonatomic,weak)UITableView*table_view;
@property enum OrderTypes Type;

@property enum PayTypes payType;

@property(nonatomic,copy)NSString *allPoint;
@property float canUsePoint;
@property (nonatomic , strong) NSDictionary *coup_dic;// 优惠券信息
@property(nonatomic,strong)UILabel *actualMoney;//实际应付金额;

@property (nonatomic,retain)NSString *pay_Type;//（支付类型）=> “null"（不抵额）,"voucher”（用代金卷抵额）,“integral”（用乐点抵额）

@end

@implementation SettlementViewController
-(NSDictionary *)coup_dic{
    if (!_coup_dic) {
        _coup_dic = [NSDictionary dictionary];
    }
    return _coup_dic;
}

- (void)sendValue:(NSDictionary *)value
{
    self.coup_dic = value;
    
    {
        NSRange pend = [self.coup_dic[@"type"] rangeOfString:@"元"];
        NSString* price =[self.coup_dic[@"type"] substringToIndex:pend.location];
        if (!(([self.moneyString floatValue]*10/100)<[price floatValue])) {

           self.actualMoney.text = [[NSString alloc]initWithFormat:@"实付款:¥%.2f",([self.moneyString floatValue]-[price floatValue])];
        }else
        {
            self.actualMoney.text = [[NSString alloc]initWithFormat:@"实付款:¥%.2f",([self.moneyString floatValue]*90/100)];
            
        }
        NSLog(@"self.couponArray%@",self.coup_dic[@"type"]);
        
    }
    
    NSLog(@"ddddddd%@",self.coup_dic);
    self.Type = Wares;
    [self.table_view reloadData];
    
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"结算";
    orderType_A = @[@"",@"办卡",@"续卡",@"充值",@"升级"];
    self.pay_Type =@"null";

    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-49) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = 104;
    table.bounces = YES;
    self.table_view = table;
    [self.view addSubview:table];
    
    
    UIView *foot_view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-64-49, SCREENWIDTH, 49)];
    foot_view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:foot_view];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREENWIDTH-75, 0, 75, 49);
    button.backgroundColor= NavBackGroundColor;
    [button setTitle:@"结算" forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    [button addTarget:self action:@selector(settlementClick) forControlEvents:UIControlEventTouchUpInside];
    [foot_view addSubview:button];
    
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, button.left-20, 49)];
    [foot_view addSubview:lab];
    lab.text = [NSString stringWithFormat:@"实付款:¥%.2f",[self.card_dic[@"price"] floatValue]];
    lab.font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:lab.text];
    [attr setAttributes:@{NSForegroundColorAttributeName:RGB(102,102,102)} range:NSMakeRange(0, 4)];
    
    [attr setAttributes:@{NSForegroundColorAttributeName:RGB(51,51,51)} range:NSMakeRange(4, lab.text.length-4)];

    lab.attributedText = attr;
    
    lab.textAlignment = NSTextAlignmentRight;

    self.actualMoney = lab;
    [self postRequestPoints];

    
}
-(void)postRequestPoints
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountGet",BASEURL];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:@"integral" forKey:@"type"];
    

    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        
        self.allPoint = result[@"integral"];
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 40;
    }else {
        return 49;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 49;
    }else
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 85;
    }else if(indexPath.section==1){
        return 51;
    }else{
        return 54;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];

    if (section==0) {
        UIView*backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH,30)];
        backView.backgroundColor=[UIColor whiteColor];

        [view addSubview:backView];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 9, 14, 13)];
        imageView.image = [UIImage imageNamed:@"settlement_store_n"];
        [backView addSubview:imageView];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, 0, SCREENWIDTH-imageView.right, 30)];
        lab.textColor = RGB(51,51,51);
        lab.text = @"何君造型";
        lab.font = [UIFont systemFontOfSize:16];
        [backView addSubview:lab];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 29, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(220,220,220);
        [backView addSubview:line];

        
    }else{
        UIView*backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH,39)];
        backView.backgroundColor=[UIColor whiteColor];
        [view addSubview:backView];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, SCREENWIDTH, 39)];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textColor = RGB(102,102,102);
        [backView addSubview:lab];
        if (section==1) {
            lab.text = @"优惠方式";
        }else if (section==2){
            lab.text = @"支付方式";
        }
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 38, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(220,220,220);
        [backView addSubview:line];
        
    }
    return view;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (section==0) {
        UIView *view = [UIView new];
        UIView*backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,49)];
        backView.backgroundColor=[UIColor whiteColor];
        [view addSubview:backView];

        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-12,49)];
        [backView addSubview:lab];
        lab.text = [NSString stringWithFormat:@"合计:¥%@",[NSString getTheNoNullStr:self.card_dic[@"price"] andRepalceStr:@"0.00"]];
        lab.font = [UIFont systemFontOfSize:16];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:lab.text];
        [attr setAttributes:@{NSForegroundColorAttributeName:RGB(102,102,102)} range:NSMakeRange(0, 3)];
        [attr setAttributes:@{NSForegroundColorAttributeName:RGB(51,51,51)} range:NSMakeRange(3, lab.text.length-3)];

        lab.attributedText = attr;

        lab.textAlignment = NSTextAlignmentRight;

        
        return view;

    }else{
        return nil;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView*view in cell.contentView.subviews ) {
        [view removeFromSuperview];
    }
    
    
    if (indexPath.section ==0) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 102, 65)];
        NSString*imgstring = [NSString getTheNoNullStr:self.card_dic[@"card_image_url"] andRepalceStr:@""];
        
        if (imgstring.length>0) {
            NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCECARD stringByAppendingString:imgstring]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon2.png"] options:SDWebImageRetryFailed];

        }
        
        [cell.contentView addSubview:imgView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(imgView.right+10, 15, SCREENWIDTH-imgView.right-70-15, 30)];
        lable.text = [NSString getTheNoNullStr:self.card_dic[@"content"] andRepalceStr:@"暂无优惠!"];
        lable.textColor = RGB(51,51,51);
        lable.font = [UIFont systemFontOfSize:15];
        lable.numberOfLines=3;
        [cell.contentView addSubview:lable];
        
        CGFloat labHight = [lable.text boundingRectWithSize:CGSizeMake(lable.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lable.font} context:nil].size.height;
        CGRect frame = lable.frame;
        frame.size.height = labHight;
        lable.frame = frame;
        
        UILabel *price_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 17, SCREENWIDTH-13, 12)];
        price_lab.text = [NSString stringWithFormat:@"¥%@",[NSString getTheNoNullStr:self.card_dic[@"price"] andRepalceStr:@"0.00"]];
        price_lab.textColor = RGB(51,51,51);
        price_lab.font = [UIFont systemFontOfSize:15];
        price_lab.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:price_lab];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 85-1, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(220,220,220);
        [cell.contentView addSubview:line];
        
    }else if (indexPath.section==1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, (51-14)/2, 14, 14)];
        [cell.contentView addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, 0, 100, 51)];
        lable.textColor = RGB(51,51,51);
        lable.font = [UIFont systemFontOfSize:15];
        lable.numberOfLines=0;
        [cell.contentView addSubview:lable];
        
        UILabel *contentlabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-150, 51)];
        contentlabel.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:contentlabel];
        
        contentlabel.textAlignment = NSTextAlignmentRight;

        if (indexPath.row ==0) {
            lable.text = @"代金券";
            if (self.coup_dic.count>0) {
                if (self.Type == Wares) {
                    imageView.image = [UIImage imageNamed:@"settlement_choose_n"];
                    contentlabel.text = [[NSString alloc]initWithFormat:@"%@代金券",self.coup_dic[@"type"]];
                    
                }else{
                    imageView.image = [UIImage imageNamed:@"settlement_unchoose_n"];
                    
                }
                
            }else{
                imageView.image = [UIImage imageNamed:@"settlement_unchoose_n"];

            }
            if(([self.moneyString floatValue]<1))
            {
                contentlabel.text = @"不可用代金券";
            }

            

        }else{
            lable.text = @"乐点";
            {
                NSLog(@"Type==%u",self.Type);
                if (self.Type == points) {
                    imageView.image = [UIImage imageNamed:@"settlement_choose_n"];
                    if(!(([self.allPoint integerValue]/10)<([self.moneyString floatValue])))
                    {
                        self.canUsePoint =(([self.moneyString floatValue])/2)*10;
                    }else
                        self.canUsePoint =[self.allPoint floatValue];
                    
                    
//                    NSLog(@"self.allPoint%ld",(([self.moneyString integerValue])/2)*10);
                    
                    float diXian =self.canUsePoint/10;
                    if(!((([self.moneyString floatValue])/2)<1))
                    {
                        contentlabel.text = [[NSString alloc]initWithFormat:@"可用%.f乐点抵用%.2f元现金",self.canUsePoint,diXian];
                    }else
                        contentlabel.text =@"不可使用乐点";
                    
                }else{
                    imageView.image = [UIImage imageNamed:@"settlement_unchoose_n"];

                }
                if(((([self.moneyString floatValue])/2)<1))
                {
                    contentlabel.text =@"不可使用乐点";
                }
            }
            
            
        }



        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 51-1, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(220,220,220);
        [cell.contentView addSubview:line];

    }else{
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, (51-31)/2, 31, 31)];
        [cell.contentView addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, 0, 100, 51)];
        lable.textColor = RGB(51,51,51);
        lable.font = [UIFont systemFontOfSize:15];
        lable.numberOfLines=0;
        [cell.contentView addSubview:lable];
        
        UIImageView *image_select = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-14-13, (54-14)/2, 14, 14)];
        [cell.contentView addSubview:image_select];
        
        if (indexPath.row ==0) {
            lable.text = @"支付宝支付";
            if (self.payType==Alipay) {
                image_select.image = [UIImage imageNamed:@"settlement_choose_n"];
 
            }else{
                image_select.image = [UIImage imageNamed:@"settlement_unchoose_n"];
 
            }
            imageView.image = [UIImage imageNamed:@"settlement_alipay_n"];
            
            
        }else{
            lable.text = @"银联支付";
            imageView.image = [UIImage imageNamed:@"settlement_unionpay_n"];
            if (self.payType==UPPay) {
                image_select.image = [UIImage imageNamed:@"settlement_choose_n"];
                
            }else{
                image_select.image = [UIImage imageNamed:@"settlement_unchoose_n"];
                
            }


        }
 
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 54-1, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(220,220,220);
        [cell.contentView addSubview:line];

    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        if(indexPath.row == 0)
        {
            
            if(!([self.moneyString floatValue]<1))
            {
                self.canUsePoint =0;
                self.pay_Type =@"voucher";

                MyCashCouponViewController *choiceView = [[MyCashCouponViewController alloc]init];
                
                choiceView.useCoupon = 100;
                choiceView.delegate = self;
                [self.navigationController pushViewController:choiceView animated:YES];
            }
            
        }
        else if(indexPath.row == 1)
        {
            if(!((([self.moneyString floatValue])/2)<1)){
                self.Type = points;
                self.pay_Type =@"integral";

                [self.table_view reloadData];
                
                if(!(([self.allPoint integerValue]/10)<([self.moneyString floatValue])))
                {
                    self.canUsePoint =(([self.moneyString floatValue])/2)*10;
                }else
                    self.canUsePoint =[self.allPoint floatValue];

                self.actualMoney.text = [[NSString alloc]initWithFormat:@"实付款:¥%.2f",[self.moneyString floatValue]-self.canUsePoint/10];

            }else{
                self.actualMoney.text = [[NSString alloc]initWithFormat:@"实付款:¥%.2f",[self.moneyString floatValue]];

            }
            
            
        }
        
    }else if (indexPath.section ==2){
        
        self.payType = (int)indexPath.row;
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:2];
        [self.table_view reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];

    }
}


-(void)settlementClick{
    
    
    if (self.payType==Alipay) {
        [self initAlipayInfo];

    }
    if (self.payType==UPPay) {
        [self postPaymentsRequest];
    }
}

/**
 银联支付
 */
-(void)postPaymentsRequest
{
    
    NSString *url = @"http://101.201.100.191//upacp_demo_app/demo/api_05_app/TPConsume.php";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.cardInfo_dic[@"merchant"] forKey:@"muid"];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:appdelegate.cardInfo_dic[@"code"] forKey:@"code"];
    [params setObject:appdelegate.cardInfo_dic[@"level"] forKey:@"level"];
    [params setObject:appdelegate.cardInfo_dic[@"type"] forKey:@"cate"];
    
    
    [params setObject:orderType_A[1] forKey:@"type"];
    //实际支付价格.没有×100
    [params setObject:self.moneyString forKey:@"sum"];
    [params setObject:self.pay_Type forKey:@"pay_type"];
    
    if ([self.pay_Type isEqualToString:@"voucher"]) {
        [params setObject:self.coup_dic[@"type"] forKey:@"content"];
        
    }else if ([self.pay_Type isEqualToString:@"integral"]) {
        
        [params setObject:[[NSString alloc]initWithFormat:@"%.f",self.canUsePoint] forKey:@"content"];
    }
    else{
    }
    //实付金额×100
    NSInteger actMoney1 =[[self.actualMoney.text substringFromIndex:5] floatValue]*100;
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
    
    
    //    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    //    NSInteger date = (long long int)time;
    NSString *outtrade =[[NSString alloc]initWithFormat:@"%@%5d",dateString,x];
    NSLog(@"%@",outtrade);
    order.outTradeNO = outtrade; //订单ID（由商家自行制定）
    order.subject = @"办卡"; //商品标题
    if ([self.pay_Type isEqualToString:@"voucher"]) {
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@#%@",self.pay_Type,@"办卡",appdelegate.cardInfo_dic[@"code"],appdelegate.cardInfo_dic[@"level"],appdelegate.cardInfo_dic[@"type"],appdelegate.cardInfo_dic[@"card_image_url"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],appdelegate.cardInfo_dic[@"price"],self.coup_dic[@"type"]];
        
    }else if ([self.pay_Type isEqualToString:@"integral"]) {
        
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@#%@",self.pay_Type,@"办卡",appdelegate.cardInfo_dic[@"code"],appdelegate.cardInfo_dic[@"level"],appdelegate.cardInfo_dic[@"type"],appdelegate.cardInfo_dic[@"card_image_url"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],appdelegate.cardInfo_dic[@"price"],[[NSString alloc]initWithFormat:@"%.f",self.canUsePoint]];
        
    }else if ([self.pay_Type isEqualToString:@"null"])
    {
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@",self.pay_Type,@"办卡",appdelegate.cardInfo_dic[@"code"],appdelegate.cardInfo_dic[@"level"],appdelegate.cardInfo_dic[@"type"],appdelegate.cardInfo_dic[@"card_image_url"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],appdelegate.cardInfo_dic[@"price"]];
    }
    
    NSLog(@"order.body====%@",order.body);
    //order.productDescription = wareOrderInfo.orderDescription; //商品描述
    //float price =[self.moneyText.text floatValue];
    order.totalFee = [self.actualMoney.text substringFromIndex:5];//[NSString stringWithFormat:@"%lf",price]; //商品价格
    printf("======%s\n",[order.body UTF8String]);

    printf("======%s\n",[order.totalFee UTF8String]);
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

@end
