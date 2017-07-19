//
//  BletcShop
//
//  Created by Bletc on 2016/11/17.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "PayMentController.h"
#import "MyCashCouponViewController.h"
#import "UIImageView+WebCache.h"
#import "CardInfoViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "UPPaymentControl.h"

#import "PaySuccessVc.h"

enum OrderTypes{
    
    Wares,
    points
    
};
enum PayTypes {
    Alipay,
    UPPay,
    WalletPay
} ;
@interface PayMentController ()<UITableViewDelegate,UITableViewDataSource,ViewControllerBDelegate,UIAlertViewDelegate>
{
    NSArray *orderType_A;////1-买卡  2-续卡 3-充值 4-升级
    NSString *Moneymessage;
    
}
@property(nonatomic,weak)UITableView*table_view;
@property enum OrderTypes Type;

@property enum PayTypes payType;

@property(nonatomic,copy)NSString *allPoint;
@property float canUsePoint;
@property (nonatomic , strong) NSDictionary *coup_dic;// 优惠券信息
@property(nonatomic,copy)NSString *actualMoney;//实际应付金额;

@property (nonatomic,retain)NSString *pay_Type;//（支付类型）=> “null"（不抵额）,"voucher”（用代金卷抵额）,“integral”（用乐点抵额）


@property (nonatomic ,assign) float walletRemain;//钱包余额

@end

