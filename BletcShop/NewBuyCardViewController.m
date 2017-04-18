//
//  NewBuyCardViewController.m
//  BletcShop
//
//  Created by apple on 16/11/16.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewBuyCardViewController.h"
#import "BuyCardChoicePayViewController.h"
#import "ChoicePayTypeViewController.h"
#import "UIImageView+WebCache.h"
#import "MoneyBagChoiceTypeViewController.h"
#import "MyCashCouponViewController.h"

#import "LandingController.h"

#import "CardInfoViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "UPPaymentControl.h"
#import "PaySuccessVc.h"
@interface NewBuyCardViewController ()<UITableViewDelegate,UITableViewDataSource,ViewControllerBDelegate>

@end

@implementation NewBuyCardViewController
{
    NSInteger selectRow;
    NSInteger payKind;
}
-(NSDictionary *)coup_dic{
    if (!_coup_dic) {
        _coup_dic = [NSDictionary dictionary];
    }
    return _coup_dic;
}
- (void)sendValue:(NSDictionary *)value
{
    self.coup_dic = value;
    
    NSLog(@"ddddddd%@",self.coup_dic);
    self.pay_Type=@"cp";
    self.Type = Wares;
    self.canUsePoint =0;

    NSString* price =self.coup_dic[@"sum"];
//    if (!(([self.moneyString floatValue]*10/100)<[price floatValue])) {
//        self.contentLabel.text = [[NSString alloc]initWithFormat:@"实付款:%.2f",([self.moneyString floatValue]-[price floatValue])];
//    }else
//    {
//        self.contentLabel.text = [[NSString alloc]initWithFormat:@"实付款:%.2f",([self.moneyString floatValue]*90/100)];
//        
//    }

    
    if ([self.moneyString floatValue]>=[price floatValue]) {
        self.contentLabel.text = [[NSString alloc]initWithFormat:@"实付款:%.2f",([self.moneyString floatValue]-[price floatValue])];

    }
    [self.myTable reloadData];
    
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
        
        self.coup_dic = nil;
        
        PaySuccessVc *VC = [[PaySuccessVc alloc]init];
        VC.orderInfoType = self.orderInfoType;
        VC.card_dic = self.card_dic;
        VC.money_str = [self.contentLabel.text substringFromIndex:4];
        
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
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"结算";
    self.allPoint = [[NSString alloc]init];
    self.Type = 888;
    self.canUsePoint = 0;
    selectRow=-1;
    payKind=0;
    self.pay_Type=@"null";
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-49) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.bounces=YES;
    tableView.showsVerticalScrollIndicator = NO;
    self.myTable = tableView;
    [self.view addSubview:tableView];
    
    UIButton *jiesuanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    jiesuanBtn.frame=CGRectMake(SCREENWIDTH-75, SCREENHEIGHT-64-49, 75, 49);
    [jiesuanBtn setTitle:@"结算" forState:UIControlStateNormal];
    jiesuanBtn.backgroundColor=NavBackGroundColor;
    [jiesuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:jiesuanBtn];
    [jiesuanBtn addTarget:self action:@selector(goJieSuan) forControlEvents:UIControlEventTouchUpInside];
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-64-49, SCREENWIDTH-85, 49)];
    moneyLabel.text=@"实付款:0.00";
    self.contentLabel=moneyLabel;
    moneyLabel.textAlignment=NSTextAlignmentRight;
    moneyLabel.font=[UIFont systemFontOfSize:15.0f];
    [self.view addSubview:moneyLabel];
    
    [self postRequestPoints];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTable.delegate tableView:self.myTable didSelectRowAtIndexPath:indexPath];
    
}
-(void)postRequestPoints
{
    
//    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountGet",BASEURL];
//    
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
//    [params setObject:@"integral" forKey:@"type"];
//    
//    
//    
//    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//        
//        NSLog(@"%@", result);
//        
//        self.allPoint = result[@"integral"];
//        
//        
//    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"%@", error);
//        
//    }];
    
    NSString *url =[NSString stringWithFormat:@"%@UserType/user/getRedPacket",BASEURL];
    NSMutableDictionary *paramer =[NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [paramer setValue:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
   
        [paramer setValue:@"1" forKey:@"page"];
        
    
    //    NSLog(@"---%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        
        if (result) {
            
            self.allPoint =result[@"sum"];
            
           
        }
        
        
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error---%@",error);
        
    }];

    
}
//tableview---delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 84;
    }else if (indexPath.section==1){
//        return 0.01;
                return 50;
    }else if (indexPath.section==2){
        return 54;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section==1) {
//        return 0.01;
//    }else
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 49;
    }else if(section==2){
        return 43;
//        return 0.01;
    }else
        return 0.01;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.cardListArray.count;
    }else if (section==1){
        return 2;
    }else{
        return 2;
    }
    return 2;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    view.backgroundColor=RGB(243, 243, 243);
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 40)];
    view2.backgroundColor=[UIColor whiteColor];
    [view addSubview:view2];
     UILabel *label=[[UILabel alloc]init];
    label.font=[UIFont systemFontOfSize:16.0f];
    label.textAlignment=NSTextAlignmentLeft;
    [view2 addSubview:label];
    if (section==0) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 14, 14)];
        imageView.image=[UIImage imageNamed:@"店铺管理"];
        [view2 addSubview:imageView];
        label.frame=CGRectMake(37, 7, SCREENWIDTH-37, 26);
        label.text=self.shop_name;
        
    }else if (section==1){
//        label.hidden = YES;
        label.frame=CGRectMake(13, 7, SCREENWIDTH-13, 26);
        label.text=@"优惠方式";
    }else if (section==2){
        label.frame=CGRectMake(13, 7, SCREENWIDTH-13, 26);
        label.text=@"支付方式";
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    if (indexPath.section==0) {
        UIButton *stateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        stateBtn.frame=CGRectMake(5, (36*2+12-30)/2, 30, 30);
        if (indexPath.row==selectRow) {
            [stateBtn setImage:[UIImage imageNamed:@"settlement_choose_n"] forState:UIControlStateNormal];
        }else{
            [stateBtn setImage:[UIImage imageNamed:@"settlement_unchoose_n"] forState:UIControlStateNormal];
        }
        stateBtn.tag=100;
        [cell addSubview:stateBtn];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(37, 12, 102, 60)];
        imageView.backgroundColor = [UIColor colorWithHexString:self.cardListArray[indexPath.row][@"card_temp_color"]];
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 0.5;
        imageView.layer.borderColor = RGB(180, 180, 180).CGColor;

        [cell addSubview:imageView];
        
        
        UIView *bot_view = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 102, 20)];
        bot_view.backgroundColor = [UIColor whiteColor];
        [imageView addSubview:bot_view];
        
        UILabel *vipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 102, 40)];
        vipLab.text = [NSString stringWithFormat:@"VIP%@",self.cardListArray[indexPath.row][@"level"]];
        vipLab.textAlignment = NSTextAlignmentCenter;
        vipLab.textColor = [UIColor whiteColor];
        [imageView addSubview:vipLab];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:vipLab.text];
        
        [attr setAttributes:@{NSForegroundColorAttributeName:RGB(253,171,65),NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} range:NSMakeRange(0, 3)];
        
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(3, vipLab.text.length-3)];
        
        vipLab.attributedText = attr;

        
