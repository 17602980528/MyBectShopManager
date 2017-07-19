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

#import "PlatCouponsVC.h"


#import "LandingController.h"

#import "CardInfoViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "UPPaymentControl.h"
#import "PaySuccessVc.h"

#import "NewBuyOptionsCell.h"

@interface NewBuyCardViewController ()<UITableViewDelegate,UITableViewDataSource,ViewControllerBDelegate>
@property (nonatomic ,assign) float walletRemain;//钱包余额
@property (nonatomic,strong)NSMutableArray *optionsList_mutab;//项目列表

@property (nonatomic,strong)NSMutableArray *cardList_mutab;
@end

@implementation NewBuyCardViewController
{
    NSInteger payKind;
}

-(NSMutableArray *)optionsList_mutab{
    if (!_optionsList_mutab) {
        _optionsList_mutab = [NSMutableArray array];
    }
    return _optionsList_mutab;
}

-(NSMutableArray *)cardList_mutab{
    if (!_cardList_mutab) {
        _cardList_mutab = [NSMutableArray array];
        
        [_cardList_mutab addObject:self.cardList_Dic[@"value"]];
        [_cardList_mutab addObject:self.cardList_Dic[@"count"]];
        [_cardList_mutab addObject:self.cardList_Dic[@"meal"]];
        [_cardList_mutab addObject:self.cardList_Dic[@"experience"]];

        
        
    }
    return _cardList_mutab;
    
}
-(NSDictionary *)coup_dic{
    if (!_coup_dic) {
        _coup_dic = [NSDictionary dictionary];
    }
    return _coup_dic;
}
-(NSDictionary *)plat_coup_dic{
    if (!_plat_coup_dic) {
        _plat_coup_dic = [NSDictionary dictionary];
    }
    return _plat_coup_dic;
}
- (void)sendValue:(NSDictionary *)value
{
    self.coup_dic = value;
    

    self.Type = Wares;
    self.canUsePoint =0;
    
    NSString* price =self.coup_dic[@"sum"];

    
    
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
        self.plat_coup_dic = nil;
        
        PaySuccessVc *VC = [[PaySuccessVc alloc]init];
        VC.orderInfoType = self.orderInfoType;
        VC.card_dic = self.card_dic;
        
        if (self.Type== Wares) {
            VC.money_str = [self.contentLabel.text substringFromIndex:4];

        }else{
            VC.money_str = self.card_dic[@"price"];
 
        }
        
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
    
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-49) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.bounces=YES;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

    
    
    
    
    
    
    
    
    //获取钱包余额
    [self postSocketMoney];
    

    
    
    if (_selectIndexPath.section!=999) {
    
        //当选单个卡时
        
        NSDictionary *dic = self.cardList_mutab[_selectIndexPath.section][_selectIndexPath.row];
        
        
        for (int i = 0; i <_cardList_mutab.count; i ++) {
            
            [_cardList_mutab removeObjectAtIndex:i];

            if (i==_selectIndexPath.section) {
                [_cardList_mutab insertObject:@[dic] atIndex:i];
                
                
            }else{
                [_cardList_mutab insertObject:@[] atIndex:i];
                
            }
        }
        
       
        self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.selectIndexPath.section];
        
        [self.myTable.delegate tableView:self.myTable didSelectRowAtIndexPath:_selectIndexPath];


        
    }else{
        
        NSInteger section = 0;
        
        for (int i = 0; i <self.cardList_mutab.count; i ++) {
            if ([_cardList_mutab[i] count]) {
                section=i;
                
                NSLog(@"-----------------------%ld",section);
                break;
            }
        }
        
        
        _selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        
        [self.myTable.delegate tableView:self.myTable didSelectRowAtIndexPath:_selectIndexPath];
        

    }
 
    NSLog(@"--------_%@",self.cardList_mutab);
    
    payKind=0;