@implementation PayMentController
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
            
            self.actualMoney = [[NSString alloc]initWithFormat:@"实付款:¥%.2f",([self.moneyString floatValue]-[price floatValue])];
            
            Moneymessage = [NSString stringWithFormat:@"您使用优惠券抵付%.2f,实付款:¥%.2f",[price floatValue],[self.moneyString floatValue]-[price floatValue]];

        }else
        {
            self.actualMoney = [[NSString alloc]initWithFormat:@"实付款:¥%.2f",([self.moneyString floatValue]*90/100)];
            
            
            Moneymessage = [NSString stringWithFormat:@"您使用优惠券抵付%.2f,实付款:¥%.2f",([self.moneyString floatValue]*10/100),([self.moneyString floatValue]*90/100)];


            
        }
        
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
    
}
-(void)showtishi:(BOOL)payResult{
    
    if (payResult) {
        
        
        if (self.orderInfoType==4) {
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            
            NSMutableDictionary  *card_dic = [NSMutableDictionary dictionaryWithDictionary:appdelegate.cardInfo_dic];
            
            [card_dic setValue:appdelegate.payCardType forKey:@"card_level"];
            appdelegate.cardInfo_dic =  card_dic;
            
        }

        
        
        PaySuccessVc *VC = [[PaySuccessVc alloc]init];
        VC.orderInfoType = self.orderInfoType;
        VC.card_dic = self.card_dic;
        VC.type_new = self.level;
        VC.money_str = [self.actualMoney substringFromIndex:5];
        
        [self.navigationController pushViewController:VC animated:YES];
        

        
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"您已成功支付啦!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        
//        [alert show];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃当前交易?" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"去支付", nil];
        alert.tag =1111;
        [alert show];
        
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"支付";
    orderType_A = @[@"",@"办卡",@"续卡",@"充值",@"升级"];
    self.pay_Type =@"null";
    
    [self postSocketMoney];
    
    Moneymessage = [NSString stringWithFormat:@"实付款:¥%.2f",[self.moneyString floatValue]];
    
    self.actualMoney = [[NSString alloc]initWithFormat:@"实付款:¥%.2f",[self.moneyString floatValue]];

    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.bounces = NO;
    self.table_view = table;
    [self.view addSubview:table];
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(12, 300, SCREENWIDTH-24, 49);
    button.backgroundColor= NavBackGroundColor;
    [button setTitle:@"确定" forState:0];
    button.layer.cornerRadius = 5;
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    [button addTarget:self action:@selector(settlementClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    

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
        return 0.01;

    }else
        return 10;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  
        return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 0.01;
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
    if (section==0 || section==1) {
        return 0;
    }else
        return 3;
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

        
    }else if (indexPath.section==1){
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, (51-14)/2, 14, 14)];
//        [cell.contentView addSubview:imageView];
//        
//        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, 0, 100, 51)];
//        lable.textColor = RGB(51,51,51);
//        lable.font = [UIFont systemFontOfSize:15];
//        lable.numberOfLines=0;
//        [cell.contentView addSubview:lable];
//        
//        UILabel *contentlabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-150, 51)];
//        contentlabel.font = [UIFont systemFontOfSize:12];
//        [cell.contentView addSubview:contentlabel];
//        
//        contentlabel.textAlignment = NSTextAlignmentRight;
//        
//        if (indexPath.row ==0) {
//            lable.text = @"代金券";
//            if (self.coup_dic.count>0) {
//                if (self.Type == Wares) {
//                    imageView.image = [UIImage imageNamed:@"settlement_choose_n"];
//                    contentlabel.text = [[NSString alloc]initWithFormat:@"%@代金券",self.coup_dic[@"type"]];
//                    
//                }else{
//                    imageView.image = [UIImage imageNamed:@"settlement_unchoose_n"];
//                    
//                }
//                
//            }else{
//                imageView.image = [UIImage imageNamed:@"settlement_unchoose_n"];
//                
//            }
//            if(([self.moneyString floatValue]<1))
//            {
//                contentlabel.text = @"不可用代金券";
//            }
//            
//            
//            
//        }else{
//            lable.text = @"乐点";
//            {
//                NSLog(@"Type==%u",self.Type);
//                if (self.Type == points) {
//                    imageView.image = [UIImage imageNamed:@"settlement_choose_n"];
//                    if(!(([self.allPoint integerValue]/10)<([self.moneyString floatValue])))
//                    {
//                        self.canUsePoint =(([self.moneyString floatValue])/2)*10;
//                    }else
//                        self.canUsePoint =[self.allPoint floatValue];
//                    
//                    
//                    //                    NSLog(@"self.allPoint%ld",(([self.moneyString integerValue])/2)*10);
//                    
//                    float diXian =self.canUsePoint/10;
//                    if(!((([self.moneyString floatValue])/2)<1))
//                    {
//                        contentlabel.text = [[NSString alloc]initWithFormat:@"可用%.f乐点抵用%.2f元现金",self.canUsePoint,diXian];
//                    }else
//                        contentlabel.text =@"不可使用乐点";
//                    
//                }else{
//                    imageView.image = [UIImage imageNamed:@"settlement_unchoose_n"];
//                    
//                }
//                if(((([self.moneyString floatValue])/2)<1))
//                {
//                    contentlabel.text =@"不可使用乐点";
//                }
//            }
//            
//            
//        }
//        
//        
//        
//        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 51-1, SCREENWIDTH, 1)];
//        line.backgroundColor = RGB(220,220,220);
//        [cell.contentView addSubview:line];
        
    }else{
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, (51-31)/2, 31, 31)];
        [cell.contentView addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, 0, 100, 51)];
        lable.textColor = RGB(51,51,51);
        lable.font = [UIFont systemFontOfSize:15];
        lable.numberOfLines=0;
        [cell.contentView addSubview:lable];
        
        UIImageView *image_select = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-30-13, (54-30)/2, 30, 30)];
        [cell.contentView addSubview:image_select];
        
        if (indexPath.row ==0) {
            lable.text = @"支付宝支付";
            if (self.payType==Alipay) {
                image_select.image = [UIImage imageNamed:@"settlement_choose_n"];
                
            }else{
                image_select.image = [UIImage imageNamed:@"settlement_unchoose_n"];
                
            }
            imageView.image = [UIImage imageNamed:@"支付宝支付L"];
            
            
        }else if(indexPath.row ==1){
            lable.text = @"银联支付";
            imageView.image = [UIImage imageNamed:@"银联支付L"];
            if (self.payType==UPPay) {
                image_select.image = [UIImage imageNamed:@"settlement_choose_n"];
                
            }else{
                image_select.image = [UIImage imageNamed:@"settlement_unchoose_n"];
                
            }
            
            
        }else if(indexPath.row ==2){
            lable.text = @"钱包支付";
            imageView.image = [UIImage imageNamed:@"钱包支付L"];
            if (self.payType==WalletPay) {
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
//        if(indexPath.row == 0)
//        {
//            
//            if(!([self.moneyString floatValue]<1))
//            {
//                self.canUsePoint =0;
//                self.pay_Type =@"voucher";
//                
//                MyCashCouponViewController *choiceView = [[MyCashCouponViewController alloc]init];
//                
//                choiceView.useCoupon = 100;
//                choiceView.delegate = self;
//                [self.navigationController pushViewController:choiceView animated:YES];
//            }
//            
//        }
//        else if(indexPath.row == 1)
//        {
//            if(!((([self.moneyString floatValue])/2)<1)){
//                self.Type = points;
//                self.pay_Type =@"integral";
//                
//                [self.table_view reloadData];
//                
//                if(!(([self.allPoint integerValue]/10)<([self.moneyString floatValue])))
//                {
//                    self.canUsePoint =(([self.moneyString floatValue])/2)*10;
//                }else
//                    self.canUsePoint =[self.allPoint floatValue];
//                
//                self.actualMoney = [[NSString alloc]initWithFormat:@"实付款:¥%.2f",[self.moneyString floatValue]-self.canUsePoint/10];
//                
//                message = [NSString stringWithFormat:@"您使用乐点抵付%.2f,实付款:¥%.2f",self.canUsePoint/10,[self.moneyString floatValue]-self.canUsePoint/10];
//                
//
//                
//            }else{
//                self.actualMoney = [[NSString alloc]initWithFormat:@"实付款:¥%.2f",[self.moneyString floatValue]];
//                
//                message = [NSString stringWithFormat:@"实付款:¥%.2f",[self.moneyString floatValue]];
//
//                
//            }
//            
//            
//        }
        
    }else if (indexPath.section ==2){
        
        self.payType = (int)indexPath.row;
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:2];
        [self.table_view reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        
    }
}