//        NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCECARD stringByAppendingString:[[self.cardListArray objectAtIndex:indexPath.row] objectForKey:@"card_image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//        [imageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon2.png"] options:SDWebImageRetryFailed];
//        
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, 15, SCREENWIDTH-imageView.right-70-15, 30)];
        lable.text = [NSString getTheNoNullStr:self.cardListArray[indexPath.row][@"content"] andRepalceStr:@"暂无优惠!"];
        lable.textColor = RGB(51,51,51);
        lable.font = [UIFont systemFontOfSize:15];
        lable.numberOfLines=3;
        [cell addSubview:lable];
        
        CGFloat labHight = [lable.text boundingRectWithSize:CGSizeMake(lable.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lable.font} context:nil].size.height;
        CGRect frame = lable.frame;
        frame.size.height = labHight;
        lable.frame = frame;


        UILabel *priceLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREENWIDTH-13, 58)];
        priceLable.text=[NSString stringWithFormat:@"￥%@",self.cardListArray[indexPath.row][@"price"]];
        priceLable.textAlignment=NSTextAlignmentRight;
        priceLable.font=[UIFont systemFontOfSize:15.0f];
        [cell addSubview:priceLable];
        
    }else if (indexPath.section==1){

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 90, 50)];
        label.font = [UIFont systemFontOfSize:15];
        [cell addSubview:label];
        
        label.textAlignment = NSTextAlignmentLeft;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
        
        [cell addSubview:imageView];
        
        UILabel *contentlabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-150, 50)];
        contentlabel.font = [UIFont systemFontOfSize:12];
        [cell addSubview:contentlabel];
        
        contentlabel.textAlignment = NSTextAlignmentRight;
        
        if (indexPath.row==0) {
            label.text = @"使用红包";
            NSLog(@"self.allPoint==%@,self.moneyString==%@",self.allPoint,self.moneyString);
            if (self.Type == points) {
                imageView.image = [UIImage imageNamed:@"checkbox_yes"];
                if(!(([self.allPoint floatValue])<([self.moneyString floatValue]*0.9)))
                {
                    self.canUsePoint =[self.moneyString floatValue]*0.9;
                }else
                    self.canUsePoint =[self.allPoint floatValue];
                
                
                NSLog(@"self.allPoint%ld",(([self.moneyString integerValue])/2)*10);
                
                //self.canUsePoint =40;
                float diXian =self.canUsePoint;
                if(!((([self.moneyString floatValue])/2)<1))
                {
                    contentlabel.text = [[NSString alloc]initWithFormat:@"可用%.f红包抵用%.2f元现金",self.canUsePoint,diXian ];
                }else
                    contentlabel.text =@"不可使用红包";
                
            }
            if(((([self.moneyString floatValue])/2)<1)&&self.moneyString)
            {
                contentlabel.text =@"不可使用红包";
            }
        }else
        {
            label.text = @"使用代金券";
            if (self.coup_dic.count>0) {
                contentlabel.text = [[NSString alloc]initWithFormat:@"%@代金券",self.coup_dic[@"sum"]];
                if (self.Type == Wares) {
                    imageView.image = [UIImage imageNamed:@"checkbox_yes"];
                }else{
                    contentlabel.text =@"";

                }
            }
            
            if(([self.moneyString floatValue]<1)&&self.moneyString)
            {
                contentlabel.text = @"不可用代金券";
            }
            
        }

    }else if (indexPath.section==2){
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(13, 12, 30, 30)];
        UILabel *payLable=[[UILabel alloc]initWithFrame:CGRectMake(53, 12, 120, 30)];
        payLable.textAlignment=NSTextAlignmentLeft;
        payLable.font=[UIFont systemFontOfSize:15.0f];
        UIButton *stateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        stateBtn.frame=CGRectMake(SCREENWIDTH-30-18, 12, 30, 30);
        if (indexPath.row==payKind) {
            [stateBtn setImage:[UIImage imageNamed:@"settlement_choose_n"] forState:UIControlStateNormal];
        }else{
            [stateBtn setImage:[UIImage imageNamed:@"settlement_unchoose_n"] forState:UIControlStateNormal];
        }
        
        
        [cell addSubview:stateBtn];

        
        [cell addSubview:payLable];
        [cell addSubview:imageView];
        if (indexPath.row==0) {
            imageView.image=[UIImage imageNamed:@"alipay_img.png"];
            payLable.text=@"支付宝支付";
        }else if (indexPath.row==1){
            imageView.image=[UIImage imageNamed:@"unionpay_img.png"];
            payLable.text=@"银联支付";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    if (indexPath.section==0) {
        selectRow = indexPath.row;
        self.moneyString=self.cardListArray[indexPath.row][@"price"];
        
        self.coup_dic = nil;
        
        [self.myTable reloadData];
        
        self.card_dic=self.cardListArray[indexPath.row];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

        appdelegate.cardInfo_dic=self.cardListArray[indexPath.row];
    }
    if (indexPath.section==1)
    {
        if(indexPath.row == 1)
        {
            if(!([self.moneyString floatValue]<1))
            {
                MyCashCouponViewController *choiceView = [[MyCashCouponViewController alloc]init];
                choiceView.muid =  self.cardListArray[selectRow][@"merchant"];
                choiceView.moneyString = self.moneyString;
                choiceView.useCoupon = 100;
                choiceView.delegate = self;
                [self.navigationController pushViewController:choiceView animated:YES];
            }
            
        }
        else if(indexPath.row == 0)
        {
            if(!((([self.moneyString floatValue])/2)<1)){
                self.pay_Type=@"rp";
                self.Type = points;
                self.coup_dic=[NSDictionary dictionaryWithObject:@"0元" forKey:@"type"];
                [self.myTable reloadData];
            }
        }
        
    }
    if (indexPath.section==2) {
        payKind=indexPath.row;
        [self.myTable reloadData];
    }
    if(self.Type==Wares)
    {
        NSString* price =self.coup_dic[@"sum"];
//        if (!(([self.moneyString floatValue]*10/100)<[price floatValue])) {
//            self.contentLabel.text = [[NSString alloc]initWithFormat:@"实付款:%.2f",([self.moneyString floatValue]-[price floatValue])];
//        }else
//        {
//            self.contentLabel.text = [[NSString alloc]initWithFormat:@"实付款:%.2f",([self.moneyString floatValue]*90/100)];
//            
//        }
        
        
        if ([self.moneyString floatValue]>=[price floatValue]) {
            self.contentLabel.text = [[NSString alloc]initWithFormat:@"实付款:%.2f",([self.moneyString floatValue]-[price floatValue])];
            
        }
        
    }
    
    else if(self.Type==points)
    {
        if(!(([self.allPoint floatValue])<([self.moneyString floatValue]*0.9)))
        {
            self.canUsePoint =[self.moneyString floatValue]*0.9;
        }else
            self.canUsePoint =[self.allPoint floatValue];

        
        if(!((([self.moneyString floatValue])/2)<1))
        {
            self.contentLabel.text = [[NSString alloc]initWithFormat:@"实付款:%.2f",[self.moneyString floatValue]-self.canUsePoint];
        }else
            self.contentLabel.text = [[NSString alloc]initWithFormat:@"实付款:%.2f",[self.moneyString floatValue]];
        
    }
    
    else
    {
        self.contentLabel.text = [[NSString alloc]initWithFormat:@"实付款:%.2f",[self.moneyString floatValue]];
    }

}