//    self.pay_Type=@"null";
    
  
    
    
    [self postRequestPoints];
    
    
    
}
-(void)postRequestPoints
{
    
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
    return 4+3+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 ||indexPath.section==1 ||indexPath.section==2 ||indexPath.section==3 ) {
        
        
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return cell?cell.frame.size.height :84;
        
//                return 84;
    }else if (indexPath.section==1+3){
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return cell?cell.frame.size.height :84;
        
        
    }else if (indexPath.section==1+3+1){
        return 80;
    }else if (indexPath.section==2+3+1){
        return 50;
    }else if (indexPath.section==3+3+1){
        return 54;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        if (section==1 ||section==2||section==3) {
            return 0.01;
        }else if(section==5){
            
            if (_selectIndexPath.section ==2) {
                return 50;
            }else{
                return 0.01;
            }
        }else
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0+3) {
        return 49;
    }else if(section==3+3+1){
        return 43;
        //        return 0.01;
    }else
        return 0.01;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0 ||section==1||section==2||section==3) {
        return [self.cardList_mutab[section] count];
        
    }else if (section==1+3){
        
    
        return 1;
        
    }
    else if (section==1+3+1){
        
        
        return _selectIndexPath.section==2 ? self.optionsList_mutab.count:0;
        
    }else if (section==2+3+1){
        return 3;
    }else if (section==3+3+1){
        return 3;
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
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 40-1, SCREENWIDTH, 1)];
    line.backgroundColor = RGB(234, 234, 234);
    [view2 addSubview:line];

    
    label.frame=CGRectMake(13, 7, SCREENWIDTH-13, 26);

    if (section==0) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 14, 14)];
        imageView.image=[UIImage imageNamed:@"店铺管理"];
        [view2 addSubview:imageView];
        label.frame=CGRectMake(37, 7, SCREENWIDTH-37, 26);
        label.text=self.shop_name;
        
    }else if (section==1+3){
        label.text=@"购买提示";
    }
    else if (section==1+3+1){
        label.text=@"包含项目";
    }else if (section==2+3+1){
       label.text=@"优惠方式";
    }else if (section==3+3+1){
        label.text=@"支付方式";
    }
    if (section==1 ||section==2||section==3) {
        return nil;
    }else if(section ==1+3+1){
        if (_selectIndexPath.section==2) {
            return view;
        }else{
            return nil;
        }
    }
    return view;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section==0+3) {
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    if (indexPath.section==0 || indexPath.section==1 ||indexPath.section==2 ||indexPath.section==3) {
        NSArray *arr = self.cardList_mutab[indexPath.section];
        if (arr.count!=0) {
            
            UIImageView *stateImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, (36*2+12-30)/2, 30, 30)];

            if (indexPath==_selectIndexPath) {
                [stateImg setImage:[UIImage imageNamed:@"settlement_choose_n"] ];
            }else{
                [stateImg setImage:[UIImage imageNamed:@"settlement_unchoose_n"] ];
            }
            stateImg.userInteractionEnabled = YES;
            [cell addSubview:stateImg];
            
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(37, 12, 102, 60)];
            imageView.backgroundColor = [UIColor colorWithHexString:arr[indexPath.row][@"template"]];
            imageView.layer.cornerRadius = 5;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderWidth = 0.5;
            imageView.layer.borderColor = RGB(180, 180, 180).CGColor;
            
            [cell addSubview:imageView];
            
            
            UIView *bot_view = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 102, 20)];
            bot_view.backgroundColor = [UIColor whiteColor];
            [imageView addSubview:bot_view];
            
            UILabel *vipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 102, 40)];
            vipLab.text = [NSString stringWithFormat:@"VIP%@",arr[indexPath.row][@"level"]];
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
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, imageView.top, SCREENWIDTH-imageView.right-70-15, imageView.height)];
            lable.text = [NSString getTheNoNullStr:arr[indexPath.row][@"des"] andRepalceStr:@"暂无优惠!"];
            lable.textColor = RGB(51,51,51);
            lable.font = [UIFont systemFontOfSize:13];
            lable.numberOfLines=2;
            [cell addSubview:lable];
            
            
            UILabel *priceLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREENWIDTH-13, 58)];
            priceLable.text=[NSString stringWithFormat:@"￥%@",arr[indexPath.row][@"price"]];
            priceLable.textAlignment=NSTextAlignmentRight;
            priceLable.font=[UIFont systemFontOfSize:15.0f];
            [cell addSubview:priceLable];
            
            
            CGFloat price_width = [priceLable.text boundingRectWithSize:CGSizeMake(priceLable.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lable.font} context:nil].size.width;
            
            
            
            
            
            //        CGFloat labHight = [lable.text boundingRectWithSize:CGSizeMake(SCREENWIDTH-imageView.right-10-price_width-13, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lable.font} context:nil].size.height;
            CGRect frame = lable.frame;
            //        frame.size.height = labHight;
            frame.size.width = SCREENWIDTH-imageView.right-10-price_width-13;
            //        frame.origin.y =  labHight<84? (84 -labHight)/2 :5;
            lable.frame = frame;
            
            
            CGRect cellFrame = cell.frame;
            
            //        cellFrame.size.height = labHight>84 ? lable.bottom+5 :84;
            cellFrame.size.height = 84;
            
            cell.frame = cellFrame;
            
            
            CGRect price_frame = priceLable.frame ;
            price_frame.origin.y = (cell.height -58)/2;
            priceLable.frame = price_frame;
            
            
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, cell.height-1, SCREENWIDTH, 1)];
            line.backgroundColor = RGB(234, 234, 234);
            [cell addSubview:line];
            
        }
       
        
        
        
        
    }else if (indexPath.section==1+3){
        
        
    
           
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREENWIDTH-30, 100)];
            lable.text = [NSString getTheNoNullStr:self.cardList_mutab[_selectIndexPath.section][_selectIndexPath.row][@"des"] andRepalceStr:@"暂无优惠!"];
            lable.textColor = RGB(51,51,51);
            lable.font = [UIFont systemFontOfSize:13];
            lable.numberOfLines=0;
            [cell addSubview:lable];
            
            
            CGFloat labHight = [lable.text boundingRectWithSize:CGSizeMake(lable.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lable.font} context:nil].size.height;
            
            
            CGRect frame = lable.frame;
            frame.size.height = labHight;
            lable.frame = frame;
            
            
            CGRect cellFrame = cell.frame;
            
            cellFrame.size.height = lable.bottom+10;
            
            cell.frame = cellFrame;

     
        
        
        
    }else if (indexPath.section==1+3+1){
        
            
            NewBuyOptionsCell *optionCell =[tableView dequeueReusableCellWithIdentifier:@"NewBuyOptionsCellID"];
            if (!optionCell) {
                optionCell = [[[NSBundle mainBundle]loadNibNamed:@"NewBuyOptionsCell" owner:self options:nil] firstObject];
            }
            
            NSDictionary *dic = self.optionsList_mutab[indexPath.row];
        
        
            
            optionCell.title_lab.text=[NSString stringWithFormat:@"%@   %@元",dic[@"name"],dic[@"price"]];
            optionCell.count_lab.text=[NSString stringWithFormat:@"可用%@次(长期有效)",dic[@"option_count"]];
        
        
            NSURL * nurl1=[[NSURL alloc] initWithString:[[NSString stringWithFormat:@"%@%@",PRODUCT_IMAGE,dic[@"image"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [optionCell.imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
            
            return  optionCell;
            

    }
    else if (indexPath.section==2+3+1){
        
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        UIImageView *imageView_red = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-18-7.5, (50-15)/2, 7.5, 15)];
        imageView_red.image = [UIImage imageNamed:@"arraw_right"];
        [cell addSubview:imageView_red];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 200, 50)];
        label.font = [UIFont systemFontOfSize:15];
        [cell addSubview:label];
        
        label.textAlignment = NSTextAlignmentLeft;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
        
        [cell addSubview:imageView];
        
        UILabel *contentlabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-150, 50)];
        contentlabel.font = [UIFont systemFontOfSize:12];
        [cell addSubview:contentlabel];
        
        contentlabel.textAlignment = NSTextAlignmentRight;
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 50-1, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(234, 234, 234);
        [cell addSubview:line];

        
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
                    contentlabel.text = [[NSString alloc]initWithFormat:@"可用%.2f红包抵用%.2f元现金",self.canUsePoint,diXian ];
                }else
                    contentlabel.text =@"不可使用红包";
                
            }
            if(((([self.moneyString floatValue])/2)<1)&&self.moneyString)
            {
                contentlabel.text =@"不可使用红包";
            }
        }else if(indexPath.row==1)
        {
            label.text = @"使用商家优惠券";
            if (self.coup_dic.count>0) {
                contentlabel.text = [[NSString alloc]initWithFormat:@"%@元优惠券",self.coup_dic[@"sum"]];
                if (self.Type == Wares) {
                    imageView.image = [UIImage imageNamed:@"checkbox_yes"];
                }else{
                    contentlabel.text =@"";
                    
                }
            }
            
            if(([self.moneyString floatValue]<1)&&self.moneyString)
            {
                contentlabel.text = @"不可用优惠券";
            }
            
        }else if(indexPath.row==2){
            
            label.text = @"使用商消乐优惠券";
            if (self.plat_coup_dic.count>0) {
                contentlabel.text = [[NSString alloc]initWithFormat:@"%@元优惠券",self.plat_coup_dic[@"sum"]];
                if (self.Type == plat_Ware) {
                    imageView.image = [UIImage imageNamed:@"checkbox_yes"];
                }else{
                    contentlabel.text =@"";
                    
                }
            }
            
            if(([self.moneyString floatValue]<1)&&self.moneyString)
            {
                contentlabel.text = @"不可用优惠券";
            }

            
            
        }
        
    }else if (indexPath.section==3+3+1){
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(13, 12, 30, 30)];
        imageView.userInteractionEnabled = YES;
        UILabel *payLable=[[UILabel alloc]initWithFrame:CGRectMake(53, 12, 120, 30)];
        payLable.textAlignment=NSTextAlignmentLeft;
        payLable.font=[UIFont systemFontOfSize:15.0f];
        
        UIImageView *stateImg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-30-18, 12, 30, 30)];
        stateImg.userInteractionEnabled = YES;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 54-1, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(234, 234, 234);
        [cell addSubview:line];

        if (indexPath.row==payKind) {
            [stateImg setImage:[UIImage imageNamed:@"settlement_choose_n"] ];
        }else{
            [stateImg setImage:[UIImage imageNamed:@"settlement_unchoose_n"] ];
        }
        
        
        [cell addSubview:stateImg];
        
        
        [cell addSubview:payLable];
        [cell addSubview:imageView];
        if (indexPath.row==0) {
            imageView.image=[UIImage imageNamed:@"支付宝支付L"];
            payLable.text=@"支付宝支付";
        }else if (indexPath.row==1){
            imageView.image=[UIImage imageNamed:@"银联支付L"];
            payLable.text=@"银联支付";
        }else if (indexPath.row==2){
            imageView.image=[UIImage imageNamed:@"钱包支付L"];
            payLable.text=@"钱包支付";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section<=3) {

        NSArray *arr = self.cardList_mutab[indexPath.section];
           _selectIndexPath = indexPath;
        self.moneyString=arr[indexPath.row][@"price"];
        
        self.coup_dic = nil;
        
        [self.myTable reloadData];
        
        self.card_dic=arr[indexPath.row];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        appdelegate.cardInfo_dic=arr[indexPath.row];
        
        
        if (_selectIndexPath.section==2) {
            [self getOptionsRequets];

        }
        
    }
    if (indexPath.section==2+3+1)
    {
        //优惠方式
        
        if(indexPath.row == 0)
        {
            if(!((([self.moneyString floatValue])/2)<1)){
//                self.pay_Type=@"rp";
                if (self.Type == points) {
                    self.Type = 888;
                    
                }else{
                    self.Type = points;
                    
                }
                self.coup_dic=nil;
                self.plat_coup_dic = nil;
                [self.myTable reloadData];
            }
        }else if(indexPath.row == 1)
        {
            if(!([self.moneyString floatValue]<1))
            {
                
                self.plat_coup_dic = nil;

                if (self.Type == Wares) {
                    self.Type = 888;
                    [self.myTable reloadData];
                    
                    
                }else{
                    MyCashCouponViewController *choiceView = [[MyCashCouponViewController alloc]init];
                    choiceView.muid =  self.card_dic[@"muid"];
                    choiceView.moneyString = self.moneyString;
                    choiceView.useCoupon = 100;
                    choiceView.delegate = self;
                    [self.navigationController pushViewController:choiceView animated:YES];
                }
                
                
            }
            
        }else if(indexPath.row ==2){
            
            
            
            if(!([self.moneyString floatValue]<1))
            {
                self.coup_dic=nil;

                if (self.Type == plat_Ware) {
                    self.Type = 888;
                    [self.myTable reloadData];
                    
                    
                }else{
                    
                    PlatCouponsVC *VC = [[PlatCouponsVC alloc]init];
                    VC.block = ^(NSDictionary *couponInfo) {
                        
                       self.plat_coup_dic = couponInfo;
                        self.Type = plat_Ware;

//                        self.pay_Type=@"scp";

                        NSLog(@"=====%@",self.plat_coup_dic);
                        
                        
                        self.canUsePoint =0;
                        
                        NSString* price =self.plat_coup_dic[@"sum"];
                        
                        if ([self.moneyString floatValue]>=[price floatValue]) {
                            self.contentLabel.text = [[NSString alloc]initWithFormat:@"实付款:%.2f",([self.moneyString floatValue]-[price floatValue])];
                            
                        }

                        
                        [self.myTable reloadData];

                        
                    };
                    VC.moneyString = self.moneyString;
                    VC.useCoupon = 100;
                    VC.muid =  self.card_dic[@"muid"];
                    
                    
                    [self.navigationController pushViewController:VC animated:YES];

                }
                
                
            }

            
            
        }
        
    }
    if (indexPath.section==3+3+1) {
        //支付方式
        
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
        
    }else if(self.Type==plat_Ware)
    {
        NSString* price =self.plat_coup_dic[@"sum"];
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
    
    NSLog(@"_selectIndexPath------%@",_selectIndexPath);
    
    
        [self postIfBuyCard];
 
}


