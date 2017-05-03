//
//  CardManagerViewController.m
//  BletcShop
//
//  Created by Bletc on 16/4/13.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CardManagerViewController.h"
#import "UIImageView+WebCache.h"
#import "RechargeViewController.h"
#import "UpgradeViewController.h"
#import "DelayViewController.h"
#import "OrderViewController.h"
#import "ShareCardViewController.h"
#import "ComplaintVC.h"

#import "PayMentController.h"
#import "UPgradeVC.h"
//eric
#import "TransferOwnershipViewController.h"
#import "CardEricShareViewController.h"
#import "CheckTransferStateAndEditOrRemoveCardViewController.h"
@interface CardManagerViewController ()
{
    NSDictionary *cardInfo_dic;
    CGFloat heights;
    NSArray *titles_array;
    NSArray *imageNameArray;
}
@end

@implementation CardManagerViewController

-(NSMutableArray *)cardInfoArray2{
    if (!_cardInfoArray2) {
        _cardInfoArray2 = [NSMutableArray array];
        
    }
    return _cardInfoArray2;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    
    [self postRequestAllInfo];
    
    
}


-(void)postRequestAllInfo
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/detailGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [params setObject:self.card_dic[@"merchant"] forKey:@"muid"];
    [params setObject:appdelegate.cardInfo_dic[@"card_level"] forKey:@"cardLevel"];
    [params setObject:self.card_dic[@"card_code"] forKey:@"cardCode"];
    
    
    
    NSLog(@"---%@",appdelegate.cardInfo_dic);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        cardInfo_dic = [NSDictionary dictionaryWithDictionary:result];
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        appdelegate.cardInfo_dic = cardInfo_dic;
        
        cardInfo_dic = result;
        [self.CardInfotable reloadData];
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title = @"会员卡";
    
    titles_array = @[@"我要续卡",@"我要升级",@"申请延期",@"我要预约",@"家庭共享",@"卡片转让",@"我要分享",@"投诉理赔"];
    imageNameArray=@[@"vip_renewal_n",@"vip_upgrade_n",@"vip_delay_n",@"vip_order_n",@"vip_share_n",@"VIP_icon_sha_n",@"VIP_icon_ref_n",@"VIP_icon_comp_n"];
    
    [self _inittable];
    
}
-(void)_inittable
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = 104;
//    table.bounces = NO;
    self.CardInfotable = table;
    [self.view addSubview:table];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
        
        return titles_array.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return heights;
    }
    else
    {
        if (indexPath.row==2 && ![self.card_dic[@"indate"] isEqualToString:@"yes"]) {
            return 0.01;

        }else{
            return 50;

        }
       
    }
        
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else if (section==1){
        return 10;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;

    }
    
    if (indexPath.section==0&&indexPath.row==0) {
        if (cardInfo_dic) {
            
            for (UIView *view in cell.subviews) {
                [view removeFromSuperview];
            }
            UIImageView *cardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, SCREENWIDTH-40, 200*(SCREENWIDTH-40)/336.0)];
            cardImageView.layer.cornerRadius = 10;
            cardImageView.layer.masksToBounds = YES;
            cardImageView.layer.borderWidth = 0.5;
            cardImageView.layer.borderColor = RGB(234, 234, 234).CGColor;
            
            cardImageView.backgroundColor = [UIColor colorWithHexString:cardInfo_dic[@"card_temp_color"]];
            