//结算
-(void)goJieSuan{
    if (selectRow==-1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请选择要购买的卡", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        
        [hud hideAnimated:YES afterDelay:3.f];
    }else if (payKind==-2) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请选择结算方式 ", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];

        [hud hideAnimated:YES afterDelay:3.f];

    }else{
        //
        [self postIfBuyCard];
    }
}


-(void)postIfBuyCard
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/authGet",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.cardListArray[selectRow][@"merchant"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"auth_sum_get.php %@",result);
        NSArray*arr_A =   [result[@"remain"] componentsSeparatedByString:@"元"];
        NSArray *card_price = [self.cardListArray[selectRow][@"price"] componentsSeparatedByString:@"元"];
        
        if ([arr_A[0]doubleValue]>[card_price[0] doubleValue])
        {
            [self postCardIfRequest];
        }else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"商家暂停办卡业务", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:4.f];
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
//此会员卡是否被办理过
-(void)postCardIfRequest
{

    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/stateGet",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [params setObject:self.card_dic[@"merchant"] forKey:@"muid"];
    [params setObject:self.card_dic[@"code"] forKey:@"cardCode"];
    [params setObject:self.card_dic[@"level"] forKey:@"cardLevel"];
    [params setObject:self.card_dic[@"type"] forKey:@"cardType"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@",result);
        if ([result[@"result_code"] isEqualToString:@"false"])
        {
            [self choicePayType];
            NSLog(@"%@", result);
        }else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"您已拥有此卡", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            // Move to bottm center.
            //    hud.offset = CGPointMake(0.f, );
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:4.f];
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
    
}
-(void)choicePayType
{
    self.moneyString = self.card_dic[@"price"];
    
    self.orderInfoType=1;
    
    
    if (payKind==0) {
        [self initAlipayInfo];
    }else if (payKind==1){
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        appdelegate.paymentType =1;
        
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
    
    
    [params setObject:@"办卡" forKey:@"type"];
    //实际支付价格.没有×100
    [params setObject:self.moneyString forKey:@"sum"];
    if (self.Type==Wares)
    {
        [params setObject:@"cp" forKey:@"pay_type"];
        [params setObject:self.coup_dic[@"coupon_id"] forKey:@"content"];
    }
    else if (self.Type == points)
    {
        [params setObject:@"rp" forKey:@"pay_type"];
        [params setObject:[[NSString alloc]initWithFormat:@"%.f",self.canUsePoint] forKey:@"content"];
    }else
    {
        [params setObject:@"null" forKey:@"pay_type"];
    }
    //实付金额×100
    NSInteger actMoney1 =[[self.contentLabel.text substringFromIndex:4] floatValue]*100;
    NSString *actMoney = [[NSString alloc]initWithFormat:@"%ld",actMoney1];
    [params setObject:actMoney forKey:@"txnAmt"];
    
    NSString *colorS = appdelegate.cardInfo_dic[@"card_temp_color"];
    
    [params setObject:[colorS substringFromIndex:1] forKey:@"image_url"];
    
    
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
    order.subject = @"办卡"; //商品标题
    
    if (self.Type==Wares) {
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@#%@",self.pay_Type,@"办卡",appdelegate.cardInfo_dic[@"code"],appdelegate.cardInfo_dic[@"level"],appdelegate.cardInfo_dic[@"type"],@"card_temp_color",appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],appdelegate.cardInfo_dic[@"price"],self.coup_dic[@"sum"]];
        
    }else if (self.Type == points) {
        
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@#%@",self.pay_Type,@"办卡",appdelegate.cardInfo_dic[@"code"],appdelegate.cardInfo_dic[@"level"],appdelegate.cardInfo_dic[@"type"],@"card_temp_color",appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],appdelegate.cardInfo_dic[@"price"],[[NSString alloc]initWithFormat:@"%.f",self.canUsePoint]];
        
    }else{
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@",self.pay_Type,@"办卡",appdelegate.cardInfo_dic[@"code"],appdelegate.cardInfo_dic[@"level"],appdelegate.cardInfo_dic[@"type"],@"card_temp_color",appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"merchant"],appdelegate.cardInfo_dic[@"price"]];
    }
    
    NSLog(@"order.body====%@",order.body);
    //order.productDescription = wareOrderInfo.orderDescription; //商品描述
    //float price =[self.moneyText.text floatValue];
    order.totalFee = [self.contentLabel.text substringFromIndex:4];//[NSString stringWithFormat:@"%lf",price]; //商品价格
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
                 
                 PaySuccessVc *VC = [[PaySuccessVc alloc]init];
                 VC.orderInfoType = self.orderInfoType;
                 VC.card_dic = self.card_dic;
                 VC.money_str = [self.contentLabel.text substringFromIndex:4];
                 
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



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag ==1111) {
        if (buttonIndex ==1) {
            
            if (payKind==0) {
                [self initAlipayInfo];
            }else if (payKind==1){
                
                [self postPaymentsRequest];
            }
            
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