-(void)postIfBuyCard{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/authGet",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:_card_dic[@"muid"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"auth_sum_get.php %@",result);
        NSArray*arr_A =   [result[@"remain"] componentsSeparatedByString:@"元"];
        NSArray *card_price = [_card_dic[@"price"] componentsSeparatedByString:@"元"];
        
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
    
    [params setObject:self.card_dic[@"muid"] forKey:@"muid"];
    [params setObject:self.card_dic[@"code"] forKey:@"cardCode"];
    [params setObject:self.card_dic[@"level"] forKey:@"cardLevel"];
    [params setObject:self.card_dic[@"type"] forKey:@"cardType"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@",result);
        if ([result[@"result_code"] isEqualToString:@"false"])
        {
            [self choicePayType];
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
        
        
        if (_selectIndexPath.section==2 || _selectIndexPath.section==3) {
            
            [self buyUseAlipayForMealOrExperience];
        }else{
            [self initAlipayInfo];
            
        }
    }else if (payKind==1){
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        appdelegate.paymentType =1;
        
        
        //购买套餐卡 OR 体验卡
        
        if (_selectIndexPath.section==2 || _selectIndexPath.section==3) {
            
            [self postBuyMealCardREquest];
        }else{
            [self postPaymentsRequest];
 
        }
        
    }else if (payKind==2){
        
        float actMoney1 =[[self.contentLabel.text substringFromIndex:4] floatValue];//实际支付钱

        
        if (self.walletRemain >=actMoney1) {
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"钱包余额充足,是否支付?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
                //购买套餐卡 OR 体验卡
                
                if (_selectIndexPath.section==2 || _selectIndexPath.section==3) {
                    
                    [self payUseTheWalletBuyMealOrExperienceCard];
                }else{
                    [self payUseTheWallet];
                    
                }

                
            }];

            
            [alertVC addAction:cancelAction];
            [alertVC addAction:sureAction];
            
            [self presentViewController:alertVC animated:YES completion:nil];
            
            
        }else{
            [self showHint:@"钱包余额不足,请充值!"];
        }
        
    }
    
}


