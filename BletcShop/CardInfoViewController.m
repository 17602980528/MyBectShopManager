//
//  CardInfoViewController.m
//  BletcShop
//
//  Created by Bletc on 16/4/20.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CardInfoViewController.h"
#import "LandingController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "BuyCardChoicePayViewController.h"
#import "OrderInfomaViewController.h"//订单详情
#import "SettlementViewController.h"

@interface CardInfoViewController ()

@end

@implementation CardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"卡片信息";
    NSLog(@"%@",self.card_dic);
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appdelegate.cardInfo_dic = self.card_dic;
    

    [self initTableView];

    
}

-(void)initTableView
{
    UITableView *cardTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStyleGrouped];
    cardTableView.delegate = self;
    cardTableView.dataSource = self;
    cardTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cardTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:cardTableView];
    self.cardTableView = cardTableView;
    self.cardTableView.bounces = NO;
}
//代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    
    switch (section) {
        case 0:
            row = 1;
            break;
        case 1:
            row = 1;
            break;
    }
    
    return row;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 0.01;
    else if (section ==1 )
        return 10;
    
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
            return 100;
            break;
        case 1:
        {
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            //
            //                NSLog(@"cell height %f",cell.frame.size.height);
            //
            return cell.frame.size.height;
        }
            break;
        default:
            break;
    }
    return 44;
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
    if (indexPath.section == 0) {
        UIImageView *cardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, SCREENWIDTH/3, 80)];
        cardImageView.layer.cornerRadius = 10;
        cardImageView.layer.masksToBounds = YES;

        if (![self.card_dic[@"card_image_url"] isEqualToString:@""]&&![self.card_dic[@"card_image_url"] isEqualToString:@"(null)"]&&self.card_dic[@"card_image_url"]!=nil)
        {
//            if ([self.card_dic[@"image_type"] isEqualToString:@"0"]) {
//                NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPCARD stringByAppendingString:self.card_dic[@"card_image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//                [cardImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon2.png"] options:SDWebImageRetryFailed];
//            }else
//            {
                NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCECARD stringByAppendingString:self.card_dic[@"card_image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [cardImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon2.png"] options:SDWebImageRetryFailed];
//            }
            

        }
        
        [cell addSubview:cardImageView];
        UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/3+50, 10, SCREENWIDTH/3+30, 90)];
        //infoView.backgroundColor = tableViewBackgroundColor;
        infoView.layer.cornerRadius = 7;
        
        //类型
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 50, 20)];
        typeLabel.font = [UIFont systemFontOfSize:10];
        typeLabel.text = @"类型:";
        [infoView addSubview:typeLabel];
        UILabel *typeLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 50, 20)];
        typeLabel1.font = [UIFont systemFontOfSize:10];
        typeLabel1.text = self.card_dic[@"type"];
        [infoView addSubview:typeLabel1];
        //级别
        UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 20, 50, 20)];
        levelLabel.font = [UIFont systemFontOfSize:10];
        levelLabel.text = @"级别:";
        [infoView addSubview:levelLabel];
        UILabel *levelLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, 50, 20)];
        levelLabel1.font = [UIFont systemFontOfSize:10];
        levelLabel1.text = self.card_dic[@"level"];
        [infoView addSubview:levelLabel1];
        //余额balance
        UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, 50, 20)];
        balanceLabel.font = [UIFont systemFontOfSize:10];
        balanceLabel.text = @"价格:";
        [infoView addSubview:balanceLabel];
        UILabel *balanceLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 40, 50, 20)];
        balanceLabel1.font = [UIFont systemFontOfSize:10];
        balanceLabel1.text = self.card_dic[@"price"];
        [infoView addSubview:balanceLabel1];
        //
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextBtn.frame = CGRectMake(5, 63, 80, 20);
        nextBtn.backgroundColor = NavBackGroundColor;
        nextBtn.layer.cornerRadius = 10;
        [nextBtn setTitle:@"我要办卡" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [nextBtn addTarget:self action:@selector(buyCardAction) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:nextBtn];
        //其他
//        UILabel *otherLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 60, 50, 20)];
//        otherLabel.font = [UIFont systemFontOfSize:10];
//        otherLabel.text = @"其他:";
//        [infoView addSubview:otherLabel];
//        UILabel *otherLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 60, 50, 20)];
//        otherLabel1.font = [UIFont systemFontOfSize:10];
//        otherLabel1.text = @"---";
//        [infoView addSubview:otherLabel1];
        [cell addSubview:infoView];
        

    }
    else
    {
        UILabel *nameLb = [[UILabel alloc]initWithFrame:CGRectMake(10,5,150,15)];
        nameLb.text =@"优惠内容";
        nameLb.textColor = [UIColor orangeColor];
        [nameLb setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
//        UILabel *starLb = [[UILabel alloc]initWithFrame:CGRectMake(0,25,100,20)];
//        [starLb setTextAlignment:NSTextAlignmentLeft];
        
        UILabel *contentLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 310, 20)];
        [contentLb setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
        contentLb.numberOfLines = 0;
        [contentLb setLineBreakMode:NSLineBreakByWordWrapping];
        contentLb.text =self.card_dic[@"content"];
       
        CGRect frame = [cell frame];
        CGRect labelSize = [contentLb.text boundingRectWithSize:CGSizeMake(310, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:13.0f],NSFontAttributeName, nil] context:nil];
        contentLb.frame = CGRectMake(contentLb.frame.origin.x, contentLb.frame.origin.y, labelSize.size.width, labelSize.size.height);
        [cell addSubview:contentLb];
        [cell addSubview:nameLb];
        frame.size.height = labelSize.size.height+48;
        cell.frame = frame;
        
    }
    return cell;
}
-(void)buyCardAction
{
  
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (!appdelegate.IsLogin) {
        
        LandingController *landVc = [[LandingController alloc]init];
        [self.navigationController pushViewController:landVc animated:YES];
    }else
    {
        [self postIfBuyCard];
        
    }
}
-(void)postIfBuyCard
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/authGet",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params setObject:self.card_dic[@"merchant"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"auth_sum_get.php %@",result);
      NSArray*arr_A =   [result[@"remain"] componentsSeparatedByString:@"元"];
        NSArray *card_price = [self.card_dic[@"price"] componentsSeparatedByString:@"元"];
        
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