-(void)settlementClick{
    
    
    
    if (self.payType==Alipay || self.payType==UPPay) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:Moneymessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"支付", nil];
        alertView.tag = 1111;
        [alertView show];
        
    }else  if (self.payType ==WalletPay) {
        
        
        
        if (self.walletRemain >=[self.moneyString floatValue]) {
            
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@,钱包余额充足,是否支付?",Moneymessage] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self payUseTheWallet];
            }];
            
            
            [alertVC addAction:cancelAction];
            [alertVC addAction:sureAction];
            
            [self presentViewController:alertVC animated:YES completion:nil];
            
            
        }else{
            [self showHint:@"钱包余额不足,请充值!"];
        }
        
        
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag ==1111) {
        if (buttonIndex ==1) {
            
            if (self.payType==Alipay) {
                

                [self initAlipayInfo];
                
            }
            if (self.payType==UPPay) {
                
                
               [self postPaymentsRequest];
            }
            
            if (self.payType==WalletPay) {
                
                
                [self payUseTheWallet];
            }

           
        }
    }
    
}
/**
 
 使用钱包支付
 */
-(void)payUseTheWallet{
    
    [self showHudInView:self.view hint:@"加载中..."];

    
    NSString *url ;
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.cardInfo_dic[@"merchant"] forKey:@"muid"];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:appdelegate.cardInfo_dic[@"card_type"] forKey:@"cate"];
    
    //续卡
    if (self.orderInfoType==2) {
        
        url = [NSString stringWithFormat:@"%@UserType/wallet/card_renew",BASEURL];
        
        [params setObject:appdelegate.cardInfo_dic[@"card_code"] forKey:@"cardCode"];
        [params setObject:appdelegate.cardInfo_dic[@"card_level"] forKey:@"cardLevel"];
        
    }
    //升级
    if (self.orderInfoType==4) {
        
        url = [NSString stringWithFormat:@"%@UserType/wallet/card_upgrade",BASEURL];
        
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
        
        [params setObject:[NSString stringWithFormat:@"%.f",self.canUsePoint] forKey:@"content"];
    }
    else{
    }
    //实付金额×100
    NSInteger actMoney1 =[[self.actualMoney substringFromIndex:5] floatValue]*100;
    NSString *actMoney = [[NSString alloc]initWithFormat:@"%ld",actMoney1];
    [params setObject:actMoney forKey:@"txnAmt"];
    [params setObject:appdelegate.cardInfo_dic[@"card_temp_color"] forKey:@"image_url"];

    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result----%@",result);
        
        [self hideHud];
        if ([result[@"result_code"] intValue]==1) {
            
            
            if (self.orderInfoType==4) {
                AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                
                NSMutableDictionary  *card_dic = [NSMutableDictionary dictionaryWithDictionary:appdelegate.cardInfo_dic];
                
                [card_dic setValue:appdelegate.payCardType forKey:@"card_level"];
                appdelegate.cardInfo_dic =  card_dic;
                
            }

            
            
            PaySuccessVc *VC = [[PaySuccessVc alloc]init];
            VC.orderInfoType = self.orderInfoType;
            VC.card_dic = self.card_dic;
            VC.type_new = self.level;
            VC.money_str = [self.actualMoney substringFromIndex:5];
            
            
            [self.navigationController pushViewController:VC animated:YES];
            

        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败,是否放弃当前交易?" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"去支付", nil];
            alert.tag =1111;
            [alert show];
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHud];

    }];

    
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
    [params setObject:appdelegate.cardInfo_dic[@"card_type"] forKey:@"cate"];
    
    appdelegate.whoPay = self.orderInfoType;
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
        
        [params setObject:[NSString stringWithFormat:@"%.f",self.canUsePoint] forKey:@"content"];
    }
    else{
    }
    //实付金额×100
    NSInteger actMoney1 =[[self.actualMoney substringFromIndex:5] floatValue]*100;
    NSString *actMoney = [[NSString alloc]initWithFormat:@"%ld",actMoney1];
    [params setObject:actMoney forKey:@"txnAmt"];
    [params setObject:appdelegate.cardInfo_dic[@"card_temp_color"] forKey:@"image_url"];
    
    [self showHUd];
    NSLog(@"params-----%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [self hideHud];
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
    dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
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
            
            
            order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%.f",self.pay_Type,orderType_A[self.orderInfoType],appdelegate.cardInfo_dic[@"card_code"],appdelegate.cardInfo_dic[@"card_level"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],self.moneyString,appdelegate.payCardType,self.canUsePoint];
            
            
        }else if ([self.pay_Type isEqualToString:@"null"])
        {
            
            order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@",self.pay_Type,orderType_A[self.orderInfoType],appdelegate.cardInfo_dic[@"card_code"],appdelegate.cardInfo_dic[@"card_level"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],self.moneyString,appdelegate.payCardType];
        }
        
        
    }else{
        
        if ([self.pay_Type isEqualToString:@"voucher"]) {
            
            order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@",self.pay_Type,orderType_A[self.orderInfoType],appdelegate.cardInfo_dic[@"card_code"],appdelegate.cardInfo_dic[@"card_level"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],appdelegate.cardInfo_dic[@"price"],self.coup_dic[@"type"]];
            
            
        }else if ([self.pay_Type isEqualToString:@"integral"]) {
            
            
            order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%.f",self.pay_Type,orderType_A[self.orderInfoType],appdelegate.cardInfo_dic[@"card_code"],appdelegate.cardInfo_dic[@"card_level"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],appdelegate.cardInfo_dic[@"price"],self.canUsePoint];
            
            
        }else if ([self.pay_Type isEqualToString:@"null"])
        {
            
            order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@",self.pay_Type,orderType_A[self.orderInfoType],appdelegate.cardInfo_dic[@"card_code"],appdelegate.cardInfo_dic[@"card_level"],appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],appdelegate.cardInfo_dic[@"price"]];
        }
        
    }
    
    NSLog(@"order.body====%@",order.body);
    
    //order.productDescription = wareOrderInfo.orderDescription; //商品描述
    //float price =[self.moneyText.text floatValue];
    order.totalFee = [self.actualMoney substringFromIndex:5];//[NSString stringWithFormat:@"%lf",price]; //商品价格
    order.totalFee = @"0.01";
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
                 
                 
                 if (self.orderInfoType==4) {
                     AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                     
                     NSMutableDictionary  *card_dic = [NSMutableDictionary dictionaryWithDictionary:appdelegate.cardInfo_dic];
                     
                     [card_dic setValue:appdelegate.payCardType forKey:@"card_level"];
                     appdelegate.cardInfo_dic =  card_dic;
                     
                 }

                 
                 
                 PaySuccessVc *VC = [[PaySuccessVc alloc]init];
                 VC.orderInfoType = self.orderInfoType;
                 VC.card_dic = self.card_dic;
                 VC.type_new = self.level;
                 VC.money_str = [self.actualMoney substringFromIndex:5];
                 
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
- (void)processOrderWithPaymentResult:(NSURL *)resultUrl
                      standbyCallback:(CompletionBlock)completionBlock
{
    
}
- (void)payOrder:(NSString *)orderStr
      fromScheme:(NSString *)schemeStr
        callback:(CompletionBlock)completionBlock;
{
    
}




-(void)postSocketMoney
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:@"remain" forKey:@"type"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSString *remain = [NSString getTheNoNullStr:result[@"remain"] andRepalceStr:@"0.00"];
        
        self.walletRemain = [[remain stringByReplacingOccurrencesOfString:@"元" withString:@""] floatValue];
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
@end