/*
 银联购买套餐卡
 **/
-(void)postBuyMealCardREquest{
    
    
    NSString *url;
    [self showHUd];

#ifdef DEBUG
    if (_selectIndexPath.section==2) {
        url = @"http://101.201.100.191/unionpay/demo/api_05_app/MealCardBuy.php";
        
    }
    if (_selectIndexPath.section==3) {
        url = @"http://101.201.100.191/unionpay/demo/api_05_app/ExperienceCardBuy.php";
        
    }
    
    
#else
    if (_selectIndexPath.section==2) {
        url = @"http://101.201.100.191/upacp_demo_app/demo/api_05_app/MealCardBuy.php";
        
    }
    if (_selectIndexPath.section==3) {
        url = @"http://101.201.100.191/upacp_demo_app/demo/api_05_app/ExperienceCardBuy.php";
        
    }
    
    
#endif
    
    
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*params = [NSMutableDictionary dictionary];

    [params setObject:self.card_dic[@"muid"] forKey:@"muid"];
    [params setObject:app.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:_card_dic[@"code"] forKey:@"code"];
    [params setObject:self.moneyString forKey:@"pay_sum"];

    
    //实际支付价格.没有×100
    
    if (self.Type==Wares)
    {
        //使用商户自己的优惠券,sum为抵扣后的值,即实际支付的价格,其他不变
        
        [params setObject:@"cp" forKey:@"pay_type"];
        [params setObject:self.coup_dic[@"coupon_id"] forKey:@"content"];
        [params setObject:[self.contentLabel.text substringFromIndex:4] forKey:@"pay_sum"];
    }
    else if (self.Type == points)
    {//使用红包
        [params setObject:@"rp" forKey:@"pay_type"];
        [params setObject:[[NSString alloc]initWithFormat:@"%.f",self.canUsePoint] forKey:@"content"];
    }else if(self.Type ==plat_Ware){
        //使用平台优惠券
        [params setObject:@"scp" forKey:@"pay_type"];
        [params setObject:self.plat_coup_dic[@"id"] forKey:@"content"];
        
    }else
    {
        [params setObject:@"null" forKey:@"pay_type"];
    }
    //实付金额×100
    NSInteger actMoney1 =[[self.contentLabel.text substringFromIndex:4] floatValue]*100;
    NSString *actMoney = [[NSString alloc]initWithFormat:@"%ld",actMoney1];
    [params setObject:actMoney forKey:@"txnAmt"];
    
   

    
    NSLog(@"购买套餐卡-----%@==%@",params,url);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [self hideHud];
        NSLog(@"银联支付===%@", result);
        NSArray *arr = result;
        if ([arr[0] isKindOfClass:[NSString class]]) {
#ifdef DEBUG
            [[UPPaymentControl defaultControl] startPay:[arr objectAtIndex:0] fromScheme:@"blectShop" mode:@"01" viewController:self];
            
            
#else
            [[UPPaymentControl defaultControl] startPay:[arr objectAtIndex:0] fromScheme:@"blectShop" mode:@"00" viewController:self];
            
            
#endif
        }else{
            
            [self showHint:@"银联支付失败!请联系技术员"];
        }
        

        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHud];

        NSLog(@"error%@", error);
        
    }];

    
}