//            NSString *imageAddress=[NSString getTheNoNullStr:cardInfo_dic[@"card_image_url"] andRepalceStr:@"1"];
//            NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCECARD stringByAppendingString:imageAddress] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//            
//            [cardImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon2.png"] options:SDWebImageRetryFailed];
            
            [cell addSubview:cardImageView];
            
            UILabel *typeAndeLevel = [[UILabel alloc]initWithFrame:CGRectMake(12, 30, cardImageView.width-12, 23)];
            typeAndeLevel.textColor = RGB(255,255,255);
            typeAndeLevel.text = [NSString stringWithFormat:@"%@(%@)",cardInfo_dic[@"card_type"],cardInfo_dic[@"card_level"]];
            typeAndeLevel.font = [UIFont systemFontOfSize:22];
            [cardImageView addSubview:typeAndeLevel];
            
            UILabel *yueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, cardImageView.height-49-21-30, cardImageView.width-12, 21)];
            yueLabel.textColor = RGB(255,255,255);
            yueLabel.textAlignment = NSTextAlignmentRight;
            yueLabel.font = [UIFont systemFontOfSize:27];
            [cardImageView addSubview:yueLabel];

            if ([[cardInfo_dic objectForKey:@"card_type"] isEqualToString:@"计次卡"]) {
                NSString *oneString = [cardInfo_dic objectForKey:@"price"];//单价
                //
                NSString *allString = [cardInfo_dic objectForKey:@"card_remain"];//余额
                
                
                double onePrice = [oneString doubleValue];
                double allPrice = [allString doubleValue];
                
                int cishu =[[cardInfo_dic objectForKey:@"rule"] intValue];
                
                int time = (int)(allPrice/(onePrice/cishu));
                //
                yueLabel.text = [[NSString alloc]initWithFormat:@"次数:%d",time];
                
                
            }else{
                yueLabel.text = [[NSString alloc]initWithFormat:@"余额:%@",cardInfo_dic[@"card_remain"]];
            }


            
            
            UIView *downView=[[UIView alloc]initWithFrame:CGRectMake(0, cardImageView.height - 49, cardImageView.width, 49)];
            downView.backgroundColor=[UIColor whiteColor];
            [cardImageView addSubview:downView];

            
            UILabel *deadLine =[[UILabel alloc]initWithFrame:CGRectMake(15, downView.top-40, cardImageView.width, 40)];
            NSString *deadString = cardInfo_dic[@"date_end"];
            if (deadString.length>10) {
                deadString = [deadString substringToIndex:10];
            }
            deadLine.text = deadString;
            deadLine.textColor = [UIColor whiteColor];
            deadLine.font = [UIFont systemFontOfSize:12];
            [cardImageView addSubview:deadLine];

            
            
            UILabel *shopName=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, downView.width-91-12, downView.height)];
            shopName.text=[NSString getTheNoNullStr:cardInfo_dic[@"store"] andRepalceStr:@""];
            shopName.textColor= RGB(51, 51, 51);
            [downView addSubview:shopName];

            
            UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cardImageView.frame)+10, SCREENWIDTH, 16)];
            typeLabel.font = [UIFont systemFontOfSize:17];
            typeLabel.textAlignment=NSTextAlignmentCenter;
            typeLabel.text = [NSString stringWithFormat:@"%@ (%@)",[NSString getTheNoNullStr:cardInfo_dic[@"card_level"] andRepalceStr:@"---"],[NSString getTheNoNullStr:cardInfo_dic[@"card_type"] andRepalceStr:@"---"]];
            [cell addSubview:typeLabel];
            heights=cardImageView.height+46;
            
            
        }
    }
    else if (indexPath.section==1)
    {
        cell.textLabel.text=titles_array[indexPath.row];
        cell.imageView.image=[UIImage imageNamed:imageNameArray[indexPath.row]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 50-1, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(220,220,220);
        [cell.contentView addSubview:line];
        
        if (indexPath.row==2 && ![self.card_dic[@"indate"] isEqualToString:@"yes"]) {
            
            cell.textLabel.hidden = YES;
            cell.imageView.hidden = YES;
            cell.accessoryType=UITableViewCellAccessoryNone;
            line.hidden = YES;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==1) {
        
        
        if (indexPath.row==0) {
            
            if ([[NSString getTheNoNullStr:cardInfo_dic[@"display_state"] andRepalceStr:@""] isEqualToString:@"off"]) {
                [self tishi:@"不能进行该操作!"];

            }else{
                [self rechargeAction];

            }
        }else if (indexPath.row==1){
            
            if ([[NSString getTheNoNullStr:cardInfo_dic[@"display_state"] andRepalceStr:@""] isEqualToString:@"off"] ) {

                [self tishi:@"不能进行该操作!"];

            }else{
                [self postRequestUpgrade];

            }
        }else if (indexPath.row==2){
            
              [self delayAction];

        }else if (indexPath.row==3){
            [self postRequestOrder];
        }else if (indexPath.row==4){
            [self shareCard];
        }else if(indexPath.row==5){
            NSLog(@"%@",cardInfo_dic);
            if ([cardInfo_dic[@"state"] isEqualToString:@"null"]) {
                //没转让也没分享
                TransferOwnershipViewController *transferOwnershipVC=[[TransferOwnershipViewController alloc]init];
                transferOwnershipVC.dic=self.card_dic;
                [self.navigationController pushViewController:transferOwnershipVC animated:YES];

            }else if ([cardInfo_dic[@"state"] isEqualToString:@"transfer"]){
                //转让没分享,去查看编辑页面
                //去下个页面
                CheckTransferStateAndEditOrRemoveCardViewController *vc=[[CheckTransferStateAndEditOrRemoveCardViewController alloc]init];
                vc.index=0;
                vc.state=0;
//                vc.realMoney=realMoney;
//                vc.disCount=disCount;
                vc.dic = cardInfo_dic;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([cardInfo_dic[@"state"] isEqualToString:@"share"]){
                //分享没转让
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"该卡已分享，转让需取消分享", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                [hud hideAnimated:YES afterDelay:2.f];
            }
            
        }else if (indexPath.row==6){
            
            if ([cardInfo_dic[@"card_type"] isEqualToString:@"储值卡"] && [cardInfo_dic[@"rule"] integerValue] !=100) {
                
                if ([cardInfo_dic[@"state"] isEqualToString:@"null"]){
                    CardEricShareViewController *transferOwnershipVC=[[CardEricShareViewController alloc]init];
                    transferOwnershipVC.dic = cardInfo_dic;
                    [self.navigationController pushViewController:transferOwnershipVC animated:YES];
                    
                }else if ([cardInfo_dic[@"state"] isEqualToString:@"share"]){
                    //分享转让没转让,去查看编辑页面
                    //去下个页面
                    CheckTransferStateAndEditOrRemoveCardViewController *vc=[[CheckTransferStateAndEditOrRemoveCardViewController alloc]init];
                    vc.index=1;
                    vc.state=0;
                    //                vc.realMoney=realMoney;
                    //                vc.disCount=disCount;
                    vc.dic = cardInfo_dic;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([cardInfo_dic[@"state"] isEqualToString:@"transfer"]){
                    //分享没转让
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = NSLocalizedString(@"该卡已转让，分享需取消转让", @"HUD message title");
                    hud.label.font = [UIFont systemFontOfSize:13];
                    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                    [hud hideAnimated:YES afterDelay:2.f];
                }
  
            }else{
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                if ([cardInfo_dic[@"card_type"] isEqualToString:@"计次卡"]){
                    hud.label.text = NSLocalizedString(@"计次卡不能分享!", @"HUD message title");
                }else if ([cardInfo_dic[@"rule"] integerValue] ==100){
                    hud.label.text = NSLocalizedString(@"没有折扣的储值卡,不能分享!", @"HUD message title");
                }
                hud.label.font = [UIFont systemFontOfSize:13];
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                [hud hideAnimated:YES afterDelay:2.f];
                
            }
            
            
            
        }else if(indexPath.row==7)
        {
            
            ComplaintVC *VC = [[ComplaintVC alloc]init];
            VC.card_info = cardInfo_dic;
            
            [self.navigationController pushViewController:VC animated:YES];
        }else{
            
            
            
        }
    }
}
/**
 共享会员卡
 */
-(void)shareCard{
    NSLog(@"共享会员卡");
    
    ShareCardViewController *VC = [[ShareCardViewController alloc]init];
    VC.card_dic = cardInfo_dic;
    [self.navigationController pushViewController:VC animated:YES];
    
}
/**
 预约
 */
-(void)postRequestOrder
{
    //获取商家的商品列表
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/commodity/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    

    [params setObject:cardInfo_dic[@"merchant"] forKey:@"muid"];
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result = %@", result);
        
        OrderViewController *orderView = [[OrderViewController alloc]init];
        orderView.allClassArray =[NSMutableArray arrayWithArray:result];
        orderView.card_dic = cardInfo_dic;
        
        
        [self.navigationController pushViewController:orderView animated:YES];
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

/**
 续卡
 */
-(void)rechargeAction
{
    RechargeViewController *rechargeView = [[RechargeViewController alloc]init];
    rechargeView.card_dic = cardInfo_dic;
    [self.navigationController pushViewController:rechargeView animated:YES];
}

/**
 升级
 */

-(void)postRequestUpgrade
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/card/levelGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:cardInfo_dic[@"merchant"] forKey:@"muid"];
    [params setObject:cardInfo_dic[@"card_code"] forKey:@"code"];
    
    
    DebugLog(@"url=%@---%@",url,params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        
        UPgradeVC *upgradeView = [[UPgradeVC alloc]init];
        upgradeView.card_dic = cardInfo_dic;
        upgradeView.resultArray = [result copy];
        [self.navigationController pushViewController:upgradeView animated:YES];

        
        
//        UpgradeViewController *upgradeView = [[UpgradeViewController alloc]init];
//        upgradeView.card_dic = cardInfo_dic;
//        upgradeView.resultArray = [result copy];
//        [self.navigationController pushViewController:upgradeView animated:YES];
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}




/**
 延期
 */
-(void)delayAction
{
    DelayViewController *delayView = [[DelayViewController alloc]init];
    delayView.card_dic = cardInfo_dic;
    [self.navigationController pushViewController:delayView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tishi:(NSString*)ts{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = NSLocalizedString(ts, @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:1.f];
    
}

@end