-(void)NewAddVipAction
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView]];
    
    // Modify the parameters
    
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"去支付", @"取消", nil]];
    
    
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}
- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    self.demoView = demoView;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 50)];
    
    label.font = [UIFont systemFontOfSize:13];
    [demoView addSubview:label];
    label.text = [[NSString alloc]initWithFormat:@"卡片类型:%@",self.card_dic[@"card_image_url"] ];
    label.textAlignment = NSTextAlignmentCenter;
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 250, 0.3)];
    line2.backgroundColor = [UIColor grayColor];
    line2.alpha = 0.3;
    [demoView addSubview:line2];
    
    //密码
    UILabel *phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 250, 50)];
    phonelabel.textAlignment = NSTextAlignmentCenter;
    phonelabel.font = [UIFont systemFontOfSize:13];
    [demoView addSubview:phonelabel];
    phonelabel.text = [[NSString alloc]initWithFormat:@"卡片级别:%@",self.card_dic[@"card_image_url"] ];
    UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 290, 0.3)];
    linePhone.backgroundColor = [UIColor grayColor];
    linePhone.alpha = 0.3;
    [demoView addSubview:linePhone];
    //权限
    UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 250, 50)];
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.font = [UIFont systemFontOfSize:13];
    [demoView addSubview:levelLabel];
    levelLabel.text = [[NSString alloc]initWithFormat:@"应付金额:%@",self.card_dic[@"card_image_url"] ];
    
    return demoView;
}

-(void)choicePayType
{
    
    

    SettlementViewController *VC = [[SettlementViewController alloc]init];
    VC.moneyString = self.card_dic[@"price"];
    VC.card_dic = self.card_dic;


    [self.navigationController pushViewController:VC animated:YES];

//    OrderInfomaViewController *orderInfoView = [[OrderInfomaViewController alloc]init];
//    
//    orderInfoView.moneyString = self.card_dic[@"price"];
//    
//    orderInfoView.orderInfoType=1;
//    
//    orderInfoView.card_dic = self.card_dic;
//    
//    [self.navigationController pushViewController:orderInfoView animated:YES];
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (alertView.tag==0&&buttonIndex==1) {
        [alertView close];
    }
    else if (alertView.tag==0&&buttonIndex==0)
    {
        [self choicePayType];
        
    }
    [alertView close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