/**
 钱包购买套餐卡或体验卡
 */

-(void)payUseTheWalletBuyMealOrExperienceCard{
    
    
    [self showHudInView:self.view hint:@"加载中..."];
    
    
    NSString *url;
    if (_selectIndexPath.section==2) {
        url = [NSString stringWithFormat:@"%@UserType/wallet/meal_buy",BASEURL];

    }
    if (_selectIndexPath.section==3) {
        url = [NSString stringWithFormat:@"%@UserType/wallet/experience_buy",BASEURL];
 
    }
    
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    
    [params setObject:self.card_dic[@"muid"] forKey:@"muid"];
    [params setObject:app.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:_card_dic[@"code"] forKey:@"code"];
    [params setObject:self.moneyString forKey:@"sum"];

    
    //实际支付价格.没有×100
    
    if (self.Type==Wares)
    {
        //使用商户自己的优惠券,sum为抵扣后的值,即实际支付的价格,其他不变
        [params setObject:[self.contentLabel.text substringFromIndex:4] forKey:@"sum"];

        [params setObject:@"cp" forKey:@"pay_type"];
        [params setObject:self.coup_dic[@"coupon_id"] forKey:@"content"];
    }
    else if (self.Type == points)
    {//使用红包
        [params setObject:@"rp" forKey:@"pay_type"];
        [params setObject:[[NSString alloc]initWithFormat:@"%.f",self.canUsePoint] forKey:@"content"];
    }else if(self.Type ==plat_Ware){
        //使用平台优惠券
        [params setObject:@"scp" forKey:@"pay_type"];
        [params setObject:self.plat_coup_dic[@"id"] forKey:@"content"];
        
    }else
    {
        [params setObject:@"null" forKey:@"pay_type"];
    }
    //实付金额
    [params setObject:[self.contentLabel.text substringFromIndex:4] forKey:@"pay_sum"];

    
    NSLog(@"params----%@==%@",params,url);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result----%@",result);
        
        [self hideHud];
        if ([result[@"result_code"] intValue]==1) {
            
            
            PaySuccessVc *VC = [[PaySuccessVc alloc]init];
            VC.orderInfoType = self.orderInfoType;
            VC.card_dic = self.card_dic;
            if (self.Type== Wares) {
                VC.money_str = [self.contentLabel.text substringFromIndex:4];
                
            }else{
                VC.money_str = self.card_dic[@"price"];
                
            }
            
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
 使用钱包支付
 */

-(void)payUseTheWallet{

    
    [self showHudInView:self.view hint:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@UserType/wallet/card_buy",BASEURL];
    
    
    NSMutableDictionary*params = [NSMutableDictionary dictionary];

    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.cardInfo_dic[@"muid"] forKey:@"muid"];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:appdelegate.cardInfo_dic[@"code"] forKey:@"code"];
    [params setObject:appdelegate.cardInfo_dic[@"level"] forKey:@"level"];
    [params setObject:appdelegate.cardInfo_dic[@"type"] forKey:@"cate"];
    
    
    [params setObject:@"办卡" forKey:@"type"];
    //实际支付价格.没有×100
    [params setObject:self.moneyString forKey:@"sum"];
    
    if (self.Type==Wares)
    {
        //使用商户自己的优惠券,sum为抵扣后的值,即实际支付的价 格,其他不变
        [params setObject:[self.contentLabel.text substringFromIndex:4] forKey:@"sum"];
        
        [params setObject:@"cp" forKey:@"pay_type"];
        [params setObject:self.coup_dic[@"coupon_id"] forKey:@"content"];
    }
    else if (self.Type == points)
    {//使用红包
        [params setObject:@"rp" forKey:@"pay_type"];
        [params setObject:[[NSString alloc]initWithFormat:@"%.f",self.canUsePoint] forKey:@"content"];
    }else if(self.Type ==plat_Ware){
        //使用平台优惠券
        [params setObject:@"scp" forKey:@"pay_type"];
        [params setObject:self.plat_coup_dic[@"id"] forKey:@"content"];
        
    }else
    {
        [params setObject:@"null" forKey:@"pay_type"];
    }
    //实付金额×100
    NSInteger actMoney1 =[[self.contentLabel.text substringFromIndex:4] floatValue];
    NSString *actMoney = [[NSString alloc]initWithFormat:@"%ld",actMoney1];
    [params setObject:actMoney forKey:@"pay_sum"];
    
    NSString *colorS = appdelegate.cardInfo_dic[@"template"];
    
    [params setObject:[colorS substringFromIndex:1] forKey:@"image_url"];
    

    NSLog(@"params----%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result----%@",result);

        [self hideHud];
        if ([result[@"result_code"] intValue]==1) {
            
            
            PaySuccessVc *VC = [[PaySuccessVc alloc]init];
            VC.orderInfoType = self.orderInfoType;
            VC.card_dic = self.card_dic;
            if (self.Type== Wares) {
                VC.money_str = [self.contentLabel.text substringFromIndex:4];
                
            }else{
                VC.money_str = self.card_dic[@"price"];
                
            }
            
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
    [self showHUd];
    
#ifdef DEBUG
    NSString *url = @"http://101.201.100.191//unionpay/demo/api_05_app/TPConsume.php";
    
    
#else
    NSString *url = @"http://101.201.100.191//upacp_demo_app/demo/api_05_app/TPConsume.php";
    
    
#endif
    
    //    NSString *url = @"http://101.201.100.191//upacp_demo_app/demo/api_05_app/TPConsume.php";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.cardInfo_dic[@"muid"] forKey:@"muid"];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:appdelegate.cardInfo_dic[@"code"] forKey:@"code"];
    [params setObject:appdelegate.cardInfo_dic[@"level"] forKey:@"level"];
    [params setObject:appdelegate.cardInfo_dic[@"type"] forKey:@"cate"];
    
    
    [params setObject:@"办卡" forKey:@"type"];
    //实际支付价格.没有×100
    [params setObject:self.moneyString forKey:@"sum"];

    if (self.Type==Wares)
    {
        //使用商户自己的优惠券,sum为抵扣后的值,即实际支付的价格,其他不变
        [params setObject:[self.contentLabel.text substringFromIndex:4] forKey:@"sum"];

        [params setObject:@"cp" forKey:@"pay_type"];
        [params setObject:self.coup_dic[@"coupon_id"] forKey:@"content"];
    }
    else if (self.Type == points)
    {//使用红包
        [params setObject:@"rp" forKey:@"pay_type"];
        [params setObject:[[NSString alloc]initWithFormat:@"%.f",self.canUsePoint] forKey:@"content"];
    }else if(self.Type ==plat_Ware){
        //使用平台优惠券
        [params setObject:@"scp" forKey:@"pay_type"];
        [params setObject:self.plat_coup_dic[@"id"] forKey:@"content"];

    }else
    {
        [params setObject:@"null" forKey:@"pay_type"];
    }
    //实付金额×100
    NSInteger actMoney1 =[[self.contentLabel.text substringFromIndex:4] floatValue]*100;
    NSString *actMoney = [[NSString alloc]initWithFormat:@"%ld",actMoney1];
    [params setObject:actMoney forKey:@"txnAmt"];
    
    NSString *colorS = appdelegate.cardInfo_dic[@"template"];
    
    [params setObject:[colorS substringFromIndex:1] forKey:@"image_url"];
    
    
 
    
    
    NSLog(@"params-----%@",params);
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [self hideHud];
        NSLog(@"银联支付===%@", result);
        NSArray *arr = result;
        
        if ([arr[0] isKindOfClass:[NSString class]]) {
            
#ifdef DEBUG
            [[UPPaymentControl defaultControl] startPay:[arr objectAtIndex:0] fromScheme:@"blectShop" mode:@"01" viewController:self];
            
            
#else
            [[UPPaymentControl defaultControl] startPay:[arr objectAtIndex:0] fromScheme:@"blectShop" mode:@"00" viewController:self];
            
            
#endif
        }else{
            
            [self showHint:@"银联支付失败!请联系技术员"];
        }
        

        
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHud];

        NSLog(@"error%@", error);
        
    }];
    
}
- (void)handlePaymentResult:(NSURL*)url completeBlock:(UPPaymentResultBlock)completionBlock

{
    
    NSLog(@"UPPaymentResultBlock====%@",completionBlock);
    
}



/**
 使用支付宝买套餐卡或体验卡
 */
-(void)buyUseAlipayForMealOrExperience{
    
    

    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
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

    
    NSString *outtrade =[[NSString alloc]initWithFormat:@"%@%5d",dateString,x];
    NSLog(@"%@",outtrade);
    order.outTradeNO = outtrade; //订单ID（由商家自行制定）
    order.subject = @"办卡"; //商品标题
    

    if (self.Type==Wares) {
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@",@"cp",appdelegate.userInfoDic[@"uuid"],_card_dic[@"muid"],_card_dic[@"code"],self.coup_dic[@"coupon_id"],[self.contentLabel.text substringFromIndex:4]];
        
    }else if (self.Type==plat_Ware) {
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@",@"scp",appdelegate.userInfoDic[@"uuid"],_card_dic[@"muid"],_card_dic[@"code"],self.plat_coup_dic[@"id"],_card_dic[@"price"]];
        
    }else if (self.Type == points) {
        
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@",@"rp",appdelegate.userInfoDic[@"uuid"],_card_dic[@"muid"],_card_dic[@"code"],[[NSString alloc]initWithFormat:@"%.f",self.canUsePoint],_card_dic[@"price"]];
        
    }else{
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@",@"null",appdelegate.userInfoDic[@"uuid"],_card_dic[@"muid"],_card_dic[@"code"],@"null",_card_dic[@"price"]];
    }
    
    NSLog(@"order.body====%@",order.body);
    

//    order.totalFee = [self.contentLabel.text substringFromIndex:4]; //商品价格
    order.totalFee = @"0.01"; //商品价格

    if (_selectIndexPath.section==2) {
        order.notifyURL =  @"http://101.201.100.191/alipay/meal_card_buy.php"; //回调URL

    }
    if (_selectIndexPath.section==3) {
    order.notifyURL =  @"http://101.201.100.191/alipay/experience_card_buy.php"; //回调URL

    }

    
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
                 if (self.Type== Wares) {
                     VC.money_str = [self.contentLabel.text substringFromIndex:4];
                     
                 }else{
                     VC.money_str = self.card_dic[@"price"];
                     
                 }
                 
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
    
       if (self.Type==Wares) {
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@#%@",@"cp",@"办卡",appdelegate.cardInfo_dic[@"code"],appdelegate.cardInfo_dic[@"level"],appdelegate.cardInfo_dic[@"type"],@"template",appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"muid"],[self.contentLabel.text substringFromIndex:4],self.coup_dic[@"coupon_id"]];
        
    }else if (self.Type==plat_Ware) {
        
            order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@#%@",@"scp",@"办卡",appdelegate.cardInfo_dic[@"code"],appdelegate.cardInfo_dic[@"level"],appdelegate.cardInfo_dic[@"type"],@"template",appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"muid"],appdelegate.cardInfo_dic[@"price"],self.plat_coup_dic[@"id"]];
            
        }else if (self.Type == points) {
        
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@#%@",@"rp",@"办卡",appdelegate.cardInfo_dic[@"code"],appdelegate.cardInfo_dic[@"level"],appdelegate.cardInfo_dic[@"type"],@"template",appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"muid"],appdelegate.cardInfo_dic[@"price"],[[NSString alloc]initWithFormat:@"%.f",self.canUsePoint]];
        
    }else{
        
        order.body =[[NSString alloc]initWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@",@"null",@"办卡",appdelegate.cardInfo_dic[@"code"],appdelegate.cardInfo_dic[@"level"],appdelegate.cardInfo_dic[@"type"],@"template",appdelegate.userInfoDic[@"uuid"],appdelegate.cardInfo_dic[@"muid"],appdelegate.cardInfo_dic[@"price"]];
    }
    
    NSLog(@"order.body====%@",order.body);
  
    /*order.body====null#u_4aca13ed4b#m_d7c116a9cc#exp_ad0472e3124#null#200
    2017-07-19 15:16:10.049234+0800 BletcShop[3784:1211240] orderSpec = partner="2088221757537814"&seller_id="13488199837@163.com"&out_trade_no="2017071903161045352"&subject="办卡"&body="null#u_4aca13ed4b#m_d7c116a9cc#exp_ad0472e3124#null#200"&total_fee="0.01"&notify_url="http://101.201.100.191/alipay/experience_card_buy.php"&service="mobile.securitypay.pay"&payment_type="1"&_input_charset="utf-8"&it_b_pay="30m"&show_url="m.alipay.com"
     */
    
//    order.totalFee = [self.contentLabel.text substringFromIndex:4];
    
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
             NSLog(@"BuyCardChoicePayViewControllerreslut = %@",resultDic);
             NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
             if (orderState==9000) {
                 
                 PaySuccessVc *VC = [[PaySuccessVc alloc]init];
                 VC.orderInfoType = self.orderInfoType;
                 VC.card_dic = self.card_dic;
                 if (self.Type== Wares) {
                     VC.money_str = [self.contentLabel.text substringFromIndex:4];
                     
                 }else{
                     VC.money_str = self.card_dic[@"price"];
                     
                 }
                 
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
                if (_selectIndexPath.section==2 || _selectIndexPath.section==3) {
                    
                    [self buyUseAlipayForMealOrExperience];
                }else{
                    [self initAlipayInfo];
                    
                }
            }else if (payKind==1){
                
                //购买套餐卡
                
                if (_selectIndexPath.section==2||_selectIndexPath.section==3) {
                    
                    [self postBuyMealCardREquest];
                }else{
                    [self postPaymentsRequest];
                    
                }

                
                
            }
            if (payKind==2) {
                
                
                if (_selectIndexPath.section==2||_selectIndexPath.section==3) {
                    
                    [self payUseTheWalletBuyMealOrExperienceCard];
                }else{
                    [self payUseTheWallet];
                    
                }

                
            }
            
        }
    }
    
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


-(void)getOptionsRequets{
    
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/MealCard/showOption",BASEURL];
    
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.card_dic[@"muid"] forKey:@"muid"];
    
    [paramer setValue:self.card_dic[@"code"] forKey:@"code"];
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result-----%@",result);
        
        self.optionsList_mutab = result;
        
        [self.myTable reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationNone];
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];

}

@end
